function year_history(anno){
	with control{
		//Paises nuevos
		for(var a = 1; a < array_length(paises); a++){
			var pais = paises[a]
			if anno >= pais.inicio and (pais.fin = 0 or anno < pais.fin) and not array_contains(pais_current, pais){
				array_push(pais_current, pais)
				add_noticia("Nuevo país", $"Has establecido relaciones diplomáticas con {pais.nombre}")
			}
		}
		//Paises que dejan de existir
		for(var a = 0; a < array_length(pais_current); a++){
			var pais = pais_current[a], text = ""
			if pais.fin > 0 and anno >= pais.fin{
				for(var b = 0; b < array_length(recurso_nombre); b++){
					for(var c = 0; c < array_length(recurso_tratados_venta[b]); c++){
						var tratado = recurso_tratados_venta[b, c]
						if tratado.pais = pais{
							text += $"\nVender {tratado.cantidad} de {recurso_nombre[tratado.recurso]}"
							array_delete(recurso_tratados_venta[b], c--, 1)
							tratados_num--
						}
					}
					for(var c = 0; c < array_length(recurso_tratados_compra[b]); c++){
						var tratado = recurso_tratados_compra[b, c]
						if tratado.pais = pais{
							text += $"\nComprar {tratado.cantidad} de {recurso_nombre[tratado.recurso]}"
							array_delete(recurso_tratados_compra[b], c--, 1)
							tratados_num--
						}
					}
				}
				for(var b = 0; b < array_length(tratados_ofertas); b++)
					if tratados_ofertas[b].pais = pais
						array_delete(tratados_ofertas, b--, 1)
				add_noticia("País destruido", $"Se han perdido las relaciones diplomáticas con {pais.nombre}{text = "" ? "" : "\nTratados perdidos:" + text}")
				array_delete(pais_current, a--, 1)
			}
		}
		//Recursos nuevos
		for(var a = 0; a < array_length(recurso_nombre); a++)
			if anno >= recurso_anno[a] and not array_contains(recurso_current, a)
				array_push(recurso_current, a)
		//Nuevas guerras
		for(var a = 0; a < array_length(guerras); a++){
			var guerra = guerras[a]
			if anno >= guerra.inicio and (guerra.fin = 0 or anno < guerra.fin) and not array_contains(guerras_current, guerra){
				array_push(guerras_current, guerra)
				for(var b = 0; b < array_length(guerra.bando_a); b++)
					if array_contains(pais_current, guerra.bando_a[b])
						array_push(guerra.bando_a[b].guerras, guerra)
				for(var b = 0; b < array_length(guerra.bando_b); b++)
					if array_contains(pais_current, guerra.bando_b[b])
						array_push(guerra.bando_b[b].guerras, guerra)
				add_noticia("Nueva guerra", $"Ha emprezado la guerra {guerra.nombre}")
			}
		}
		//Fin de las guerras
		for(var a = 0; a < array_length(guerras_current); a++){
			var guerra = guerras_current[a]
			if guerra.fin = 0 or anno >= guerra.fin{
				for(var b = 0; b < array_length(guerra.bando_a); b++)
					if array_contains(pais_current, guerra.bando_a[b]) and array_contains(guerra.bando_a[b].guerras, guerra)
						array_remove(guerra.bando_a[b].guerras, guerra, "Eliminar guerra de un país")
				for(var b = 0; b < array_length(guerra.bando_b); b++)
					if array_contains(pais_current, guerra.bando_b[b]) and array_contains(guerra.bando_b[b].guerras, guerra)
						array_remove(guerra.bando_b[b].guerras, guerra, "Eliminar guerra de un país")
				add_noticia("Guerra terminada", $"Ha terminado la guerra {guerra.nombre}")
				array_delete(guerras_current, a--, 1)
			}
		}
		//Efectos de tecnologias en los precios
		for(var a = 0; a < array_length(mejoras); a++){
			var mejora = mejoras[a]
			if mejora.anno > anno - 5 and mejora.anno < anno + 5{
				for(var b = 0; b < array_length(mejora.recurso_id); b++)
					recurso_precio[mejora.recurso_id[b]] *= random_range(0.99, 1)
				for(var b = 0; b < array_length(mejora.recursos_efecto); b++)
					recurso_precio[b] *= random_range(1, mejora.recursos_factor)
			}
		}
		probabilidad_hijos = anno / 100
		//Leyes
		izquierda_extrema = 3
		derecha_extrema = 3
		autoritario_extremo = 3
		libertario_extremo = 3
		var b = 0
		for(var a = 0; a < array_length(ley_nombre); a++)
			if (dia / 365) > ley_anno[a]{
				b++
				var c = ley_economia[a], d = ley_sociocultural[a]
				if c <= 3{
					izquierda_extrema += c
					derecha_extrema += 6 - c
				}
				else{
					izquierda_extrema += 6 - c
					derecha_extrema += c
				}
				if d <= 3{
					libertario_extremo += d
					autoritario_extremo += 6 - d
				}
				else{
					libertario_extremo += 6 - d
					autoritario_extremo += d
				}
		}
		izquierda_extrema /= b
		derecha_extrema /= b
		autoritario_extremo /= b
		libertario_extremo /= b
	}
}
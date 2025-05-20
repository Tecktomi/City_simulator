function year_history(anno){
	with control{
		//Paises nuevos
		for(var a = 1; a < array_length(pais_nombre); a++)
			if anno >= pais_inicio[a] and (pais_fin[a] = 0 or anno < pais_fin[a]) and not array_contains(pais_current, a){
				array_push(pais_current, a)
				array_push(pais_relacion, 0)
				add_noticia("Nuevo país", $"Has establecido relaciones diplomáticas con {pais_nombre[a]}")
			}
		//Paises que dejan de existir
		for(var a = 0; a < array_length(pais_current); a++){
			var d = pais_current[a], text = ""
			if pais_fin[d] > 0 and anno >= pais_fin[d]{
				for(var b = 0; b < array_length(recurso_nombre); b++){
					for(var c = 0; c < array_length(recurso_tratados_venta[b]); c++){
						var tratado = recurso_tratados_venta[b, c]
						if tratado.pais = d{
							text += $"\nVender {tratado.cantidad} de {recurso_nombre[tratado.recurso]}"
							array_delete(recurso_tratados_venta[b], c--, 1)
							tratados_num--
						}
					}
					for(var c = 0; c < array_length(recurso_tratados_compra[b]); c++){
						var tratado = recurso_tratados_compra[b, c]
						if tratado.pais = d{
							text += $"\nComprar {tratado.cantidad} de {recurso_nombre[tratado.recurso]}"
							array_delete(recurso_tratados_compra[b], c--, 1)
							tratados_num--
						}
					}
				}
				for(var b = 0; b < array_length(tratados_ofertas); b++)
					if tratados_ofertas[b].pais = d
						array_delete(tratados_ofertas, b--, 1)
				add_noticia("País destruido", $"Se han perdido las relaciones diplomáticas con {pais_nombre[d]}{text = "" ? "" : "\nTratados perdidos:" + text}")
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
					array_push(pais_guerras[guerra.bando_a[b]], guerra)
				for(var b = 0; b < array_length(guerra.bando_b); b++)
					array_push(pais_guerras[guerra.bando_b[b]], guerra)
				add_noticia("Nueva guerra", $"Ha emprezado la guerra {guerra.nombre}")
			}
		}
		//Fin de las guerras
		for(var a = 0; a < array_length(guerras_current); a++){
			var guerra = guerras_current[a]
			if guerra.fin = 0 or anno >= guerra.fin{
				for(var b = 0; b < array_length(guerra.bando_a); b++)
					array_remove(pais_guerras[guerra.bando_a[b]], guerra, "Eliminar guerra de un país")
				for(var b = 0; b < array_length(guerra.bando_b); b++)
					array_remove(pais_guerras[guerra.bando_b[b]], guerra, "Eliminar guerra de un país")
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
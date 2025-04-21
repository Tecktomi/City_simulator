function year_history(anno){
	with control{
		//Paises nuevos
		for(var a = 1; a < array_length(pais_nombre); a++)
			if anno >= pais_inicio[a] and (pais_fin[a] = 0 or anno < pais_fin[a]) and not array_contains(pais_current, a){
				array_push(pais_current, a)
				array_push(pais_relacion, 0)
				if debug
					show_debug_message($"Añadido: {pais_nombre[a]}")
			}
		//Paises que dejan de existir
		for(var a = 0; a < array_length(pais_current); a++){
			var d = pais_current[a]
			if pais_fin[d] > 0 and anno >= pais_fin[d]{
				for(var b = 0; b < array_length(recurso_nombre); b++)
					for(var c = 0; c > array_length(recurso_tratados_venta[b]); c++)
						if recurso_tratados_venta[b, c].pais = d
							array_delete(recurso_tratados_venta[b], c--, 1)
				if debug
					show_debug_message($"Elimiado: {pais_nombre[d]}")
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
				if debug
					show_debug_message($"Eliminada la guerra {guerra.nombre}")
				array_delete(guerras_current, a--, 1)
			}
		}
	}
}
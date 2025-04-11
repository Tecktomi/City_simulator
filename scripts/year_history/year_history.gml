function year_history(anno){
	with control{
		//Paises nuevos
		for(var a = 1; a < array_length(pais_nombre); a++)
			if anno >= pais_inicio[a] and (pais_fin[a] = 0 or anno < pais_fin[a]) and not array_contains(pais_current, a){
				array_push(pais_current, a)
				array_push(pais_relacion, 0)
				show_debug_message($"Añadido: {pais_nombre[a]}")
			}
		//Paises que dejan de existir
		for(var a = 0; a < array_length(pais_current); a++){
			var d = pais_current[a]
			if pais_fin[d] > 0 and anno >= pais_fin[d]{
				for(var b = 0; b < array_length(recurso_nombre); b++)
					for(var c = 0; c > array_length(recurso_tratados[b]); c++)
						if recurso_tratados[b, c].pais = d
							array_delete(recurso_tratados[b], c--, 1)
				show_debug_message($"Elimiado: {pais_nombre[d]}")
				array_delete(pais_current, a--, 1)
			}
		}
		//Recursos nuevos
		for(var a = 0; a < array_length(recurso_nombre); a++)
			if anno >= recurso_anno[a] and not array_contains(recurso_current, a)
				array_push(recurso_current, a)
	}
}
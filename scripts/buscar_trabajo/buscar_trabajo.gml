function buscar_trabajo(persona = control.null_persona){
	with control{
		if debug
			show_debug_message(fecha(dia) + $" buscar_trabajo ({name(persona)})")
		if array_length(trabajos) > 0{
			var trabajo = null_edificio
			for(var a = persona.educacion; a >= 0; a--)
				if array_length(trabajo_educacion[a]) > 0{
					trabajo = trabajo_educacion[a, irandom(array_length(trabajo_educacion[a]) - 1)]
					var c = 0, b = 0
					if not in(persona.trabajo, null_edificio, jubilado, delincuente){
						c = calcular_felicidad_transporte(persona.familia.casa, trabajo)
						b = calcular_felicidad_transporte(persona.familia.casa, persona.trabajo)
					}
					if trabajo != persona.trabajo and (trabajo.trabajo_calidad + c) > (persona.trabajo.trabajo_calidad / (1 + persona.trabajo.paro) + b) and (persona.religion or not edificio_es_iglesia[trabajo.tipo]) and ((persona.sexo and not persona.religion) or not (edificio_nombre[trabajo.tipo] = "Cabaret")){
						cambiar_trabajo(persona, trabajo)
						return true
					}
				}
		}
		return false
	}
}
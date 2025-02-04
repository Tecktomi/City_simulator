function buscar_trabajo(persona = control.null_persona){
	with control{
		if array_length(trabajos) > 0{
			var trabajo = null_edificio
			if persona.familia.casa = homeless
				trabajo = trabajos[irandom(array_length(trabajos) - 1)]
			else if array_length(persona.familia.casa.trabajos_cerca) > 0
				trabajo = persona.familia.casa.trabajos_cerca[irandom(array_length(persona.familia.casa.trabajos_cerca) - 1)]
			if trabajo != persona.trabajo and not trabajo.paro and array_length(trabajo.trabajadores) < edificio_trabajadores_max[trabajo.tipo] and trabajo.trabajo_calidad > persona.trabajo.trabajo_calidad / (1 + persona.trabajo.paro) and edificio_trabajo_educacion[trabajo.tipo] <= persona.educacion and (persona.religion or not edificio_es_iglesia[trabajo.tipo]){
				cambiar_trabajo(persona, trabajo)
				return true
			}
		}
		return false
	}
}
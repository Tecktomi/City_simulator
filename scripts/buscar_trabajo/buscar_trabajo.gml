function buscar_trabajo(persona = control.null_persona){
	if array_length(control.trabajos) > 0{
		var trabajo = control.null_edificio
		if persona.familia.casa = control.homeless
			trabajo = control.trabajos[irandom(array_length(control.trabajos) - 1)]
		else if array_length(persona.familia.casa.trabajos_cerca) > 0
			trabajo = persona.familia.casa.trabajos_cerca[irandom(array_length(persona.familia.casa.trabajos_cerca) - 1)]
		if trabajo != persona.trabajo and not trabajo.paro and array_length(trabajo.trabajadores) < control.edificio_trabajadores_max[trabajo.tipo] and control.edificio_trabajo_calidad[trabajo.tipo] > control.edificio_trabajo_calidad[persona.trabajo.tipo] / (1 + persona.trabajo.paro) and control.edificio_trabajo_educacion[trabajo.tipo] <= persona.educacion and (persona.religion or not edificio_es_iglesia[trabajo.tipo]){
			cambiar_trabajo(persona, trabajo)
			return true
		}
	}
	return false
}
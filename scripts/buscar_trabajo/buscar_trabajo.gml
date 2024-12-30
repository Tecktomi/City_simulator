function buscar_trabajo(persona = control.null_persona){
	var trabajo = control.null_edificio
	if persona.familia.casa = control.homeless
		trabajo = control.trabajos[irandom(array_length(control.trabajos) - 1)]
	else if array_length(persona.familia.casa.trabajos_cerca) > 0
		trabajo = persona.familia.casa.trabajos_cerca[irandom(array_length(persona.familia.casa.trabajos_cerca) - 1)]
	if trabajo != persona.trabajo and array_length(trabajo.trabajadores) < control.edificio_trabajadores_max[trabajo.tipo] and control.edificio_trabajo_calidad[trabajo.tipo] > control.edificio_trabajo_calidad[persona.trabajo.tipo] and control.edificio_trabajo_educacion[trabajo.tipo] <= persona.educacion{
		cambiar_trabajo(persona, trabajo)
		return true
	}
	return false
}
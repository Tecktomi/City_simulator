function cambiar_trabajo(persona = control.null_persona, trabajo = control.null_edificio){
	with control{
		if persona.trabajo != null_edificio and array_length(persona.trabajo.trabajadores) = edificio_trabajadores_max[persona.trabajo.tipo]
			array_push(trabajo_educacion[edificio_trabajo_educacion[persona.trabajo.tipo]], persona.trabajo)
		array_remove(persona.trabajo.trabajadores, persona)
		persona.familia.sueldo -= persona.trabajo.trabajo_sueldo
		persona.trabajo = trabajo
		persona.familia.sueldo += persona.trabajo.trabajo_sueldo
		array_push(trabajo.trabajadores, persona)
		if trabajo != null_edificio{
			if array_length(trabajo.trabajadores) = edificio_trabajadores_max[trabajo.tipo]
				array_remove(trabajo_educacion[edificio_trabajo_educacion[trabajo.tipo]], trabajo)
			if persona.familia.casa != homeless
				persona.felicidad_transporte = 10000 / (100 + 3 * distancia(persona.familia.casa, trabajo))
		}
	}
}
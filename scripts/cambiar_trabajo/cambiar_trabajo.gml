function cambiar_trabajo(persona = control.null_persona, trabajo = control.null_edificio){
	array_remove(persona.trabajo.trabajadores, persona)
	persona.familia.sueldo -= persona.trabajo.trabajo_sueldo
	persona.trabajo = trabajo
	persona.familia.sueldo += persona.trabajo.trabajo_sueldo
	array_push(trabajo.trabajadores, persona)
	if trabajo != null_edificio and persona.familia.casa != homeless
		persona.felicidad_transporte = 10000 / (100 + 3 * distancia(persona.familia.casa, trabajo))
}
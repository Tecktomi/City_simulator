function cambiar_escuela(persona = control.null_persona, escuela = control.null_edificio){
	if persona.escuela != null_edificio{
		array_remove(persona.escuela.clientes, persona, "expulsado de la escuela")
		persona.familia.sueldo += persona.escuela.servicio_tarifa
	}
	persona.escuela = escuela
	if escuela != null_edificio{
		array_push(escuela.clientes, persona)
		persona.familia.sueldo -= persona.escuela.servicio_tarifa
		persona.felicidad_transporte = calcular_felicidad_transporte(persona.familia.casa, escuela)
	}
}
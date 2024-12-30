function destroy_persona(persona = control.null_persona, muerte = true){
	var  flag = false
	array_remove(control.personas, persona)
	array_remove(control.cumples[persona.cumple], persona)
	if persona.pareja != control.null_persona
		persona.pareja = control.null_persona
	var familia = persona.familia
	familia.sueldo -= control.edificio_trabajo_sueldo[persona.trabajo.tipo]
	if familia.padre = persona
		 familia.padre = control.null_persona
	else if familia.madre = persona
		 familia.madre = control.null_persona
	else
		array_remove(familia.hijos, persona)
	if familia.padre = control.null_persona and familia.madre = control.null_persona and array_length(familia.hijos) = 0{
		destroy_familia(familia, muerte)
		flag = true
	}
	if persona.trabajo != control.null_edificio
		array_remove(persona.trabajo.trabajadores, persona)
	if persona.embarazo != -1
		array_remove(control.embarazo[persona.embarazo], persona)
	if persona.muerte != -1 and persona.muerte != (control.dia mod 365)
		array_remove(control.muerte[persona.muerte], persona)
	if persona.escuela != control.null_edificio
		array_remove(persona.escuela.clientes, persona)
	if persona.medico != control.null_edificio{
		array_remove(persona.medico.clientes, persona)
		if array_length(control.desausiado.clientes) > 0{
			var temp_persona = array_shift(control.desausiado.clientes)
			array_push(persona.medico.clientes, temp_persona)
			temp_persona.medico = persona.medico
		}
	}
	if array_length(control.personas) > 0
		control.felicidad_total = (control.felicidad_total * (array_length(control.personas) + 1) - persona.felicidad) / array_length(control.personas)
	else{
		show_message("HAS PERDIDO\n\nNo queda nadie en el país")
		if show_question("Volver a jugar?")
			game_restart()
		else
			game_end()
	}
	persona.relacion.vivo = false
	return flag
}
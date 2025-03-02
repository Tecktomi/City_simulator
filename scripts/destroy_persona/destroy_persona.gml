function destroy_persona(persona = null_persona, muerte = true){
	with control{
		var  flag = false
		array_remove(personas, persona)
		array_remove(cumples[persona.cumple], persona)
		if persona.pareja != null_persona
			persona.pareja = null_persona
		var familia = persona.familia
		familia.sueldo -= persona.trabajo.trabajo_sueldo
		if familia.padre = persona
			familia.padre = null_persona
		else if familia.madre = persona
			familia.madre = null_persona
		else{
			array_remove(familia.hijos, persona)
			for(var a = 0; a < array_length(familia.hijos); a++)
				if familia.hijos[a].trabajo != null_edificio{
					flag = true
					break
				}
			if not flag{
				add_felicidad_ley(familia.padre, 10)
				add_felicidad_ley(familia.madre, 10)
			}
		}
		flag = false
		familia.integrantes--
		if familia.integrantes = 0{
			destroy_familia(familia, muerte)
			flag = true
			var b = 0
			for(var a = 0; a < array_length(persona.relacion.hijos); a++){
				var hijo = persona.relacion.hijos[a]
				if hijo.vivo
					b++
			}
			if b > 0{
				var text = name(persona) + " ha muero, y sus hijos "
				for(var a = 0; a < array_length(persona.relacion.hijos); a++){
					var hijo = persona.relacion.hijos[a]
					if hijo.vivo{
						hijo.persona.familia.dinero += persona.familia.dinero / b
						text += name(hijo.persona) + ", "
					}
				}
				persona.familia.dinero = 0
				show_debug_message(text + " han recibido una herencia")
			}
		}
		if persona.trabajo != null_edificio{
			cambiar_trabajo(persona, null_edificio)
			array_remove(null_edificio.trabajadores, persona)
		}
		if persona.embarazo != -1
			array_remove(embarazo[persona.embarazo], persona)
		if persona.muerte != -1 and persona.muerte != (dia mod 365)
			array_remove(control.muerte[persona.muerte], persona)
		if persona.escuela != null_edificio
			array_remove(persona.escuela.clientes, persona)
		if persona.medico != null_edificio{
			array_remove(persona.medico.clientes, persona)
			if array_length(desausiado.clientes) > 0{
				var temp_persona = null_persona
				temp_persona = array_shift(desausiado.clientes)
				array_push(persona.medico.clientes, temp_persona)
				temp_persona.medico = persona.medico
			}
		}
		if array_length(personas) > 0
			felicidad_total = (felicidad_total * (array_length(personas) + 1) - persona.felicidad) / array_length(personas)
		else{
			show_message("HAS PERDIDO\n\nNo queda nadie en el país")
			if show_question("Volver a jugar?")
				game_restart()
			else
				game_end()
		}
		persona.relacion.vivo = false
		persona.relacion.persona = undefined
		return flag
		}
}
function destroy_persona(persona = null_persona, muerte = true, motivo = ""){
	with control{
		if debug
			show_debug_message(fecha(dia) + $" destroy_persona ({name(persona)}) ({motivo})")
		var  flag = false
		array_remove(personas, persona, "eliminar persona")
		array_remove(cumples[persona.cumple], persona, "eliminar persona de los cumpleaños")
		if persona.pareja != null_persona
			persona.pareja = null_persona
		var familia = persona.familia
		familia.sueldo -= persona.trabajo.trabajo_sueldo
		if familia.padre = persona
			familia.padre = null_persona
		else if familia.madre = persona
			familia.madre = null_persona
		else
			array_remove(familia.hijos, persona, "eliminar hijos")
		flag = false
		familia.integrantes--
		if familia.integrantes = 0{
			if persona.empresa != null_empresa
				destroy_empresa(persona.empresa)
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
		else if persona.pareja != null_persona and persona.empresa != null_empresa
			persona.empresa.jefe = persona.pareja
		if persona.trabajo != null_edificio{
			cambiar_trabajo(persona, null_edificio)
			array_remove(null_edificio.trabajadores, persona, "eliminar persona del trabajo")
		}
		if persona.embarazo != -1
			array_remove(embarazo[persona.embarazo], persona, "eliminar persona embarazada")
		if persona.muerte != -1 and persona.muerte != (dia mod 365)
			array_remove(control.muerte[persona.muerte], persona, "eliminar persona que iba a morir")
		if persona.escuela != null_edificio
			array_remove(persona.escuela.clientes, persona, "eliminar persona de la escuela")
		if persona.medico != null_edificio{
			if debug
				show_debug_message($"{fecha(dia)} {name(persona)} eliminad" + (persona.sexo ? "a" : "o") + $" de la lista de espera en {persona.medico.nombre}")
			array_remove(persona.medico.clientes, persona, "eliminar persona del médico")
			traer_paciente_en_espera(persona.medico)
		}
		if persona.ladron != null_edificio
			persona.ladron.ladron = null_persona
		if array_length(personas) > 0
			felicidad_total = (felicidad_total * (array_length(personas) + 1) - persona.felicidad) / array_length(personas)
		else{
			show_message("HAS PERDIDO\n\nNo queda nadie en el país")
			if show_question("Volver a jugar?")
				game_restart()
			else
				game_end()
		}
		if elecciones and persona.candidato
			delete_candidato(persona)
		persona.relacion.vivo = false
		persona.relacion.persona = undefined
		return flag
		}
}
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
		}
		if persona.trabajo != null_edificio{
			var trabajo = persona.trabajo
			array_remove(trabajo.trabajadores, persona)
			if not trabajo.paro and not array_contains(trabajo_educacion[edificio_trabajo_educacion[trabajo.tipo]], trabajo)
				array_push(trabajo_educacion[edificio_trabajo_educacion[trabajo.tipo]], trabajo)
		}
		if persona.embarazo != -1
			array_remove(embarazo[persona.embarazo], persona)
		if persona.muerte != -1 and persona.muerte != (dia mod 365)
			array_remove(muerte[persona.muerte], persona)
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
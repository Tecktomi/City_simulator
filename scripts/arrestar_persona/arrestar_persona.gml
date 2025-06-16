function arrestar_persona(persona = control.null_persona, tiempo = 12){
	with control{
		var edificio = null_edificio
		for(var a = 0; a < array_length(edificio_count[65]); a++){
			var temp_edificio = edificio_count[65, a]
			if array_length(temp_edificio.clientes) < temp_edificio.servicio_max{
				edificio = temp_edificio
				break
			}
		}
		if edificio = null_edificio
			for(var a = 0; a < array_length(edificio_count[34]); a++){
				var temp_edificio = edificio_count[34, a]
				if array_length(temp_edificio.clientes) < temp_edificio.servicio_max{
					edificio = temp_edificio
					break
				}
			}
		if edificio = null_edificio or array_length(edificio.clientes) >= edificio.servicio_max{
			if persona.preso{
				persona.preso = false
				cambiar_trabajo(persona, null_edificio)
			}
			return false
		}
		array_push(edificio.clientes, persona)
		array_push(edificio.array_complex, {a : tiempo, b : 0})
		persona.preso = true
		if persona.trabajo != delincuente
			cambiar_trabajo(persona, null_edificio)
		if persona.ladron != null_edificio{
			persona.ladron.ladron = null_persona
			persona.ladron = null_edificio
		}
		persona.felicidad_temporal -= 40
		if persona.pareja != null_persona
			persona.pareja.felicidad_temporal -= 25
		for(var a = 0; a < array_length(persona.familia.hijos); a++)
			persona.familia.hijos[a].felicidad_temporal -= 15
		if elecciones and persona.candidato
			delete_candidato(persona)
	}
	return true
}
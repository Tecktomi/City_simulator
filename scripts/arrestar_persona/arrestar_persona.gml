function arrestar_persona(edificio = control.null_edificio, persona = control.null_persona, tiempo = 12){
	with control{
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
}
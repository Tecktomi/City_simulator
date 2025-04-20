function delete_candidato(persona = control.null_persona){
	with control{
		persona.candidato = false
		var a = array_remove(candidatos, persona)
		array_delete(candidatos_votos, a, 1)
		if array_length(candidatos) = 0
			elecciones = false
		for(var b = 0; b < array_length(edificio_count[43]); b++){
			var edificio = edificio_count[43, b]
			if edificio.array_complex[0].a >= a
				edificio.array_complex[0].a--
		}
	}
}
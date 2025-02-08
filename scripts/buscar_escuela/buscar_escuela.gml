function buscar_escuela(persona = control.null_persona){
	with control{
		if array_length(escuelas) > 0{
			var escuela = escuelas[irandom(array_length(escuelas) - 1)]
			if array_length(escuela.clientes) < edificio_clientes_max[escuela.tipo]{
				array_push(escuela.clientes, persona)
				persona.escuela = escuela
				if persona.familia.casa != homeless
					persona.felicidad_transporte = 10000 / (100 + 3 * distancia(persona.familia.casa, escuela))
				return true
			}
		}
		persona.escuela = null_edificio
		return false
	}
}
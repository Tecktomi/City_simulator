function buscar_escuela(persona = control.null_persona){
	if array_length(control.escuelas) > 0{
		var escuela = control.escuelas[irandom(array_length(control.escuelas) - 1)]
		if array_length(escuela.clientes) < control.edificio_clientes_max[escuela.tipo]{
			array_push(escuela.clientes, persona)
			persona.escuela = escuela
			if persona.familia.casa != homeless
				persona.felicidad_transporte = 10000 / (100 + 3 * distancia(persona.familia.casa, escuela))
		}
		else
			persona.escuela = null_edificio
	}
	else
		persona.escuela = null_edificio
}
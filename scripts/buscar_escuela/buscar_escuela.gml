function buscar_escuela(persona = control.null_persona){
	with control{
		var escuela = null_edificio
		if array_length(escuelas) > 0{
			escuela = array_pick(escuelas)
			if array_length(escuela.clientes) < edificio_servicio_clientes[escuela.tipo]{
				cambiar_escuela(persona, escuela)
				return true
			}
		}
		persona.escuela = null_edificio
		return false
	}
}
function buscar_escuela(persona = control.null_persona){
	with control{
		var escuela = null_edificio
		if array_length(escuelas) > 0{
			escuela = array_pick(escuelas)
			if array_length(escuela.clientes) < escuela.servicio_max and ((persona.edad <= 18 and escuela.modo != 2) or (persona.edad > 18 and escuela.modo = 2)){
				cambiar_escuela(persona, escuela)
				return true
			}
		}
		persona.escuela = null_edificio
		return false
	}
}
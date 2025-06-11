function buscar_escuela(persona = control.null_persona){
	with control{
		var escuela = null_edificio
		if array_length(escuelas) > 0{
			escuela = array_pick(escuelas)
			if array_length(escuela.clientes) < escuela.servicio_max and persona.educacion < edificio_escuela_max[escuela.tipo] and max(0, persona.familia.riqueza) >= escuela.servicio_tarifa and (edificio_nombre[escuela.tipo] != "Escuela" or (persona.edad <= 18 and escuela.modo != 2) or (persona.edad > 18 and escuela.modo = 2)) and (edificio_nombre[escuela.tipo] != "Universidad" or persona.educacion >= 1.6){
				cambiar_escuela(persona, escuela)
				return true
			}
		}
		persona.escuela = null_edificio
		return false
	}
}
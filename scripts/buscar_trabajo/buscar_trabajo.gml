function buscar_trabajo(persona = control.null_persona){
	with control{
		if array_length(trabajos) > 0{
			var trabajo = null_edificio
			for(var a = persona.educacion; a >= 0; a--)
				if array_length(trabajo_educacion[a]) > 0{
					trabajo = trabajo_educacion[a, irandom(array_length(trabajo_educacion[a]) - 1)]
					if trabajo != persona.trabajo and trabajo.trabajo_calidad > persona.trabajo.trabajo_calidad / (1 + persona.trabajo.huelga) and (persona.religion or not edificio_es_iglesia[trabajo.tipo]){
						cambiar_trabajo(persona, trabajo)
						return true
					}
				}
		}
		return false
	}
}
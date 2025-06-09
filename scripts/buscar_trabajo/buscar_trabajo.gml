function buscar_trabajo(persona = control.null_persona){
	with control{
		if debug
			show_debug_message(fecha(dia) + $" buscar_trabajo ({name(persona)})")
		if array_length(trabajos) > 0{
			var trabajo = null_edificio
			for(var a = persona.educacion; a >= 0; a--)
				if array_length(trabajo_educacion[a]) > 0{
					trabajo = array_pick(trabajo_educacion[a])
					var c = 0, b = 0, casa = persona.familia.casa
					if not in(persona.trabajo, null_edificio, jubilado, delincuente, prostituta){
						c = calcular_felicidad_transporte(casa, trabajo)
						b = calcular_felicidad_transporte(casa, persona.trabajo)
						for(var d = 0; d < array_length(casa.carreteras); d++){
							var carretera = casa.carreteras[d]
							if carretera.taxis > 0{
								if array_contains(carretera.edificios, trabajo)
									c = (c + 100) / 2
								if array_contains(carretera.edificios, persona.trabajo)
									b = (b + 100) / 2
							}
						}
					}
					if trabajo != persona.trabajo and (trabajo.trabajo_calidad + c) > (persona.trabajo.trabajo_calidad / (1 + persona.trabajo.paro) + b) and (persona.religion or not edificio_es_iglesia[trabajo.tipo]) and ((persona.sexo and not persona.religion) or not (edificio_nombre[trabajo.tipo] = "Cabaret")){
						cambiar_trabajo(persona, trabajo)
						return true
					}
				}
		}
		return false
	}
}
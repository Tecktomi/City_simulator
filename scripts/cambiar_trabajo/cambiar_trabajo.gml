function cambiar_trabajo(persona = control.null_persona, trabajo = control.null_edificio){
	with control{
		if trabajo = null_edificio or array_length(trabajo.trabajadores) < trabajo.trabajadores_max{
			var c = 0, b = 0
			if not in(persona.trabajo, null_edificio, jubilado, delincuente, prostituta){
				c = calcular_felicidad_transporte(persona.familia.casa, trabajo)
				b = calcular_felicidad_transporte(persona.familia.casa, persona.trabajo)
			}
			if trabajo = null_edificio or (trabajo != persona.trabajo and trabajo = null_edificio or (persona.religion or not edificio_es_iglesia[trabajo.tipo]) and ((persona.sexo and not persona.religion) or not in(edificio_nombre[trabajo.tipo], "Cabaret", "Prostitución")) and persona.educacion >= trabajo.trabajo_educacion){
				if not in(persona.trabajo, null_edificio, jubilado, delincuente, prostituta) and array_length(persona.trabajo.trabajadores) = persona.trabajo.trabajadores_max and not persona.trabajo.paro
					array_push(trabajo_educacion[persona.trabajo.trabajo_educacion], persona.trabajo)
				array_remove(persona.trabajo.trabajadores, persona, "persona yendose de su trabajo")
				persona.familia.sueldo -= persona.trabajo.trabajo_sueldo
				persona.trabajo.trabajo_mes -= abs(persona.trabajo.dia_factura - (dia mod 30))
				persona.trabajo = trabajo
				persona.familia.sueldo += persona.trabajo.trabajo_sueldo
				persona.trabajo.trabajo_mes += abs(trabajo.dia_factura - (dia mod 30))
				array_push(trabajo.trabajadores, persona)
				if not in (trabajo, null_edificio, jubilado, delincuente, prostituta){
					if array_length(trabajo.trabajadores) = trabajo.trabajadores_max
						array_remove(trabajo_educacion[trabajo.trabajo_educacion], trabajo, "trabajo ya no está disponible")
					if persona.familia.casa != homeless
						persona.felicidad_transporte = calcular_felicidad_transporte(persona.familia.casa, trabajo)
				}
			}
		}
	}
}
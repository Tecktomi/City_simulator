function cambiar_casa(familia = control.null_familia, casa = control.null_edificio){
	with control{
		if debug
			show_debug_message(fecha(dia) + $" cambiar_casa ({name_familia(familia)})")
		if edificio_nombre[familia.casa.tipo] != "Toma" and familia.casa != homeless and array_length(familia.casa.familias) = edificio_familias_max[familia.casa.tipo]
			array_push(casas_libres, familia.casa)
		array_remove(familia.casa.familias, familia, "persona yendose de su casa")
		if edificio_nombre[familia.casa.tipo] = "Toma" and array_contains(casas, familia.casa)
			destroy_edificio(familia.casa)
		array_push(casa.familias, familia)
		familia.casa = casa
		if casa != homeless and edificio_nombre[casa.tipo] != "Toma" and array_length(casa.familias) = edificio_familias_max[casa.tipo]
			array_remove(casas_libres, casa, "la casa ya no está disponible")
		if casa != homeless{
			for_familia(function(persona = control.null_persona){
				persona.felicidad_transporte = calcular_felicidad_transporte(persona.familia.casa, persona.trabajo)
			}, familia, false)
			for(var a  = 0; a < array_length(familia.hijos); a++)
				if familia.hijos[a].escuela != null_edificio
					familia.hijos[a].felicidad_transporte = calcular_felicidad_transporte(casa, familia.hijos[a].escuela)
		}
	}
}
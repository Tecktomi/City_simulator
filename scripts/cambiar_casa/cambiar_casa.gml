function cambiar_casa(familia = control.null_familia, casa = control.null_edificio){
	with control{
		if edificio_nombre[familia.casa.tipo] = "Toma"
			destroy_edificio(familia.casa)
		else if familia.casa != homeless and array_length(familia.casa.familias) = edificio_familias_max[familia.casa.tipo]
			array_push(casas_libres, familia.casa)
		array_remove(familia.casa.familias, familia)
		array_push(casa.familias, familia)
		familia.casa = casa
		if familia.casa != homeless and array_length(familia.casa.familias) = edificio_familias_max[familia.casa.tipo]
			array_remove(casas_libres, familia.casa)
		if familia.casa != homeless{
			if familia.padre != null_persona and not in(familia.padre.trabajo, null_edificio, jubilado, delincuente)
				familia.padre.felicidad_transporte = 10000 / (100 + 3 * distancia(familia.casa, familia.padre.trabajo))
			if familia.madre != null_persona and not in(familia.madre.trabajo, null_edificio, jubilado, delincuente)
				familia.madre.felicidad_transporte = 10000 / (100 + 3 * distancia(familia.casa, familia.madre.trabajo))
			for(var a  = 0; a < array_length(familia.hijos); a++)
				if familia.hijos[a].escuela != null_edificio
					familia.hijos[a].felicidad_transporte = 10000 / (100 + 3 * distancia(familia.casa, familia.hijos[a].escuela))
		}
	}
}
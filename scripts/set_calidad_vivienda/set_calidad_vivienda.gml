function set_calidad_vivienda(edificio = control.null_edificio){
	var index = edificio.tipo
	with control{
		var a = edificio_familias_calidad[index] + 4 * (edificio.presupuesto - 2)
		if edificio.agua
			a += round(15 * clamp(agua_input / agua_output, 0, 1))
		if edificio.energia
			a += round(10 * clamp(energia_input / energia_output, 0, 1))
		if edificio.vivienda_renta = 0
			a += 10
		if edificio_trabajadores_max[index] > 0
			a += round(15 * array_length(edificio.trabajadores) / edificio_trabajadores_max[index])
		edificio.vivienda_calidad = max(a, 0)
	}
}
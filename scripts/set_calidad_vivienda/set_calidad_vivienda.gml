function set_calidad_vivienda(edificio = control.null_edificio){
	var index = edificio.tipo
	with control{
		edificio.vivienda_calidad = edificio_familias_calidad[index] + 4 * (edificio.presupuesto - 2)
		if edificio.tuberias
			edificio.vivienda_calidad += round(15 * min(1, agua_input / agua_output))
		if edificio_trabajadores_max[index] > 0
			edificio.vivienda_calidad += round(15 * array_length(edificio.trabajadores) / edificio_trabajadores_max[index])
	}
}

function set_calidad_servicio(edificio = control.null_edificio){
	var index = edificio.tipo
	with control{
		edificio.servicio_calidad = edificio_servicio_calidad[index] + 4 * (edificio.presupuesto - 2)
		if edificio.tuberias
			edificio.servicio_calidad += round(10 + min(1, agua_input / agua_output))
	}
}
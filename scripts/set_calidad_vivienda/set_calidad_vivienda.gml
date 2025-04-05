function set_calidad_vivienda(edificio = control.null_edificio){
	edificio.vivienda_calidad = control.edificio_familias_calidad[edificio.tipo] + 4 * (edificio.presupuesto - 2)
	if edificio.tuberias
		edificio.vivienda_calidad += round(15 * min(1, agua_input / agua_output))
}
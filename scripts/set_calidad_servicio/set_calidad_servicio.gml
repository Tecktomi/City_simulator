function set_calidad_servicio(edificio = control.null_edificio){
	var index = edificio.tipo
	with control{
		var a = edificio_servicio_calidad[index] + 4 * (edificio.presupuesto - 2)
		if edificio.agua
			a += round(10 + clamp(agua_input / agua_output, 0, 1))
		if edificio.energia
			a += round(10 + clamp(energia_input / energia_output, 0, 1))
		a *= edificio.ahorro
		edificio.servicio_calidad = max(a, 0)
	}
}
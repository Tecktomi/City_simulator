function set_calidad_servicio(edificio = control.null_edificio){
	var index = edificio.tipo
	with control{
		var a = edificio_servicio_calidad[index]
		if edificio_nombre[index] = "Periódico" and edificio.modo != -1
			a = 10
		if edificio_es_escuela[index] and edificio_nombre[index] != "Escuela Parroquial"
			a -= floor(power(2, adoctrinamiento_escuela - 1))
		a += 4 * (edificio.presupuesto - 2)
		if edificio.agua
			a += round(10 + clamp(agua_input / agua_output, 0, 1))
		if edificio.energia
			a += round(10 + clamp(energia_input / energia_output, 0, 1))
		a *= edificio.ahorro
		edificio.servicio_calidad = max(a, 0)
	}
}
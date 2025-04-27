function set_calidad_servicio(edificio = control.null_edificio){
	var index = edificio.tipo
	with control{
		var a = edificio_servicio_calidad[index] + 4 * (edificio.presupuesto - 2)
		if edificio.tuberias
			a += round(10 + clamp(agua_input / agua_output, 0, 1))
		if edificio.electricidad
			a += round(10 + clamp(energia_input / energia_output, 0, 1))
		if edificio_nombre[edificio.tipo] = "Periódico" and elecciones and edificio.array_complex[0].a >= 0
			a -= 20
		edificio.servicio_calidad = max(a, 0)
	}
}
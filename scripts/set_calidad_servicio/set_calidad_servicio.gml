function set_calidad_servicio(edificio = control.null_edificio){
	var index = edificio.tipo
	with control{
		var a = edificio_servicio_calidad[index], var_edificio_nombre = edificio_nombre[index]
		if var_edificio_nombre = "Escuela"{
			if edificio.modo = 1
				a += 20
			if adoctrinamiento_escuelas
				a -= floor(power(2, adoctrinamiento - 1))
		}
		else if var_edificio_nombre = "Universidad"{
			if adoctrinamiento_universidades
				a -= floor(power(2, adoctrinamiento - 1))
		}
		if adoctrinamiento_biblioteca and var_edificio_nombre = "Biblioteca" and edificio.modo < 2
			a -= floor(power(2, adoctrinamiento - 1))
		if in(var_edificio_nombre, "Consultorio", "Hospital") and edificio.modo = 1
			a -= 25
		if in(var_edificio_nombre, "Periódico", "Antena de Radio", "Estudio de Televisión"){
			if edificio.modo != 0
				a -= 10
			if adoctrinamiento_periodico and not edificio.privado and var_edificio_nombre = "Periódico"
				a -= floor(power(2, adoctrinamiento - 1))
		}
		a += 4 * (edificio.presupuesto - 2)
		if edificio.agua
			a += round(10 + clamp(agua_input / agua_output, 0, 1))
		if edificio.energia
			a += round(10 + clamp(energia_input / energia_output, 0, 1))
		a *= edificio.ahorro
		edificio.servicio_calidad = max(a, 0)
	}
}
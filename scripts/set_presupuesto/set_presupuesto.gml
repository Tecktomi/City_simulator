function set_presupuesto(presupuesto, edificio = control.null_edificio){
	var index = edificio.tipo
	with control{
		edificio.presupuesto = presupuesto
		edificio.mantenimiento = round(edificio_mantenimiento[index] * (1 + 0.2 * (presupuesto - 2)))
		if edificio_es_casa[index]
			set_calidad_vivienda(edificio)
		if edificio_servicio_calidad[index] != 0
			set_calidad_servicio(edificio)
		if edificio_es_trabajo[index]{
			edificio.trabajo_calidad = edificio_trabajo_calidad[index] + 3 * (presupuesto - 2)
			edificio.trabajo_sueldo = max(sueldo_minimo, edificio_trabajo_sueldo[index] + presupuesto - 2)
			edificio.trabajo_riesgo = edificio_trabajo_riesgo[index] * power(2, 3 - presupuesto)
		}
	}
}
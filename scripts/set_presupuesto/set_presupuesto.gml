function set_presupuesto(presupuesto, edificio = control.null_edificio){
	edificio.vivienda_calidad -= edificio.presupuesto
	edificio.trabajo_calidad -= 4 * edificio.presupuesto
	edificio.mantenimiento -= edificio.presupuesto
	edificio.presupuesto = presupuesto
	edificio.vivienda_calidad += edificio.presupuesto
	edificio.trabajo_calidad += 4 * edificio.presupuesto
	edificio.mantenimiento += edificio.presupuesto
	edificio.trabajo_sueldo = max(control.sueldo_minimo, edificio_trabajo_sueldo[edificio.tipo] + presupuesto - 2)
	edificio.trabajo_riesgo = control.edificio_trabajo_riesgo[edificio.tipo] * power(2, 3 - presupuesto)
}
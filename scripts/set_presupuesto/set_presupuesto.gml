function set_presupuesto(presupuesto, edificio = control.null_edificio){
	edificio.vivienda_calidad -= edificio.presupuesto
	edificio.trabajo_calidad -= 4 * edificio.presupuesto
	edificio.trabajo_sueldo -= edificio.presupuesto
	edificio.mantenimiento -= edificio.presupuesto
	edificio.presupuesto = presupuesto
	edificio.vivienda_calidad += edificio.presupuesto
	edificio.trabajo_calidad += 4 * edificio.presupuesto
	edificio.trabajo_sueldo += edificio.presupuesto
	edificio.mantenimiento += edificio.presupuesto
}
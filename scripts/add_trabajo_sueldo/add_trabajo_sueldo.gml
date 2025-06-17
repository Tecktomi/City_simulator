function add_trabajo_sueldo(sueldo, edificio = control.null_edificio){
	sueldo = max(edificio.trabajo_sueldo + sueldo, control.sueldo_minimo) - edificio.trabajo_sueldo
	if sueldo != 0
		with control{
			for(var a = 0; a < array_length(edificio.trabajadores); a++)
				edificio.trabajadores[a].familia.sueldo += sueldo
			edificio.trabajo_sueldo += sueldo
		}
}
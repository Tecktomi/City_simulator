function add_tuberias(edificio = control.null_edificio){
	var index = edificio.tipo
	with control
		if edificio.privado or dinero >= 200{
			sel_edificio.tuberias = true
			agua_output += edificio_agua[index]
			if edificio_es_casa[index]
				set_calidad_vivienda(sel_edificio)
			else
				set_calidad_servicio(sel_edificio)
			if edificio.privado{
				dinero_privado -= 200
				edificio.empresa.dinero -= 200
			}
			else{
				dinero -= 200
				mes_construccion[current_mes] += 200
			}
		}
}
function add_tuberias(edificio = control.null_edificio){
	var index = edificio.tipo
	with control
		if edificio.privado or dinero >= 400{
			recurso_construccion[12] += 20
			edificio.tuberias = true
			agua_output += edificio_agua[index]
			if edificio_es_casa[index]
				set_calidad_vivienda(edificio)
			else
				set_calidad_servicio(edificio)
			if edificio.privado{
				dinero_privado -= 400
				edificio.empresa.dinero -= 400
			}
			else{
				dinero -= 400
				mes_construccion[current_mes] += 400
			}
		}
}
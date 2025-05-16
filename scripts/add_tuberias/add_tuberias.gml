function add_tuberias(edificio = control.null_edificio){
	var index = edificio.tipo
	with control
		if edificio.privado or dinero >= 200{
			recurso_construccion[12] += 10
			edificio.agua = true
			edificio.agua_consumo += edificio_agua[index]
			agua_output += edificio_agua[index]
			if edificio_es_casa[index]
				set_calidad_vivienda(edificio)
			else
				set_calidad_servicio(edificio)
			if edificio.privado{
				dinero_privado -= 200
				edificio.empresa.dinero -= 200
			}
			else{
				dinero -= 200
				mes_construccion[current_mes] += 200
			}
			edificio.precio += 200
		}
}
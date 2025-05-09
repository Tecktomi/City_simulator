function add_energia(edificio = control.null_edificio){
	var index = edificio.tipo
	with control
		if edificio.privado or dinero >= 200{
			recurso_construccion[12] += 30
			edificio.energia = true
			edificio.energia_consumo = edificio_energia[index]
			energia_output += edificio.energia_consumo
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
		}
}
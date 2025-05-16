function add_energia(edificio = control.null_edificio){
	var index = edificio.tipo
	with control
		if edificio.privado or dinero >= 100{
			recurso_construccion[12] += 15
			edificio.energia = true
			edificio.energia_consumo = edificio_energia[index]
			energia_output += edificio.energia_consumo
			if edificio_es_casa[index]
				set_calidad_vivienda(edificio)
			else
				set_calidad_servicio(edificio)
			if edificio.privado{
				dinero_privado -= 100
				edificio.empresa.dinero -= 100
			}
			else{
				dinero -= 100
				mes_construccion[current_mes] += 100
			}
			edificio.precio += 100
		}
}
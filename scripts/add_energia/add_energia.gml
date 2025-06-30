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
			mes_construccion[current_mes] += pagar(-100, edificio, false)
		}
}
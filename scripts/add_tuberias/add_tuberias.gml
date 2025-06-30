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
			mes_construccion[current_mes] += pagar(200, edificio, false)
		}
}
function destroy_edificio(edificio = null_edificio){
	var width = control.edificio_width[edificio.tipo], height = control.edificio_height[edificio.tipo]
	for(var a = 0; a < array_length(edificio.trabajadores); a++)
		cambiar_trabajo(edificio.trabajadores[a], null_edificio)
	for(var a = 0; a < array_length(edificio.familias); a++)
		cambiar_casa(edificio.familias[a], homeless)
	if control.edificio_es_medico[edificio.tipo]{
		array_remove(control.medicos, edificio)
		for(var a = 0; a < array_length(edificio.clientes); a++)
			buscar_atencion_medica(edificio.clientes[a])
	}
	if control.edificio_es_escuela[edificio.tipo]{
		array_remove(control.escuelas, edificio)
		for(var a = 0; a < array_length(edificio.clientes); a++)
			buscar_escuela(edificio.clientes[a])
	}
	if control.edificio_es_trabajo[edificio.tipo]{
		array_remove(control.trabajos, edificio)
		for(var a = 0; a < array_length(edificio.edificios_cerca); a++)
			array_remove(edificio.edificios_cerca[a].trabajos_cerca, edificio)
	}
	if control.edificio_es_casa[edificio.tipo]{
		array_remove(control.casas, edificio)
		for(var a = 0; a < array_length(edificio.edificios_cerca); a++)
			array_remove(edificio.edificios_cerca[a].casas_cerca, edificio)
	}
	if control.edificio_es_iglesia[edificio.tipo]
		for(var a = 0; a < array_length(edificio.edificios_cerca); a++)
			array_remove(edificio.edificios_cerca[a].iglesias_cerca, edificio)
	for(var a = 0; a < array_length(edificio.edificios_cerca); a++)
		array_remove(edificio.edificios_cerca[a].edificios_cerca, edificio)
	array_remove(dia_trabajo[edificio.dia_factura], edificio)
	array_remove(control.edificio_count[edificio.tipo], edificio)
	for(var a = edificio.x; a < edificio.x + width; a++)
		for(var b = edificio.y; b < edificio.y + height; b++)
			array_set(control.bool_edificio[a], b, false)
	array_remove(control.edificios, edificio)
	if edificio.exigencia != control.null_exigencia
		array_remove(edificio.exigencia.edificios, edificio)
	//Modificar belleza
	if control.edificio_belleza[edificio.tipo] != 50{
		var size = ceil(abs(control.edificio_belleza[edificio.tipo] - 50) / 5)
		for(var a = max(0, edificio.x - size); a < min(control.xsize, edificio.x + width + size); a++)
			for(var b = max(0, edificio.y - size); b < min(control.ysize, edificio.y + height + size); b++){
				array_set(control.belleza[a], b, round(control.belleza[a, b] - (control.edificio_belleza[edificio.tipo] - 50) / (1 + distancia_punto(a, b, edificio))))
				if control.bool_edificio[a, b]{
					var edificio_2 = control.id_edificio[a, b]
					if control.edificio_es_casa[edificio_2.tipo]
						edificio_2.vivienda_calidad = control.edificio_familias_calidad[edificio_2.tipo] + round((min(100, max(0, control.belleza[a, b])) - 50) / 10)
				}
			}
	}
	//Modificar contaminacion
	if control.edificio_contaminacion[edificio.tipo] != 0{
		var size = ceil(control.edificio_contaminacion[edificio.tipo] / 5)
		for(var a = max(0, edificio.x - size); a < min(control.xsize, edificio.x + width + size); a++)
			for(var b = max(0, edificio.y - size); b < min(control.ysize, edificio.y + height + size); b++)
				array_set(control.contaminacion[a], b, round(control.contaminacion[a, b] - control.edificio_contaminacion[edificio.tipo] / (1 + distancia_punto(a, b, edificio))))
	}
}
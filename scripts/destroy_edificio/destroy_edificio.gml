function destroy_edificio(edificio = null_edificio){
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
	for(var a = 0; a < control.edificio_width[edificio.tipo]; a++)
		for(var b = 0; b < control.edificio_height[edificio.tipo]; b++)
			array_set(control.bool_edificio[edificio.x + a], edificio.y + b, false)
	array_remove(control.edificios, edificio)
	if edificio.exigencia != control.null_exigencia
		array_remove(edificio.exigencia.edificios, edificio)
}
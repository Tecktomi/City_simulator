function edificio_replace(index, edificio = control.null_edificio){
	with control{
		if debug
			show_debug_message($"{fecha(dia)} Reemplazar {edificio.nombre} por {edificio_nombre[index]}")
		x = edificio.x
		y = edificio.y
		var width = edificio.width, height = edificio.height, es_trabajo = edificio_es_trabajo[edificio.tipo], trabajadores = [null_persona], es_casa = edificio_es_casa[edificio.tipo], familias = [null_familia]
		if es_trabajo
			array_copy(trabajadores, 0, edificio.trabajadores, 0, array_length(edificio.trabajadores))
		if es_casa
			array_copy(familias, 0, edificio.familias, 0, array_length(edificio.familias))
		destroy_edificio(edificio)
		edificio = add_edificio(x, y, real(index),, width, height)
		if es_trabajo
			while array_length(trabajadores) > 0
				cambiar_trabajo(array_shift(trabajadores), edificio)
		if es_casa
			while array_length(familias) > 0
				cambiar_casa(array_shift(familias), edificio)
		return edificio
	}
}
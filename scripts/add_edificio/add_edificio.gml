function add_edificio(x = 0, y = 0, tipo = 0, fisico = true){
	var edificio = {
		familias : [control.null_familia],
		trabajadores : [control.null_persona],
		clientes : [control.null_persona],
		edificios_cerca : [control.null_edificio],
		trabajos_cerca : [control.null_edificio],
		casas_cerca : [control.null_edificio],
		iglesias_cerca : [control.null_edificio],
		almacen_cerca : [control.null_edificio],
		x : x,
		y : y,
		tipo : tipo,
		dia_factura : irandom(27),
		count : 0,
		almacen : undefined,
		eficiencia : 1,
		modo : 0,
		array_real_1 : [],
		array_real_2 : []
	}
	array_pop(edificio.familias)
	array_pop(edificio.trabajadores)
	array_pop(edificio.clientes)
	array_pop(edificio.edificios_cerca)
	array_pop(edificio.trabajos_cerca)
	array_pop(edificio.casas_cerca)
	array_pop(edificio.iglesias_cerca)
	array_pop(edificio.almacen_cerca)
	array_push(control.dia_trabajo[edificio.dia_factura], edificio)
	if fisico{
		array_push(control.edificios, edificio)
		if control.edificio_es_trabajo[tipo]
			array_push(control.trabajos, edificio)
		if control.edificio_es_escuela[tipo]
			array_push(control.escuelas, edificio)
		if control.edificio_es_medico[tipo]{
			array_push(control.medicos, edificio)
			repeat(min(control.edificio_clientes_max[tipo], array_length(control.desausiado.clientes))){
				var persona = array_shift(control.desausiado.clientes)
				array_push(edificio.clientes, persona)
				persona.medico = edificio
			}
		}
		if control.edificio_es_casa[tipo]
			array_push(control.casas, edificio)
		if control.edificio_es_iglesia[tipo]
			array_push(control.iglesias, edificio)
		array_push(control.edificio_count[tipo], edificio)
		for(var a = 0; a < array_length(control.recurso_nombre); a++)
			edificio.almacen[a] = 0
		if control.edificio_nombre[tipo] = "Aserradero"
			for(var a = max(0, x - 4); a < min(x + edificio_width[tipo] + 4, control.xsize); a++)
				for(var b = max(0, y - 4); b < min(y + edificio_height[tipo] + 4, control.ysize); b++)
					if control.bosque[a, b]{
						array_push(edificio.array_real_1, a)
						array_push(edificio.array_real_2, b)
					}
		//Buscar edificios cercanos
		for(var a = max(0, x - 8); a < min(x + edificio_width[tipo] + 9, control.xsize); a++)
			for(var b = max(0, y - 8); b < min(y + edificio_height[tipo] + 9, control.ysize); b++)
				if control.bool_edificio[a, b]{
					var temp_edificio = control.id_edificio[a, b]
					if not array_contains(edificio.edificios_cerca, temp_edificio){
						array_push(edificio.edificios_cerca, temp_edificio)
						array_push(temp_edificio.edificios_cerca, edificio)
						if control.edificio_es_trabajo[edificio.tipo]
							array_push(temp_edificio.trabajos_cerca, edificio)
						if control.edificio_es_trabajo[temp_edificio.tipo]
							array_push(edificio.trabajos_cerca, temp_edificio)
						if control.edificio_es_casa[edificio.tipo]
							array_push(temp_edificio.casas_cerca, edificio)
						if control.edificio_es_casa[temp_edificio.tipo]
							array_push(edificio.casas_cerca, temp_edificio)
						if control.edificio_es_iglesia[edificio.tipo]
							array_push(temp_edificio.iglesias_cerca, edificio)
						if control.edificio_es_iglesia[temp_edificio.tipo]
							array_push(edificio.iglesias_cerca, temp_edificio)
						if control.edificio_es_almacen[edificio.tipo]
							array_push(temp_edificio.almacen_cerca, edificio)
						if control.edificio_es_almacen[temp_edificio.tipo]
							array_push(edificio.almacen_cerca, temp_edificio)
					}
				}
		//Marcar terreno
		for(var a = 0; a < control.edificio_width[tipo]; a++)
			for(var b = 0; b < control.edificio_height[tipo]; b++){
				array_set(control.bool_edificio[x + a], y + b, true)
				array_set(control.id_edificio[x + a], y + b, edificio)
			}
	}
	return edificio
}
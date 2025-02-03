function add_edificio(x = 0, y = 0, tipo = 0, fisico = true){
	var edificio = {
		familias : [control.null_familia],
		trabajadores : [control.null_persona],
		clientes : [control.null_persona],
		edificios_cerca : [control.null_edificio],
		trabajos_cerca : [control.null_edificio],
		casas_cerca : [control.null_edificio],
		iglesias_cerca : [control.null_edificio],
		x : x,
		y : y,
		tipo : tipo,
		dia_factura : irandom(27),
		count : 0,
		almacen : undefined,
		pedido : undefined,
		eficiencia : 1,
		modo : 0,
		array_real_1 : [],
		array_real_2 : [],
		paro : false,
		paro_motivo : 0,
		paro_tiempo : 0,
		exigencia : null_exigencia,
		exigencia_fallida : false,
		privado : false,
		vivienda_calidad : control.edificio_familias_calidad[tipo],
		trabajo_calidad : control.edificio_trabajo_calidad[tipo],
		trabajo_sueldo : control.edificio_trabajo_sueldo[tipo],
		presupuesto : 3
	}
	array_pop(edificio.familias)
	array_pop(edificio.trabajadores)
	array_pop(edificio.clientes)
	array_pop(edificio.edificios_cerca)
	array_pop(edificio.trabajos_cerca)
	array_pop(edificio.casas_cerca)
	array_pop(edificio.iglesias_cerca)
	array_push(control.dia_trabajo[edificio.dia_factura], edificio)
	if fisico{
		var width = control.edificio_width[tipo], height = control.edificio_height[tipo]
		array_push(control.edificios, edificio)
		if control.edificio_es_trabajo[tipo]
			array_push(control.trabajos, edificio)
		if control.edificio_es_escuela[tipo]{
			array_push(control.escuelas, edificio)
			cumplir_exigencia(1)
		}
		if control.edificio_es_medico[tipo]{
			array_push(control.medicos, edificio)
			repeat(min(control.edificio_clientes_max[tipo], array_length(control.desausiado.clientes))){
				var persona = array_shift(control.desausiado.clientes)
				array_push(edificio.clientes, persona)
				persona.medico = edificio
			}
			cumplir_exigencia(0)
		}
		if control.edificio_es_casa[tipo]
			array_push(control.casas, edificio)
		if control.edificio_es_iglesia[tipo]{
			array_push(control.iglesias, edificio)
			cumplir_exigencia(4)
		}
		if control.edificio_es_ocio[tipo]
			cumplir_exigencia(3)
		array_push(control.edificio_count[tipo], edificio)
		for(var a = 0; a < array_length(control.recurso_nombre); a++){
			edificio.almacen[a] = 0
			edificio.pedido[a] = 0
		}
		if control.edificio_nombre[tipo] = "Aserradero"
			for(var a = max(0, x - 4); a < min(x + width + 4, control.xsize); a++)
				for(var b = max(0, y - 4); b < min(y + height + 4, control.ysize); b++)
					if control.bosque[a, b]{
						array_push(edificio.array_real_1, a)
						array_push(edificio.array_real_2, b)
					}
		//Buscar edificios cercanos
		for(var a = max(0, x - 8); a < min(x + width + 9, control.xsize); a++)
			for(var b = max(0, y - 8); b < min(y + height + 9, control.ysize); b++)
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
					}
				}
		//Marcar terreno
		for(var a = x; a < x + width; a++)
			for(var b = y; b < y + height; b++){
				array_set(control.bool_edificio[a], b, true)
				array_set(control.id_edificio[a], b, edificio)
				array_set(control.construccion_reservada[a], b, false)
			}
		//Modificar belleza
		if control.edificio_belleza[tipo] != 50{
			var size = ceil(abs(control.edificio_belleza[tipo] - 50) / 5)
			for(var a = max(0, x - size); a < min(control.xsize, x + width + size); a++)
				for(var b = max(0, y - size); b < min(control.ysize, y + height + size); b++){
					array_set(control.belleza[a], b, round(control.belleza[a, b] + (control.edificio_belleza[tipo] - 50) / (1 + distancia_punto(a, b, edificio))))
					if control.bool_edificio[a, b]{
						var edificio_2 = control.id_edificio[a, b]
						if control.edificio_es_casa[edificio_2.tipo]
							edificio_2.vivienda_calidad = control.edificio_familias_calidad[edificio_2.tipo] + round((min(100, max(0, control.belleza[a, b])) - 50) / 10)
					}
				}
		}
		//Modificar contaminacion
		if control.edificio_contaminacion[tipo] != 0{
			var size = ceil(control.edificio_contaminacion[tipo] / 5)
			for(var a = max(0, x - size); a < min(control.xsize, x + width + size); a++)
				for(var b = max(0, y - size); b < min(control.ysize, y + height + size); b++)
					array_set(control.contaminacion[a], b, round(control.contaminacion[a, b] + control.edificio_contaminacion[tipo] / (1 + distancia_punto(a, b, edificio))))
		}
	}
	return edificio
}
function add_edificio(x = 0, y = 0, tipo = 0, fisico = true){
	with control{
		var edificio = {
			familias : [null_familia],
			trabajadores : [null_persona],
			clientes : [null_persona],
			edificios_cerca : [null_edificio],
			trabajos_cerca : [null_edificio],
			casas_cerca : [null_edificio],
			iglesias_cerca : [null_edificio],
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
			huelga : false,
			huelga_motivo : 0,
			huelga_tiempo : 0,
			exigencia : null_exigencia,
			exigencia_fallida : false,
			privado : false,
			vivienda_calidad : edificio_familias_calidad[tipo],
			trabajo_calidad : edificio_trabajo_calidad[tipo],
			trabajo_sueldo : edificio_trabajo_sueldo[tipo],
			mantenimiento : edificio_mantenimiento[tipo],
			presupuesto : 2,
			mes_creacion : control.current_mes
		}
		array_pop(edificio.familias)
		array_pop(edificio.trabajadores)
		array_pop(edificio.clientes)
		array_pop(edificio.edificios_cerca)
		array_pop(edificio.trabajos_cerca)
		array_pop(edificio.casas_cerca)
		array_pop(edificio.iglesias_cerca)
		array_push(dia_trabajo[edificio.dia_factura], edificio)
		if fisico{
			var width = edificio_width[tipo], height = edificio_height[tipo]
			array_push(edificios, edificio)
			if edificio_es_trabajo[tipo]{
				array_push(trabajos, edificio)
				array_push(trabajo_educacion[edificio_trabajo_educacion[tipo]], edificio)
			}
			if edificio_es_escuela[tipo]{
				array_push(escuelas, edificio)
				cumplir_exigencia(1)
			}
			if edificio_es_medico[tipo]{
				array_push(medicos, edificio)
				repeat(min(edificio_clientes_max[tipo], array_length(desausiado.clientes))){
					var persona = null_persona
					persona = array_shift(desausiado.clientes)
					array_push(edificio.clientes, persona)
					persona.medico = edificio
				}
				cumplir_exigencia(0)
			}
			if edificio_es_casa[tipo]
				array_push(casas, edificio)
			if edificio_es_iglesia[tipo]{
				array_push(iglesias, edificio)
				cumplir_exigencia(4)
			}
			if edificio_es_ocio[tipo]
				cumplir_exigencia(3)
			array_push(edificio_count[tipo], edificio)
			for(var a = 0; a < array_length(recurso_nombre); a++){
				edificio.almacen[a] = 0
				edificio.pedido[a] = 0
			}
			if edificio_nombre[tipo] = "Aserradero"
				for(var a = max(0, x - 4); a < min(x + width + 4, xsize); a++)
					for(var b = max(0, y - 4); b < min(y + height + 4, ysize); b++)
						if bosque[a, b]{
							array_push(edificio.array_real_1, a)
							array_push(edificio.array_real_2, b)
						}
			//Buscar edificios cercanos
			for(var a = max(0, x - 8); a < min(x + width + 9, xsize); a++)
				for(var b = max(0, y - 8); b < min(y + height + 9, ysize); b++)
					if bool_edificio[a, b]{
						var temp_edificio = id_edificio[a, b]
						if not array_contains(edificio.edificios_cerca, temp_edificio){
							array_push(edificio.edificios_cerca, temp_edificio)
							array_push(temp_edificio.edificios_cerca, edificio)
							if edificio_es_trabajo[edificio.tipo]
								array_push(temp_edificio.trabajos_cerca, edificio)
							if edificio_es_trabajo[temp_edificio.tipo]
								array_push(edificio.trabajos_cerca, temp_edificio)
							if edificio_es_casa[edificio.tipo]
								array_push(temp_edificio.casas_cerca, edificio)
							if edificio_es_casa[temp_edificio.tipo]
								array_push(edificio.casas_cerca, temp_edificio)
							if edificio_es_iglesia[edificio.tipo]
								array_push(temp_edificio.iglesias_cerca, edificio)
							if edificio_es_iglesia[temp_edificio.tipo]
								array_push(edificio.iglesias_cerca, temp_edificio)
						}
					}
			//Marcar terreno
			for(var a = x; a < x + width; a++)
				for(var b = y; b < y + height; b++){
					array_set(bool_edificio[a], b, true)
					array_set(id_edificio[a], b, edificio)
					array_set(construccion_reservada[a], b, false)
				}
			//Modificar belleza
			if edificio_belleza[tipo] != 50{
				var size = ceil(abs(edificio_belleza[tipo] - 50) / 5)
				for(var a = max(0, x - size); a < min(xsize, x + width + size); a++)
					for(var b = max(0, y - size); b < min(ysize, y + height + size); b++){
						array_set(belleza[a], b, round(belleza[a, b] + (edificio_belleza[tipo] - 50) / (1 + distancia_punto(a, b, edificio))))
						if bool_edificio[a, b]{
							var edificio_2 = id_edificio[a, b]
							if edificio_es_casa[edificio_2.tipo]
								edificio_2.vivienda_calidad = edificio_familias_calidad[edificio_2.tipo] + round((min(100, max(0, belleza[a, b])) - 50) / 10)
						}
					}
			}
			//Modificar contaminacion
			if edificio_contaminacion[tipo] != 0{
				var size = ceil(edificio_contaminacion[tipo] / 5)
				for(var a = max(0, x - size); a < min(xsize, x + width + size); a++)
					for(var b = max(0, y - size); b < min(ysize, y + height + size); b++)
						array_set(contaminacion[a], b, round(contaminacion[a, b] + edificio_contaminacion[tipo] / (1 + distancia_punto(a, b, edificio))))
			}
		}
		return edificio
	}
}
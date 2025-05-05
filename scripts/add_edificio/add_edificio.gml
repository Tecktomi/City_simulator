function add_edificio(x = 0, y = 0, tipo = 0, fisico = true, rotado = false, pre_width = -1, pre_height = -1){
	with control{
		if debug
			show_debug_message($"{fecha(dia)} add_edificio ({edificio_nombre[tipo]} {edificio_number[tipo]})")
		var edificio = {
			nombre : $"{edificio_nombre[tipo]} {++edificio_number[tipo]}",
			familias : [null_familia],
			trabajadores : [null_persona],
			clientes : [null_persona],
			trabajos_cerca : [[null_edificio]],
			casas_cerca : [null_edificio],
			iglesias_cerca : [null_edificio],
			comisaria : null_edificio,
			x : x,
			y : y,
			tipo : tipo,
			dia_factura : irandom(27),
			count : 0,
			almacen : [],
			pedido : [],
			eficiencia : 1,
			ahorro : 1,
			agua : false,
			agua_consumo : 0,
			energia : false,
			energia_consumo : 0,
			modo : 0,
			array_complex : [{a : 0, b : 0}],
			paro : false,
			huelga : false,
			huelga_motivo : 0,
			huelga_tiempo : 0,
			exigencia : null_exigencia,
			exigencia_fallida : false,
			privado : false,
			vivienda_calidad : edificio_familias_calidad[tipo],
			vivienda_renta : edificio_familias_renta[tipo],
			servicio_calidad : edificio_servicio_calidad[tipo],
			trabajadores_max : edificio_trabajadores_max[tipo], 
			trabajo_calidad : edificio_trabajo_calidad[tipo],
			trabajo_sueldo : max(control.sueldo_minimo, edificio_trabajo_sueldo[tipo]),
			trabajo_riesgo : control.edificio_trabajo_riesgo[tipo],
			mantenimiento : edificio_mantenimiento[tipo],
			contaminacion : edificio_contaminacion[tipo],
			presupuesto : 2,
			mes_creacion : current_mes,
			ganancia : 0,
			trabajo_mes : 0,
			muelle_cercano : null_edificio,
			distancia_muelle_cercano : 0,
			rotado : rotado,
			width : 0,
			height : 0,
			build_x : 0,
			build_y : 0,
			ladron : null_persona,
			empresa : null_empresa,
			venta : false,
			es_almacen : edificio_es_almacen[tipo],
			seguro_fuego : 0,
			zona_pesca : null_zona_pesca,
			mejoras : []
		}
		array_pop(edificio.familias)
		array_pop(edificio.trabajadores)
		array_pop(edificio.clientes)
		array_pop(edificio.trabajos_cerca[0])
		array_pop(edificio.casas_cerca)
		array_pop(edificio.iglesias_cerca)
		array_pop(edificio.array_complex)
		array_push(dia_trabajo[edificio.dia_factura], edificio)
		for(var a = 0; a < array_length(educacion_nombre); a++)
			array_set(edificio.trabajos_cerca, a, [])
		var var_edificio_nombre = edificio_nombre[tipo]
		for(var a = 0; a < array_length(recurso_nombre); a++){
			array_push(edificio.almacen, 0)
			array_push(edificio.pedido, 0)
		}
		if fisico{
			if pre_width = -1
				var width = edificio_width[tipo]
			else
				width = pre_width
			if pre_height = -1
				var height= edificio_height[tipo]
			else
				height = pre_height
			edificio.width = width
			edificio.height = height
			array_set(bool_draw_construccion[x], y, false)
			array_set(bool_draw_edificio[x], y, true)
			array_set(draw_edificio[x], y, edificio)
			array_push(edificios, edificio)
			array_push(edificios_por_mantenimiento[min(20, edificio.mantenimiento)], edificio)
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
				repeat(min(edificio_servicio_clientes[tipo], array_length(desausiado.clientes)))
					traer_paciente_en_espera(edificio)
				cumplir_exigencia(0)
			}
			if edificio_es_casa[tipo]{
				array_push(casas, edificio)
				if var_edificio_nombre != "Toma"
					array_push(casas_libres, edificio)
			}
			if edificio_es_iglesia[tipo]{
				array_push(iglesias, edificio)
				cumplir_exigencia(4)
			}
			if edificio_es_ocio[tipo]
				cumplir_exigencia(3)
			if edificio_es_almacen[tipo]
				array_push(almacenes[tipo], edificio)
			array_push(edificio_count[tipo], edificio)
			if var_edificio_nombre = "Granja"
				edificio.trabajadores_max = floor((width * height - 9) / 3)
			if var_edificio_nombre = "Aserradero"{
				var c = min(x + width + 5, xsize), d = min(y + height + 5, ysize)
				for(var a = max(0, x - 5); a < c; a++)
					for(var b = max(0, y - 5); b < d; b++)
						if bosque[a, b]
							array_push(edificio.array_complex, {a : a, b : b})
				edificio.array_complex = array_shuffle(edificio.array_complex)
			}
			else if var_edificio_nombre = "Pozo Petrolífero"{
				edificio.agua = true
				edificio.agua_consumo += edificio_agua[tipo]
				agua_output += edificio.agua_consumo
			}
			else if var_edificio_nombre = "Periódico"
				array_push(edificio.array_complex, {a : -1, b : 0})
			else if var_edificio_nombre = "Rancho"
				edificio.trabajadores_max = 5 + floor((width * height - 16) / 16)
			else if var_edificio_nombre = "Pescadería"
				buscar_zona_pesca(edificio)
			if var_edificio_nombre != "Muelle"
				buscar_muelle_cercano(edificio)
			else{
				tratados_max++
				for(var a = 0; a < array_length(edificios); a++){
					var edificio_2 = edificios[a]
					if edificio_2.distancia_muelle_cercano = 0
						continue
					var b = distancia(edificio, edificio_2)
					if edificio_2.muelle_cercano = null_edificio or b < edificio_2.distancia_muelle_cercano{
						edificio_2.muelle_cercano = edificio
						edificio_2.distancia_muelle_cercano = b
					}
				}
			}
			if edificio_es_industria[tipo]{
				for(var a = 0; a < array_length(edificio_industria_input_id[tipo]); a++)
					recurso_utilizado[edificio_industria_input_id[tipo, a]]++
				if edificio_industria_vapor[tipo]{
					recurso_utilizado[1]++
					recurso_utilizado[9]++
					recurso_utilizado[27]++
				}
			}
			//Casa busca trabajos cercanos
			var c = min(x + width + 9, xsize), d = min(y + height + 9, ysize)
			if edificio_es_casa[tipo]
				for(var a = max(0, x - 8); a < c; a++)
					for(var b = max(0, y - 8); b < d; b++)
						if bool_edificio[a, b]{
							var temp_edificio = id_edificio[a, b], g = edificio_trabajo_educacion[temp_edificio.tipo]
							if edificio_es_trabajo[temp_edificio.tipo] and not array_contains(edificio.trabajos_cerca[g], temp_edificio){
								array_push(temp_edificio.casas_cerca, edificio)
								array_push(edificio.trabajos_cerca[g], temp_edificio)
								if edificio_es_iglesia[temp_edificio.tipo]
									array_push(edificio.iglesias_cerca, temp_edificio)
							}
						}
			//Trabajo busca casas cercanas
			if edificio_es_trabajo[tipo]{
				var g = edificio_trabajo_educacion[tipo]
				for(var a = max(0, x - 8); a < c; a++)
					for(var b = max(0, y - 8); b < d; b++)
						if bool_edificio[a, b]{
							var temp_edificio = id_edificio[a, b]
							if edificio_es_casa[temp_edificio.tipo] and edificio_nombre[temp_edificio.tipo] != "Toma" and not array_contains(edificio.casas_cerca, temp_edificio){
								array_push(edificio.casas_cerca, temp_edificio)
								array_push(temp_edificio.trabajos_cerca[g], edificio)
								if edificio_es_iglesia[tipo]
									array_push(temp_edificio.iglesias_cerca, edificio)
							}
						}
			}
			//Marcar terreno
			c = x + width
			d = y + height
			for(var a = x; a < c; a++)
				for(var b = y; b < d; b++){
					array_set(bool_edificio[a], b, true)
					array_set(id_edificio[a], b, edificio)
					array_set(construccion_reservada[a], b, false)
					array_set(bosque[a], b, false)
					array_set(draw_construccion[a], b, null_construccion)
				}
			//Modificar belleza
			if edificio_belleza[tipo] != 50{
				var size = ceil(abs(edificio_belleza[tipo] - 50) / 5)
				c = min(x + width + size, xsize)
				d = min(y + height + size, ysize)
				for(var a = max(0, x - size); a < c; a++)
					for(var b = max(0, y - size); b < d; b++){
						array_set(belleza[a], b, round(belleza[a, b] + (edificio_belleza[tipo] - 50) / (1 + distancia_punto(a, b, edificio))))
						if bool_edificio[a, b]{
							var edificio_2 = id_edificio[a, b]
							if edificio_es_casa[edificio_2.tipo]
								set_calidad_vivienda(edificio_2)
						}
					}
			}
			//Modificar contaminacion
			if edificio_contaminacion[tipo] != 0
				add_contaminacion(edificio)
		}
		return edificio
	}
}
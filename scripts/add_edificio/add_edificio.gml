function add_edificio(x = 0, y = 0, tipo = 0, fisico = true, pre_width = -1, pre_height = -1){
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
			dia_factura : irandom(29),
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
			servicio_max : edificio_servicio_clientes[tipo],
			servicio_tarifa : edificio_servicio_tarifa[tipo],
			escuela_max : edificio_escuela_max[tipo],
			trabajadores_max : edificio_trabajadores_max[tipo],
			trabajadores_max_allow : edificio_trabajadores_max[tipo],
			trabajo_calidad : edificio_trabajo_calidad[tipo],
			trabajo_sueldo : max(sueldo_minimo, edificio_trabajo_sueldo[tipo]),
			trabajo_riesgo : edificio_trabajo_riesgo[tipo],
			trabajo_educacion : edificio_trabajo_educacion[tipo],
			mantenimiento : edificio_mantenimiento[tipo],
			contaminacion : edificio_contaminacion[tipo],
			input_id : edificio_industria_input_id[tipo],
			input_num : edificio_industria_input_num[tipo],
			output_id : edificio_industria_output_id[tipo],
			output_num : edificio_industria_output_num[tipo],
			presupuesto : 2,
			mes_creacion : current_mes,
			ganancia : 0,
			trabajo_mes : 0,
			muelle_cercano : null_edificio,
			distancia_muelle_cercano : 0,
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
			mejoras : [],
			precio : edificio_precio[tipo],
			carreteras : [null_carretera]
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
		array_pop(edificio.carreteras)
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
			ds_grid_set(bool_draw_construccion, x, y, false)
			ds_grid_set(bool_draw_edificio, x, y, true)
			ds_grid_set(draw_edificio, x, y, edificio)
			array_push(edificios, edificio)
			array_push(edificios_por_mantenimiento[min(20, edificio.mantenimiento)], edificio)
			if edificio_es_trabajo[tipo]{
				array_push(trabajos, edificio)
				array_push(trabajo_educacion[edificio.trabajo_educacion], edificio)
			}
			if edificio_es_escuela[tipo]{
				array_push(escuelas, edificio)
				cumplir_exigencia(1)
			}
			if edificio_es_medico[tipo]{
				array_push(medicos, edificio)
				repeat(min(edificio.servicio_max, array_length(desausiado.clientes)))
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
				var c = min(x + width + 5, xsize), d = min(y + height + 5, ysize), e = max(0, y - 5)
				for(var a = max(0, x - 5); a < c; a++)
					for(var b = e; b < d; b++)
						if bosque[# a, b] and not bosque_venta[# a, b]
							array_push(edificio.array_complex, {a : a, b : b})
				edificio.array_complex = array_shuffle(edificio.array_complex)
			}
			else if var_edificio_nombre = "Rancho"
				edificio.trabajadores_max = 5 + floor((width * height - 16) / 16)
			else if var_edificio_nombre = "Pescadería"
				buscar_zona_pesca(edificio)
			else if var_edificio_nombre = "Conservadora"
				edificio.array_complex = [{a : 18, b : 1}]
			else if var_edificio_nombre = "Depósito de Taxis"
				edificio.array_complex = [{a : 1, b : 0}]
			else if var_edificio_nombre = "Prisión"{
				edificio.count = 12
				set_carcel_cantidad(edificio)
			}
			if in(var_edificio_nombre, "Pozo Petrolífero", "Departamentos", "Bloque Habitacional", "Planta Química", "Hospital"){
				edificio.agua = true
				edificio.agua_consumo += edificio_agua[tipo]
				agua_output += edificio.agua_consumo
			}
			if in(var_edificio_nombre, "Departamentos", "Bloque Habitacional", "Planta Química", "Fábrica de Vehículos", "Conservadora", "Cine", "Discoteca", "Antena de Radio", "Estudio de Televisión", "Hospital"){
				edificio.energia = true
				edificio.energia_consumo += edificio_energia[tipo]
				energia_output += edificio.energia_consumo
			}
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
			if edificio_es_industria[tipo]
				for(var a = 0; a < array_length(edificio.input_id); a++)
					recurso_utilizado[edificio.input_id[a]]++
			//Casa busca trabajos cercanos
			var c = min(x + width + 9, xsize), d = min(y + height + 9, ysize), e = max(0, y - 8)
			if edificio_es_casa[tipo]
				for(var a = max(0, x - 8); a < c; a++)
					for(var b = e; b < d; b++)
						if bool_edificio[# a, b]{
							var temp_edificio = id_edificio[# a, b], g = temp_edificio.trabajo_educacion
							if edificio_es_trabajo[temp_edificio.tipo] and not array_contains(edificio.trabajos_cerca[g], temp_edificio){
								array_push(temp_edificio.casas_cerca, edificio)
								array_push(edificio.trabajos_cerca[g], temp_edificio)
								if edificio_es_iglesia[temp_edificio.tipo]
									array_push(edificio.iglesias_cerca, temp_edificio)
							}
						}
			//Trabajo busca casas cercanas
			if edificio_es_trabajo[tipo]{
				var g = edificio.trabajo_educacion
				for(var a = max(0, x - 8); a < c; a++)
					for(var b = e; b < d; b++)
						if bool_edificio[# a, b]{
							var temp_edificio = id_edificio[# a, b]
							if edificio_es_casa[temp_edificio.tipo] and edificio_nombre[temp_edificio.tipo] != "Toma" and not array_contains(edificio.casas_cerca, temp_edificio){
								array_push(edificio.casas_cerca, temp_edificio)
								array_push(temp_edificio.trabajos_cerca[g], edificio)
								if edificio_es_iglesia[tipo]
									array_push(temp_edificio.iglesias_cerca, edificio)
							}
						}
			}
			//Marcar terreno
			c = x + width - 1
			d = y + height - 1
			ds_grid_set_region(bool_edificio, x, y, c, d, true)
			ds_grid_set_region(id_edificio, x, y, c, d, edificio)
			ds_grid_set_region(construccion_reservada, x, y, c, d, false)
			ds_grid_set_region(draw_construccion, x, y, c, d, null_construccion)
			ds_grid_set_region(bosque, x, y, c, d, false)
			for(var a = x; a <= c; a++)
				for(var b = y; b <= d; b++)
					if calle[# a, b]
						destroy_calle(a, b)
			//Modificar belleza
			if edificio_belleza[tipo] != 50{
				var size = ceil(abs(edificio_belleza[tipo] - 50) / 5)
				c = min(x + width + size, xsize)
				d = min(y + height + size, ysize)
				e = max(0, y - size)
				for(var a = max(0, x - size); a < c; a++)
					for(var b = e; b < d; b++){
						array_set(belleza[a], b, round(belleza[a, b] + (edificio_belleza[tipo] - 50) / (1 + distancia_punto(a, b, edificio))))
						if bool_edificio[# a, b]{
							var edificio_2 = id_edificio[# a, b]
							if edificio_es_casa[edificio_2.tipo]
								set_calidad_vivienda(edificio_2)
						}
					}
			}
			//Modificar contaminacion
			if edificio_contaminacion[tipo] != 0
				set_contaminacion(edificio)
			//Conectar con calles
			if edificio_nombre[tipo] != "Toma"{
				function detect_carretera_x(mina, maxa, b, edificio){
					for(var a = mina; a < maxa; a++)
						if calle[# a, b]{
							var carretera = calle_carretera[# a, b]
							if not array_contains(carretera.edificios, edificio){
								array_push(carretera.edificios, edificio)
								array_push(edificio.carreteras, carretera)
							}
						}
				}
				detect_carretera_x(x, x + width, y - 1, edificio)
				detect_carretera_x(x, x + width, y + height, edificio)
				function detect_carretera_y(mina, maxa, b, edificio){
					for(var a = mina; a < maxa; a++)
						if calle[# b, a]{
							var carretera = calle_carretera[# b, a]
							if not array_contains(carretera.edificios, edificio){
								array_push(carretera.edificios, edificio)
								array_push(edificio.carreteras, carretera)
							}
						}
				}
				detect_carretera_y(y, y + height, x - 1, edificio)
				detect_carretera_y(y, y + height, x + width, edificio)
			}
		}
		return edificio
	}
}
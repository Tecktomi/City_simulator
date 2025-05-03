function destroy_edificio(edificio = control.null_edificio){
	with control{
		if debug
			show_debug_message($"{fecha(dia)} destroy_edificio ({edificio.nombre})")
		var tipo = edificio.tipo, width = edificio.width, height = edificio.height, var_edificio_nombre = edificio_nombre[tipo]
		array_set(bool_draw_edificio[edificio.x], edificio.y, false)
		array_set(draw_edificio[edificio.x], edificio.y, null_edificio)
		if array_length(edificio.trabajadores) < edificio.trabajadores_max and not edificio.paro
			array_remove(trabajo_educacion[edificio_trabajo_educacion[tipo]], edificio, "eliminar trabajo de los disponibles")
		while array_length(edificio.trabajadores) > 0{
			var persona = edificio.trabajadores[0]
			persona.felicidad_temporal -= 25
			cambiar_trabajo(persona, null_edificio)
		}
		if edificio_es_medico[tipo]{
			array_remove(medicos, edificio, "eliminar médico")
			while array_length(edificio.clientes) > 0{
				var persona = array_shift(edificio.clientes)
				buscar_atencion_medica(persona)
			}
		}
		if edificio_es_escuela[tipo]{
			array_remove(escuelas, edificio, "eliminar escuela")
			for(var a = 0; a < array_length(edificio.clientes); a++)
				buscar_escuela(edificio.clientes[a])
		}
		if edificio_es_trabajo[tipo]{
			array_remove(trabajos, edificio, "eliminar trabajo")
			for(var a = 0; a < array_length(edificio.casas_cerca); a++)
				array_remove(edificio.casas_cerca[a].trabajos_cerca[edificio_trabajo_educacion[edificio.tipo]], edificio, "eliminar trabajo de las casas cercanas")
			if var_edificio_nombre = "Bomba de Agua"
				agua_input -= edificio.count
			else if var_edificio_nombre = "Planta Termoeléctrica"
				energia_input -= edificio.count
		}
		if edificio_es_casa[tipo]{
			array_remove(casas, edificio, "eliminar casa")
			if var_edificio_nombre != "Toma"{
				for(var b = 0; b < array_length(educacion_nombre); b++)
					for(var a = 0; a < array_length(edificio.trabajos_cerca[b]); a++)
						array_remove(edificio.trabajos_cerca[b][a].casas_cerca, edificio, "eliminar casa de los edificios cercanos")
				if array_length(edificio.familias) != edificio_familias_max[tipo]
					array_remove(casas_libres, edificio, "elminar casa libre")
			}
		}
		if edificio_bool_agua[tipo] and edificio.tuberias
			agua_output -= edificio_agua[tipo]
		if edificio_bool_energia[tipo] and edificio.electricidad
			energia_output -= edificio_energia[tipo]
		if edificio_es_industria[tipo]{
			for(var a = 0; a < array_length(edificio_industria_input_id[tipo]); a++)
				recurso_utilizado[edificio_industria_input_id[tipo, a]]--
			if edificio_industria_vapor[tipo]{
				recurso_utilizado[1]--
				recurso_utilizado[10]--
				recurso_utilizado[27]--
			}
		}
		if edificio.comisaria != null_edificio
			edificio.comisaria.comisaria = null_edificio
		for(var a = 0; a < array_length(edificio.familias); a++){
			var familia = edificio.familias[a]
			for_familia(function(persona = control.null_persona){
				persona.felicidad_temporal -= 25
			}, familia)
			cambiar_casa(familia, homeless)
		}
		if edificio_es_iglesia[tipo]
			for(var a = 0; a < array_length(edificio.casas_cerca); a++)
				array_remove(edificio.casas_cerca[a].iglesias_cerca, edificio, "eliminar iglesia cerca")
		if edificio_es_almacen[tipo] and edificio.es_almacen
			array_remove(almacenes[tipo], edificio)
		array_remove(dia_trabajo[edificio.dia_factura], edificio, "eliminar edificio del dia de trabajo")
		array_remove(edificio_count[tipo], edificio, "eliminar edificio del edificio_count")
		if var_edificio_nombre = "Muelle"{
			tratados_max--
			for(var a = 0; a < array_length(edificios); a++)
				if edificios[a].muelle_cercano = edificio
					buscar_muelle_cercano(edificios[a])
		}
		for(var a = edificio.x; a < edificio.x + width; a++)
			for(var b = edificio.y; b < edificio.y + height; b++)
				array_set(bool_edificio[a], b, false)
		if edificio.privado
			array_remove(edificio.empresa.edificios, edificio, "eliminar edificio de la empresa")
		array_remove(edificios, edificio, "eliminar edificio")
		if edificio.exigencia != null_exigencia
			array_remove(edificio.exigencia.edificios, edificio, "eliminar edificio de las exigencias")
		for(var a = 0; a < array_length(encargos); a++)
			if encargos[a].edificio = edificio
				if encargos[a].cantidad < 0
					array_delete(encargos, a--, 1)
				else
					encargos[a].edificio = null_edificio
		if edificio.ladron != null_persona
			edificio.ladron.ladron = null_edificio
		if edificio.venta
			for(var a = 0; a < array_length(edificios_a_la_venta); a++)
				if edificios_a_la_venta[a].edificio = edificio{
					array_delete(edificios_a_la_venta, a, 1)
					break
				}
		//Modificar belleza
		if edificio_belleza[tipo] != 50{
			var size = ceil(abs(edificio_belleza[tipo] - 50) / 5)
			for(var a = max(0, edificio.x - size); a < min(xsize, edificio.x + width + size); a++)
				for(var b = max(0, edificio.y - size); b < min(ysize, edificio.y + height + size); b++){
					array_set(belleza[a], b, round(belleza[a, b] - (edificio_belleza[tipo] - 50) / (1 + distancia_punto(a, b, edificio))))
					if bool_edificio[a, b]{
						var edificio_2 = id_edificio[a, b]
						if edificio_es_casa[edificio_2.tipo]
							set_calidad_vivienda(edificio_2)
					}
				}
		}
		//Modificar contaminacion
		if edificio_contaminacion[tipo] != 0
			remove_contaminacion(edificio)
		if sel_edificio = edificio{
			sel_edificio = null_edificio
			sel_info = false
		}
		array_remove(edificios_por_mantenimiento[min(20, edificio.mantenimiento)], edificio)
	}
}
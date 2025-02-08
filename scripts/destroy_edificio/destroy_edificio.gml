function destroy_edificio(edificio = control.null_edificio){
	with control{
		var width = edificio_width[edificio.tipo], height = edificio_height[edificio.tipo]
		if array_length(edificio.trabajadores) < edificio_trabajadores_max[edificio.tipo]
			array_remove(trabajo_educacion[edificio_trabajo_educacion[edificio.tipo]], edificio)
		for(var a = 0; a < array_length(edificio.trabajadores); a++)
			cambiar_trabajo(edificio.trabajadores[a], null_edificio)
		for(var a = 0; a < array_length(edificio.familias); a++)
			cambiar_casa(edificio.familias[a], homeless)
		if edificio_es_medico[edificio.tipo]{
			array_remove(medicos, edificio)
			for(var a = 0; a < array_length(edificio.clientes); a++)
				buscar_atencion_medica(edificio.clientes[a])
		}
		if edificio_es_escuela[edificio.tipo]{
			array_remove(escuelas, edificio)
			for(var a = 0; a < array_length(edificio.clientes); a++)
				buscar_escuela(edificio.clientes[a])
		}
		if edificio_es_trabajo[edificio.tipo]{
			array_remove(trabajos, edificio)
			for(var a = 0; a < array_length(edificio.edificios_cerca); a++)
				array_remove(edificio.edificios_cerca[a].trabajos_cerca, edificio)
		}
		if edificio_es_casa[edificio.tipo]{
			array_remove(casas, edificio)
			for(var a = 0; a < array_length(edificio.edificios_cerca); a++)
				array_remove(edificio.edificios_cerca[a].casas_cerca, edificio)
		}
		if edificio_es_iglesia[edificio.tipo]
			for(var a = 0; a < array_length(edificio.edificios_cerca); a++)
				array_remove(edificio.edificios_cerca[a].iglesias_cerca, edificio)
		for(var a = 0; a < array_length(edificio.edificios_cerca); a++)
			array_remove(edificio.edificios_cerca[a].edificios_cerca, edificio)
		array_remove(dia_trabajo[edificio.dia_factura], edificio)
		array_remove(edificio_count[edificio.tipo], edificio)
		for(var a = edificio.x; a < edificio.x + width; a++)
			for(var b = edificio.y; b < edificio.y + height; b++)
				array_set(bool_edificio[a], b, false)
		array_remove(edificios, edificio)
		if edificio.exigencia != null_exigencia
			array_remove(edificio.exigencia.edificios, edificio)
		for(var a = 0; a < array_length(encargos); a++)
			if encargos[a].edificio = edificio
				if encargos[a].cantidad < 0
					array_delete(encargos, a--, 1)
				else
					encargos[a].edificio = null_edificio
		//Modificar belleza
		if edificio_belleza[edificio.tipo] != 50{
			var size = ceil(abs(edificio_belleza[edificio.tipo] - 50) / 5)
			for(var a = max(0, edificio.x - size); a < min(xsize, edificio.x + width + size); a++)
				for(var b = max(0, edificio.y - size); b < min(ysize, edificio.y + height + size); b++){
					array_set(belleza[a], b, round(belleza[a, b] - (edificio_belleza[edificio.tipo] - 50) / (1 + distancia_punto(a, b, edificio))))
					if bool_edificio[a, b]{
						var edificio_2 = id_edificio[a, b]
						if edificio_es_casa[edificio_2.tipo]
							edificio_2.vivienda_calidad = edificio_familias_calidad[edificio_2.tipo] + round((min(100, max(0, belleza[a, b])) - 50) / 10)
					}
				}
		}
		//Modificar contaminacion
		if edificio_contaminacion[edificio.tipo] != 0{
			var size = ceil(edificio_contaminacion[edificio.tipo] / 5)
			for(var a = max(0, edificio.x - size); a < min(xsize, edificio.x + width + size); a++)
				for(var b = max(0, edificio.y - size); b < min(ysize, edificio.y + height + size); b++)
					array_set(contaminacion[a], b, round(contaminacion[a, b] - edificio_contaminacion[edificio.tipo] / (1 + distancia_punto(a, b, edificio))))
		}
	}
}
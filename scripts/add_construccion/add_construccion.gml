function add_construccion(null = false, x = 0, y = 0, id = 0, tipo = 0, tiempo = 0, altura = 0, pre_width = -1, pre_height = -1, precio = 0, privado = false, empresa = control.null_empresa, build_x = -1, build_y = -1){
	with control{
		if pre_width = -1
			var width = edificio_width[id]
		else
			width = pre_width
		if pre_height = -1
			var height = edificio_height[id]
		else
			height = pre_height
		var construccion = {
			x : x,
			y : y,
			id : id,
			tipo : tipo,
			tiempo : tiempo,
			tiempo_max : tiempo,
			altura : altura,
			width : width,
			height : height,
			precio : precio,
			privado : privado,
			empresa : empresa,
			build_x : build_x,
			build_y : build_y
		}
		if not null{
			var d = x + width, e = y + height
			ds_grid_set_region(construccion_reservada, x, y, d - 1, e - 1, true)
			ds_grid_set_region(draw_construccion, x, y, d - 1, e - 1, construccion)
			for(var a = x; a < d; a++)
				for(var b = y; b < e; b++){
					if not privado and zona_privada[# a, b]
						zona_empresa[# a, b].dinero += valor_terreno
					if bool_edificio[# a, b] and id_edificio[# a, b].tipo = 32
						destroy_edificio(id_edificio[# a, b])
					if escombros[# a, b]{
						array_set(chunk_update[floor(a / 16)], floor(b / 16), true)
						world_update = true
					}
				}
			ds_grid_set_region(zona_privada, x, y, d - 1, e - 1, false)
			ds_grid_set_region(zona_empresa, x, y, d - 1, e - 1, null_empresa)
			ds_grid_set_region(escombros, x, y, d - 1, e - 1, false)
			if array_length(cola_construccion) = 0 and ley_eneabled[6]
				for(var a = 0; a < array_length(edificio_count[20]); a++)
					set_paro(false, edificio_count[20, a])
			for(var a = 0; a < array_length(edificio_recursos_id[id]); a++){
				var b = edificio_recursos_id[id, a], c = edificio_recursos_num[id, a]
				recurso_construccion[b] += c
				if privado{
					var temp_precio = recurso_precio[b] * c
					empresa.dinero -= temp_precio
					dinero_privado -= temp_precio
					dinero += temp_precio
					mes_venta_interna[current_mes] += temp_precio
					array_add(mes_venta_recurso[current_mes], b, temp_precio)
					array_add(mes_venta_recurso_num[current_mes], b, c)
				}
			}
			array_push(cola_construccion, construccion)
			ds_grid_set(bool_draw_construccion, x, y, true)
		}
		return construccion
	}
}
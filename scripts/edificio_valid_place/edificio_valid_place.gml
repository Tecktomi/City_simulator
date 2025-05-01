function edificio_valid_place(x, y, index, rotado = false, privado = false, empresa = control.null_empresa, pre_width = -1, pre_height = -1){
	with control{
		if pre_width = -1
			var width = edificio_width[index]
		else
			width = pre_width
		if pre_height = -1
			var height = edificio_height[index]
		else
			height = pre_height
		if x + width >= xsize or y + height >= ysize
			return false
		var tipo = -1
		if privado{
			for(var a = 0; a < array_length(edificio_categoria_nombre); a++)
				if array_contains(edificio_categoria[a], index){
					tipo = a
					break
				}
			if tipo = -1
				return false
		}
		if edificio_es_costero[index]{
			for(var a = x; a < x + width; a++)
				for(var b = y; b < y + height; b++)
					if construccion_reservada[a, b] or (bool_edificio[a, b] and (index = 32 or id_edificio[a, b].tipo != 32)) or (privado and (zona_empresa[a, b] != empresa or not zona_privada_permisos[a, b][tipo])) or zona_privada_venta[a, b]
						return false
			var flag = true
			for(var a = x; a < x + width; a++)
				if mar[a, y] = mar[a, y + height - 1] or (a - x > 0 and mar[a, y] != mar[a - 1, y]){
					flag = false
					break
				}
			if flag
				return true
			flag = true
			for(var a = y; a < y + height; a++)
				if mar[x, a] = mar[x + width - 1, a] or (a - y > 0 and mar[x, a] != mar[x, a - 1]){
					flag = false
					break
				}
			return flag
		}
		else{
			for(var a = x; a < x + width; a++)
				for(var b = y; b < y + height; b++)
					if mar[a, b] or construccion_reservada[a, b] or (bool_edificio[a, b] and (index = 32 or id_edificio[a, b].tipo != 32)) or (privado and (zona_empresa[a, b] != empresa or not zona_privada_permisos[a, b][tipo])) or zona_privada_venta[a, b]
						return false
		}
		return true
	}
}
function edificio_valid_place(x, y, index){
	with control{
		var width = edificio_width[index], height = edificio_height[index]
		if x + width >= xsize or y + height >= ysize
			return false
		for(var a = x; a < x + width; a++)
			for(var b = y; b < y + height; b++)
				if bosque[a, b] or construccion_reservada[a, b] or (bool_edificio[a, b] and (index = 32 or id_edificio[a, b].tipo != 32))
					return false
		if edificio_es_costero[index]{
			var flag = true
			for(var a = x; a < x + width; a++)
				if mar[a, y] = mar[a, y + height - 1] or (a - x > 0 and mar[a, y] != mar[a - 1, y]){
					flag = false
					break
				}
			if not flag
				for(var a = y; a < y + height; a++)
					if mar[x, a] = mar[x + width - 1, a] or (a - y > 0 and mar[x, a] != mar[x, a - 1]){
						flag = false
						break
					}
			return flag
		}
		return true
	}
}
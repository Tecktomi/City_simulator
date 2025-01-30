function edificio_valid_place(x, y, index){
	with control{
		if x + edificio_width[index] >= xsize or y + edificio_height[index] >= ysize
			return false
		if edificio_es_costero[index]{
			for(var a = x; a < x + edificio_width[index]; a++)
				for(var b = y; b < y + edificio_height[index]; b++)
					if bool_edificio[a, b] or bosque[a, b] or construccion_reservada[a, b]
						return false
			var flag = true
			for(var a = x; a < x + edificio_width[index]; a++)
				if mar[a, y] = mar[a, y + edificio_height[index] - 1] or (a - x > 0 and mar[a, y] != mar[a - 1, y]){
					flag = false
					break
				}
			if not flag{
				flag = true
				for(var a = y; a < y + edificio_height[index]; a++)
					if mar[x, a] = mar[x + edificio_width[index] - 1, a] or (a - y > 0 and mar[x, a] != mar[x, a - 1]){
						flag = false
						break
					}
			}
			return flag
		}
		else{
			for(var a = x; a < x + edificio_width[index]; a++)
				for(var b = y; b < y + edificio_height[index]; b++)
					if bool_edificio[a, b] or bosque[a, b] or mar[a, b] or construccion_reservada[a, b]
						return false
			return true
		}
	}
}
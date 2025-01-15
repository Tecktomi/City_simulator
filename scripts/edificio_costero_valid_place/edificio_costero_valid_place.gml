function edificio_valid_place(x, y, index){
	if x + control.edificio_width[index] >= control.xsize or y + control.edificio_height[index] >= control.ysize
		return false
	if control.edificio_es_costero[index]{
		for(var a = 0; a < control.edificio_width[index]; a++)
			for(var b = 0; b < control.edificio_height[index]; b++){
				if control.bool_edificio[x + a, y + b] or control.bosque[x + a, y + b]
					return false
			}
		var flag = true
		for(var a = 0; a < control.edificio_width[index]; a++)
			if control.mar[x + a, y] = control.mar[x + a, y + control.edificio_height[index] - 1] or (a > 0 and control.mar[x + a, y] != control.mar[x + a - 1, y]){
				flag = false
				break
			}
		if not flag{
			flag = true
			for(var a = 0; a < control.edificio_height[index]; a++)
				if control.mar[x, y + a] = control.mar[x + edificio_width[index] - 1, y + a] or (a > 0 and control.mar[x, y + a] != control.mar[x, y + a - 1]){
					flag = false
					break
				}
		}
		return flag
	}
	else
		for(var a = 0; a < control.edificio_width[index]; a++)
			for(var b = 0; b < control.edificio_height[index]; b++)
				if control.bool_edificio[a, b] or control.bosque[a, b] or control.mar[a, b]
					return false
}
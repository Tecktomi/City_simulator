function set_contaminacion(edificio = control.null_edificio){
	with control{
		var width = edificio.width, height = edificio.height, a = edificio.x + width / 2, b = edificio.y + height / 2, size = ceil(edificio.contaminacion / 5), d = min(width, height) / 2
		for(var c = 0; c <= size; c++)
			ds_grid_add_disk(contaminacion, a, b, c + d, 5 + c)
	}
}
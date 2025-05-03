function remove_contaminacion(edificio = control.null_edificio){
	with control{
		var a = edificio.x, b = edificio.y, cont = edificio.contaminacion, size = ceil(cont / 5), e = min(xsize, a + edificio.width + size), f = min(ysize, b + edificio.height + size)
		for(var c = max(0, a - size); c < e; c++)
			for(var d = max(0, b - size); d < f; d++)
				array_set(contaminacion[c], d, round(contaminacion[c, d] - cont / (1 + distancia_punto(c, d, edificio))))
	}
}
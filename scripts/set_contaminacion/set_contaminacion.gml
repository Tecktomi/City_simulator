function set_contaminacion(edificio = control.null_edificio){
	with control{
		var a = edificio.x, b = edificio.y, cont = edificio.contaminacion, size = ceil(cont / 5), e = min(a + edificio.width + size, xsize), f = min(b + edificio.height + size, ysize)
		for(var c = max(0, a - size); c < e; c++)
			for(var d = max(0, b - size); d < f; d++)
				array_set(contaminacion[c], d, round(contaminacion[c, d] + cont / (1 + distancia_punto(c, d, edificio))))
	}
}
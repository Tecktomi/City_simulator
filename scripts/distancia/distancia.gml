function distancia(origen = control.null_edificio, destino = control.null_edificio){
	var disx, disy
	with control{
		if origen.x > destino.x + edificio_width[destino.tipo]
			disx = origen.x - destino.x + edificio_width[destino.tipo]
		else if origen.x + edificio_width[origen.tipo] < destino.x
			disx = destino.x - origen.x + edificio_width[origen.tipo]
		else
			disx = 0
		if origen.y > destino.y + edificio_height[destino.tipo]
			disy = origen.y - destino.y + edificio_height[destino.tipo]
		else if origen.y + edificio_height[origen.tipo] < destino.y
			disy = destino.y - origen.y + edificio_height[origen.tipo]
		else
			disy = 0
		return sqrt(sqr(disx) + sqr(disy))
	}
}
function distancia_punto(x, y, origen = control.null_edificio){
	var disx, disy
	with control{
		if x < origen.x - 1
			disx = origen.x - x
		else if x >= origen.x + edificio_width[origen.tipo]
			disx = x - origen.x - edificio_width[origen.tipo]
		else
			disx = 0
		if y < origen.y - 1
			disy = origen.y - y
		else if y >= origen.y + edificio_height[origen.tipo]
			disy = y - origen.y - edificio_height[origen.tipo]
		else
			disy = 0
		return sqrt(sqr(disx) + sqr(disy))
	}
}
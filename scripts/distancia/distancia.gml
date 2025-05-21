function distancia(origen = control.null_edificio, destino = control.null_edificio){
	var disx, disy
	with control{
		var width_ori = edificio_width[origen.tipo], height_ori = edificio_height[origen.tipo], width_dest = edificio_width[destino.tipo], height_dest = edificio_height[destino.tipo]
		if origen.x > destino.x + width_dest
			disx = origen.x - destino.x - width_dest
		else if origen.x + width_ori < destino.x
			disx = destino.x - origen.x - width_ori
		else
			disx = 0
		if origen.y > destino.y + height_dest
			disy = origen.y - destino.y - height_dest
		else if origen.y + height_ori < destino.y
			disy = destino.y - origen.y - height_ori
		else
			disy = 0
		return sqrt(sqr(disx) + sqr(disy))
	}
}
function distancia_punto(x, y, origen = control.null_edificio){
	var disx, disy
	with control{
		var width_ori = edificio_width[origen.tipo], height_ori = edificio_height[origen.tipo]
		if x < origen.x - 1
			disx = origen.x - x
		else if x >= origen.x + width_ori
			disx = x - origen.x - width_ori
		else
			disx = 0
		if y < origen.y - 1
			disy = origen.y - y
		else if y >= origen.y + height_ori
			disy = y - origen.y - height_ori
		else
			disy = 0
		return sqrt(sqr(disx) + sqr(disy))
	}
}
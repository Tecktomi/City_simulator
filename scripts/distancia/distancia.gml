function distancia(origen = control.null_edificio, destino = control.null_edificio){
	var disx, disy
	if origen.x > destino.x + control.edificio_width[destino.tipo]
		disx = origen.x - destino.x + control.edificio_width[destino.tipo]
	else if origen.x + control.edificio_width[origen.tipo] < destino.x
		disx = destino.x - origen.x + control.edificio_width[origen.tipo]
	else
		disx = 0
	if origen.y > destino.y + control.edificio_height[destino.tipo]
		disy = origen.y - destino.y + control.edificio_height[destino.tipo]
	else if origen.y + control.edificio_height[origen.tipo] < destino.y
		disy = destino.y - origen.y + control.edificio_height[origen.tipo]
	else
		disy = 0
	return sqrt(sqr(disx) + sqr(disy))
}
function edificio_calles(x, y, width, height, edificio = null_edificio){
	with control{
		function detect_carretera_x(mina, maxa, b, edificio){
			for(var a = mina; a < maxa; a++)
				if calle[# a, b]{
					var carretera = calle_carretera[# a, b]
					if not array_contains(carretera.edificios, edificio)
						array_push(carretera.edificios, edificio)
				}
		}
		detect_carretera_x(x, x + width, y - 1, edificio)
		detect_carretera_x(x, x + width, y + height, edificio)
		function detect_carretera_y(mina, maxa, b, edificio){
			for(var a = mina; a < maxa; a++)
				if calle[# b, a]{
					var carretera = calle_carretera[# b, a]
					if not array_contains(carretera.edificios, edificio)
						array_push(carretera.edificios, edificio)
				}
		}
		detect_carretera_y(y, y + height, x - 1, edificio)
		detect_carretera_y(y, y + height, x + width, edificio)
	}
}
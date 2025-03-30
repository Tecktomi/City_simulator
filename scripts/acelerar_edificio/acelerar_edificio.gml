function acelerar_edificio(construccion = control.null_construccion){
	with control{
		array_remove(cola_construccion, construccion)
		x = construccion.x
		y = construccion.y
		var index = construccion.id, width = construccion.width, height = construccion.height, var_edificio_nombre = edificio_nombre[index]
		var edificio = add_edificio(x, y, index, , construccion.rotado)
		if not edificio_es_costero[index] and var_edificio_nombre != "Rancho"{
			var c = construccion.altura
			world_update = true
			if c < 0.6{
				for(var a = x; a < x + width; a++)
					for(var b = y; b < y + height; b++){
						ds_grid_set(altura, a, b, c)
						array_set(altura_color[a], b, make_color_rgb(255 / 0.6 * (1.1 - c), 255 / 0.6 * (1.1 - c), 127))
						array_set(chunk_update[floor(a / 16)], floor(b / 16), true)
					}
			}
			else{
				for(var a = x; a < x + width; a++)
					for(var b = y; b < y + height; b++){
						ds_grid_set(altura, a, b, c)
						array_set(altura_color[a], b, make_color_rgb(31 + 96 * c, 127, 31 + 96 * c))
						array_set(chunk_update[floor(a / 16)], floor(b / 16), true)
					}
			}
		}
		if var_edificio_nombre = "Granja"{
			var c = 0
			for(var a = x; a < x + width; a++)
				for(var b = y; b < y + height; b++)
					c += cultivo[index][# b, c]
			edificio.eficiencia = c / width / height
			edificio.modo = construccion.tipo
		}
		else if in(var_edificio_nombre, "Mina", "Rancho")
			edificio.modo = construccion.tipo
		else if var_edificio_nombre = "Tejar"{
			var c = 0
			for(var a = x; a < x + width; a++)
				for(var b = y; b < y + height; b++)
					c += (altura[# a, b] > 0.6)
			edificio.eficiencia = c / width / height
		}
		//Despedir a todos los trabajadores si la ley de trabajo temporal está habilitada
		if array_length(cola_construccion) = 0 and ley_eneabled[6]
			for(var a = 0; a < array_length(edificio_count[20]); a++){
				edificio = edificio_count[20, a]
				set_paro(true, edificio)
				while array_length(edificio.trabajadores) > 0
					cambiar_trabajo(edificio.trabajadores[0], null_edificio)
			}
		//Tutorial
		if tutorial_bool{
			if tutorial = 9 and var_edificio_nombre = "Chabola"
				tutorial_complete = true
			if tutorial = 13 and var_edificio_nombre = "Granja"
				tutorial_complete = true
			if tutorial = 15 and var_edificio_nombre = "Aserradero"
				tutorial_complete = true
			if tutorial = 17 and var_edificio_nombre = "Escuela"
				tutorial_complete = true
		}
		return edificio
	}
}
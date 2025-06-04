function add_calle(x, y){
	with control{
		var a = 0
		array_set(chunk_update[floor(x / 16)], floor(y / 16), true)
		world_update = true
		if bool_edificio[# x, y]{
			var edificio = id_edificio[# x, y]
			if edificio_nombre[edificio] = "Toma"
				destroy_edificio(edificio)
			else
				show_error("Intentando construir una calle sobre un edificio", true)
		}
		ds_grid_set(calle, x, y, true)
		if x > 0 and calle[# x - 1, y]{
			a += 2
			ds_grid_add(calle_sprite, x - 1, y, 8)
			array_set(chunk_update[floor((x - 1) / 16)], floor(y / 16), true)
		}
		if y > 0 and calle[# x, y - 1]{
			a += 1
			ds_grid_add(calle_sprite, x, y - 1, 4)
			array_set(chunk_update[floor(x / 16)], floor((y - 1) / 16), true)
		}
		if x < xsize - 1 and calle[# x + 1, y]{
			a += 8
			ds_grid_add(calle_sprite, x + 1, y, 2)
			array_set(chunk_update[floor((x + 1) / 16)], floor(y / 16), true)
		}
		if y < ysize - 1 and calle[# x, y + 1]{
			a += 4
			ds_grid_add(calle_sprite, x, y + 1, 1)
			array_set(chunk_update[floor(x / 16)], floor((y + 1) / 16), true)
		}
		ds_grid_set(calle_sprite, x, y, a)
		var vecinos = [[x - 1, y], [x, y - 1], [x + 1, y], [x, y + 1]], conectadas = [], temp_edificios = [null_edificio]
		array_pop(temp_edificios)
		for(a = 0; a < 4; a++){
			var b = vecinos[a, 0], c = vecinos[a, 1]
			if b >= 0 and c >= 0 and b < xsize and c < ysize
				if calle[# b, c]{
					var carretera = calle_carretera[# b, c]
					if carretera != null_carretera and not array_contains(conectadas, carretera)
						array_push(conectadas, carretera)
				}
				else if bool_edificio[# b, c]{
					var edificio = id_edificio[# b, c]
					if edificio_nombre[edificio.tipo] != "Toma"
						array_push(temp_edificios, id_edificio[# b, c])
				}
		}
		if array_length(conectadas) = 0{
			var carretera = {
				index : carreteras_index++,
				tramos : [[x, y]],
				edificios : temp_edificios,
				taxis : 0
			}
			array_push(carreteras, carretera)
			ds_grid_set(calle_carretera, x, y, carretera)
			for(a = 0; a < array_length(temp_edificios); a++)
				array_push(temp_edificios[a].carreteras, carretera)
		}
		else if array_length(conectadas) = 1{
			var carretera = conectadas[0]
			array_push(carretera.tramos, [x, y])
			for(a = 0; a < array_length(temp_edificios); a++){
				var edificio = temp_edificios[a]
				if not array_contains(carretera.edificios, edificio){
					array_push(carretera.edificios, edificio)
					array_push(edificio.carreteras, carretera)
				}
			}
			ds_grid_set(calle_carretera, x, y, carretera)
		}
		else{
		    var carretera = conectadas[0]
		    array_push(carretera.tramos, [x, y])
		    ds_grid_set(calle_carretera, x, y, carretera)
		    for(var i = 1; i < array_length(conectadas); i++){
		        var secundaria = conectadas[i]
		        for(var j = 0; j < array_length(secundaria.tramos); j++){
					var nueva = secundaria.tramos[j]
		            array_push(carretera.tramos, nueva)
		            ds_grid_set(calle_carretera, nueva[0], nueva[1], carretera)
		        }
				for(var j = 0; j < array_length(secundaria.edificios); j++){
					var edificio = secundaria.edificios[j]
					array_remove(edificio.carreteras, secundaria)
					if not array_contains(carretera.edificios, edificio){
						array_push(carretera.edificios, edificio)
						array_push(edificio.carreteras, carretera)
					}
				}
		        array_remove(carreteras, secundaria)
				delete(secundaria)
		    }
		}
	}
}
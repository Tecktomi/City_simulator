function destroy_calle(x, y){
	with control{
		array_set(chunk_update[floor(x / 16)], floor(y / 16), true)
		world_update = true
		ds_grid_set(calle, x, y, false)
		var carretera = calle_carretera[# x, y]
		ds_grid_set(calle_carretera, x, y, null_carretera)
		array_remove(carretera.tramos, [x, y])
		if array_length(carretera.tramos) = 0{
			for(var i = 0; i < array_length(carretera.edificios); i++)
				array_remove(carretera.edificios[i].carreteras, carretera)
			array_remove(carreteras, carretera)
			delete carretera
		}
		else{
			var tramos_restantes = [], visitado = ds_grid_create(xsize, ysize), componentes = []
			ds_grid_clear(visitado, false)
			for(var a = 0; a < array_length(carretera.tramos); a++)
				array_push(tramos_restantes, carretera.tramos[a])
			while array_length(tramos_restantes) > 0{
				var cola = [array_pop(tramos_restantes)], componente = []
				while array_length(cola) > 0{
					var actual = array_pop(cola), ax = actual[0], ay = actual[1]
					if visitado[# ax, ay]
						continue
					ds_grid_set(visitado, ax, ay, true)
					array_push(componente, actual)
					array_remove(tramos_restantes, actual)
					var vecinos = [[ax - 1, ay], [ax + 1, ay], [ax, ay - 1], [ax, ay + 1]]
					for(var i = 0; i < 4; i++){
						var vx = vecinos[i, 0], vy = vecinos[i, 1]
						if vx >= 0 and vy >= 0 and vx < xsize and vy < ysize and calle[# vx, vy] and not visitado[# vx, vy] and calle_carretera[# vx, vy] = carretera
							array_push(cola, [vx, vy])
					}
				}
				array_push(componentes, componente)
			}
			if array_length(componentes) > 1{
				for(var i = 0; i < array_length(carretera.edificios); i++)
					array_remove(carretera.edificios[i].carreteras, carretera)
				array_remove(carreteras, carretera)
				delete carretera
				for(var i = 0; i < array_length(componentes); i++){
					var comp = componentes[i], edificios = []
					for(var j = 0; j < array_length(comp); j++){
						var cx = comp[j, 0], cy = comp[j, 1], vecinos = [[cx - 1, cy], [cx + 1, cy], [cx, cy - 1], [cx, cy + 1]]
						ds_grid_set(calle_carretera, cx, cy, null_carretera)
						for(var k = 0; k < 4; k++){
							var vx = vecinos[k, 0], vy = vecinos[k, 1]
							if vx >= 0 and vy >= 0 and vx < xsize and vy < ysize and bool_edificio[# vx, vy] and edificio_nombre[id_edificio[# vx, vy].tipo] != "Toma"{
								var ed = id_edificio[# vx, vy]
								if not array_contains(edificios, ed)
									array_push(edificios, ed)
							}
						}
					}
					var nueva_carretera = {
						index : carreteras_index++,
						tramos : comp,
						edificios : edificios,
						taxis : 0
					}
					for(var j = 0; j < array_length(comp); j++)
						ds_grid_set(calle_carretera, comp[j, 0], comp[j, 1], nueva_carretera)
					for(var j = 0; j < array_length(edificios); j++)
						array_push(edificios[j].carreteras, nueva_carretera)
					array_push(carreteras, nueva_carretera)
				}
			}
		}
		if x > 0 and calle[# x - 1, y]{
			ds_grid_add(calle_sprite, x - 1, y, -8)
			array_set(chunk_update[floor((x - 1) / 16)], floor(y / 16), true)
		}
		if y > 0 and calle[# x, y - 1]{
			ds_grid_add(calle_sprite, x, y - 1, -4)
			array_set(chunk_update[floor(x / 16)], floor((y - 1) / 16), true)
		}
		if x < xsize - 1 and calle[# x + 1, y]{
			ds_grid_add(calle_sprite, x + 1, y, -2)
			array_set(chunk_update[floor((x + 1) / 16)], floor(y / 16), true)
		}
		if y < ysize - 1 and calle[# x, y + 1]{
			ds_grid_add(calle_sprite, x, y + 1, -1)
			array_set(chunk_update[floor(x / 16)], floor((y + 1) / 16), true)
		}
		ds_grid_set(calle_sprite, x, y, 0)
	}
}
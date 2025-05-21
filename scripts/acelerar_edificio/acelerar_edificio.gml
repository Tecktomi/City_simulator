function acelerar_edificio(construccion = control.null_construccion){
	with control{
		array_remove(cola_construccion, construccion)
		x = construccion.x
		y = construccion.y
		var index = construccion.id, width = construccion.width, height = construccion.height, var_edificio_nombre = edificio_nombre[index]
		var edificio = add_edificio(x, y, index,, width, height), d = x + width, e = y + height
		if construccion.privado{
			edificio.privado = true
			edificio.empresa = construccion.empresa
			array_push(edificio.empresa.edificios, edificio)
		}
		else
			add_noticia("Edificio terminado", $"Se ha terminado de construir {edificio.nombre}")
		if not edificio_plano[index]{
			var c = construccion.altura
			world_update = true
			if c < 0.6{
				var temp_color = make_color_rgb(255 / 0.65 * (1.1 - c), 255 / 0.65 * (1.1 - c), 127)
				for(var a = x; a < d; a++)
					for(var b = y; b < e; b++){
						ds_grid_set(altura, a, b, c)
						array_set(altura_color[a], b, temp_color)
						array_set(chunk_update[floor(a / 16)], floor(b / 16), true)
					}
			}
			else{
				var temp_color = make_color_rgb(31 + 96 * c, 127, 31 + 96 * c)
				for(var a = x; a < d; a++)
					for(var b = y; b < e; b++){
						ds_grid_set(altura, a, b, c)
						array_set(altura_color[a], b, temp_color)
						array_set(chunk_update[floor(a / 16)], floor(b / 16), true)
					}
			}
		}
		if var_edificio_nombre = "Granja"{
			var edi_width = edificio_width[index], edi_height = edificio_height[index]
			edificio.modo = construccion.tipo
			var c = 0
			for(var a = x; a < d; a++)
				for(var b = y; b < e; b++)
					if (x >= construccion.build_x ? (a >= x + edi_width) : (a <= d - edi_width)) or (y >= construccion.build_y ? (b >= y + edi_height) : (b <= e - edi_height))
						c += cultivo[edificio.modo][# a, b]
			edificio.eficiencia = c / (width * height - 9)
			edificio.nombre = $"{edificio_nombre[edificio.tipo]} de {recurso_nombre[recurso_cultivo[edificio.modo]]} {++edificio_number_granja[edificio.modo]}"
			edificio.build_x = construccion.build_x
			edificio.build_y = construccion.build_y
		}
		else if var_edificio_nombre = "Mina"{
			edificio.modo = construccion.tipo
			edificio.nombre = $"{edificio_nombre[edificio.tipo]} de {recurso_nombre[recurso_mineral[edificio.modo]]} {++edificio_number_mina[edificio.modo]}"
		}
		else if var_edificio_nombre = "Rancho"{
			var edi_width = edificio_width[index], edi_height = edificio_height[index]
			var c = 0
			for(var a = x; a < d; a++)
				for(var b = y; b < e; b++)
					if (x >= construccion.build_x ? (a >= x + edi_width) : (a <= d - edi_width)) or (y >= construccion.build_y ? (b >= y + edi_height) : (b <= e - edi_height))
						c += altura[# a, b] > 0.6
			edificio.eficiencia = 1 + c * 0.009
			edificio.modo = construccion.tipo
			edificio.nombre = $"{edificio_nombre[edificio.tipo]} de {ganado_nombre[edificio.modo]} {++edificio_number_rancho[edificio.modo]}"
			edificio.build_x = construccion.build_x
			edificio.build_y = construccion.build_y
		}
		else if var_edificio_nombre = "Tejar"{
			var c = 0
			for(var a = x; a < d; a++)
				for(var b = y; b < e; b++)
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
		if sel_info and sel_tipo = 3 and sel_construccion = construccion
			select(edificio)
		return edificio
	}
}
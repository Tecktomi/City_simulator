function draw_gradiente(tipo, modo){
	with control{
		if modo = 0{
			for(var a = min_camx; a < max_camx; a++)
				for(var b = min_camy; b < max_camy; b++)
					if not bosque[a, b] and not mar[a, b] and not bool_edificio[a, b]{
						draw_set_color(make_color_rgb(255 * (1 - cultivo[tipo][# a, b]), 255 * cultivo[tipo][# a, b], 0))
						draw_circle((a - b) * tile_width - xpos, (a + b + 1) * tile_height - ypos, tile_height / 2, false)
					}
			draw_set_color(c_white)
			draw_text(0, 0, recurso_nombre[recurso_cultivo[tipo]])
		}
		if modo = 1{
			draw_set_color(recurso_mineral_color[tipo])
			for(var a = min_camx; a < max_camx; a++)
				for(var b = min_camy; b < max_camy; b++)
					if not bosque[a, b] and not bool_edificio[a, b] and mineral[tipo][a, b]
						draw_circle((a - b) * tile_width - xpos, (a + b + 1) * tile_height - ypos, tile_height / 2, false)
			draw_set_color(c_white)
			draw_text(0, 0, recurso_nombre[recurso_mineral[tipo]])
		}
		if modo = 2{
			draw_set_alpha(0.5)
			for(var a = min_camx; a < max_camx; a++)
				for(var b = min_camy; b < max_camy; b++)
					if not mar[a, b] and floor(belleza[a, b]) != 0.5{
						draw_set_color(make_color_rgb(2.55 * (100 - clamp(belleza[a, b], 0, 100)), 2.55 * clamp(belleza[a, b], 0, 100), 0))
						draw_rombo((a - b) * tile_width - xpos, (a + b) * tile_height - ypos, (a - b - 1) * tile_width - xpos, (a + b + 1) * tile_height - ypos, (a - b) * tile_width - xpos, (a + b + 2) * tile_height - ypos, (a - b + 1) * tile_width - xpos, (a + b + 1) * tile_height - ypos, false)
					}
			draw_set_alpha(1)
			draw_set_color(c_white)
			draw_text(0, 0, "Belleza")
			var mx = clamp(floor(((mouse_x + xpos) / tile_width + (mouse_y + ypos) / tile_height) / 2), 0, xsize - 1)
			var my = clamp(floor(((mouse_y + ypos) / tile_height - (mouse_x + xpos) / tile_width) / 2), 0, ysize - 1)
			if mouse_x > 0 and mouse_y > 0 and mouse_x < room_width and mouse_y < room_height
				if not mar[mx, my]
					draw_text(0, 20, clamp(belleza[mx, my], 0, 100))
		}
		if modo = 3{
			for(var a = min_camx; a < max_camx; a++)
				for(var b = min_camy; b < max_camy; b++){
					draw_set_color(make_color_hsv(0, 0, 2.55 * (100 - clamp(contaminacion[a, b], 0, 100))))
					draw_set_alpha(clamp(contaminacion[a, b], 0, 100) / 200)
					draw_rombo((a - b) * tile_width - xpos, (a + b) * tile_height - ypos, (a - b - 1) * tile_width - xpos, (a + b + 1) * tile_height - ypos, (a - b) * tile_width - xpos, (a + b + 2) * tile_height - ypos, (a - b + 1) * tile_width - xpos, (a + b + 1) * tile_height - ypos, false)
				}
			draw_set_alpha(1)
			draw_set_color(c_white)
			draw_text(0, 0, "Contaminación")
			var mx = clamp(floor(((mouse_x + xpos) / tile_width + (mouse_y + ypos) / tile_height) / 2), 0, xsize - 1)
			var my = clamp(floor(((mouse_y + ypos) / tile_height - (mouse_x + xpos) / tile_width) / 2), 0, ysize - 1)
			if mouse_x > 0 and mouse_y > 0 and mouse_x < room_width and mouse_y < room_height
				draw_text(0, 20, clamp(contaminacion[mx, my], 0, 100))
		}
		if modo = 4{
			draw_set_color(c_white)
			draw_text(0, 0, "Ocupación Residencial")
			for(var c = 0; c < array_length(casas); c++){
				var casa = casas[c], a = casa.x, b = casa.y, width = casa.width, height = casa.height, d = array_length(casa.familias) / edificio_familias_max[casa.tipo]
				if a + width > min_camx and b + height > min_camy and a < max_camx and b < max_camy{
					draw_set_color(c_gray)
					draw_rombo_coord(a, b, width, height, false)
					draw_set_alpha(0.5)
					draw_set_color(make_color_rgb(255 * (1 - d), 255 * d, 0))
					draw_rombo_coord(a, b, width, height, false)
					draw_set_alpha(1)
				}
			}
		}
		if modo = 5{
			draw_set_color(c_white)
			draw_text(0, 0, "Ocupación Laboral")
			for(var c = 0; c < array_length(trabajos); c++){
				var edificio = trabajos[c], a = edificio.x, b = edificio.y, width = edificio.width, height = edificio.height, d = array_length(edificio.trabajadores) / edificio.trabajadores_max
				if a + width > min_camx and b + height > min_camy and a < max_camx and b < max_camy{
					draw_set_color(c_gray)
					draw_rombo_coord(a, b, width, height, false)
					draw_set_alpha(0.5)
					draw_set_color(make_color_rgb(255 * (1 - d), 255 * d, 0))
					draw_rombo_coord(a, b, width, height, false)
					draw_set_alpha(1)
				}
			}
		}
		if modo = 6{
			draw_set_color(c_white)
			draw_text(0, 0, "Depósitos de Petróleo")
			draw_set_color(c_black)
			for(var a = min_camx; a < max_camx; a++)
				for(var b = min_camy; b < max_camy; b++)
					if petroleo[a, b] > 0
						draw_circle((a - b) * tile_width - xpos, (a + b + 1) * tile_height - ypos, tile_height / 2, false)
			var mx = clamp(floor(((mouse_x + xpos) / tile_width + (mouse_y + ypos) / tile_height) / 2), 0, xsize - 1)
			var my = clamp(floor(((mouse_y + ypos) / tile_height - (mouse_x + xpos) / tile_width) / 2), 0, ysize - 1)
			if mouse_x > 0 and mouse_y > 0 and mouse_x < room_width and mouse_y < room_height
				draw_text(0, 20, petroleo[mx, my])
		}
	}
}
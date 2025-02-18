function draw_gradiente(tipo, modo){
	with control{
		if modo = 0{
			for(var a = min_camx; a < max_camx; a++)
				for(var b = min_camy; b < max_camy; b++)
					if not bosque[a, b] and not mar[a, b]{
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
					if mineral[tipo][a, b]
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
			var mx = clamp(floor(((mouse_x + xpos) / 20 + (mouse_y + ypos) / 10) / 2), 0, xsize - 1)
			var my = clamp(floor(((mouse_y + ypos) / 10 - (mouse_x + xpos) / 20) / 2), 0, ysize - 1)
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
			var mx = clamp(floor(((mouse_x + xpos) / 20 + (mouse_y + ypos) / 10) / 2), 0, xsize - 1)
			var my = clamp(floor(((mouse_y + ypos) / 10 - (mouse_x + xpos) / 20) / 2), 0, ysize - 1)
			if mouse_x > 0 and mouse_y > 0 and mouse_x < room_width and mouse_y < room_height
				draw_text(0, 20, clamp(contaminacion[mx, my], 0, 100))
		}
	}
}
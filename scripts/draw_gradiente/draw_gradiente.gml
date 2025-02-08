function draw_gradiente(tipo, modo){
	with control{
		if modo = 0{
			for(var a = min_camx; a < max_camx; a++)
				for(var b = min_camy; b < max_camy; b++)
					if not bosque[a, b] and not mar[a, b]{
						draw_set_color(make_color_rgb(255 * (1 - cultivo[tipo][# a, b]), 255 * cultivo[tipo][# a, b], 0))
						draw_circle(a * 16 + 8 - xpos, b * 16 + 8 - ypos, 6, false)
					}
			draw_set_color(c_white)
			draw_text(0, 0, recurso_nombre[recurso_cultivo[tipo]])
		}
		if modo = 1{
			draw_set_color(recurso_mineral_color[tipo])
			for(var a = min_camx; a < max_camx; a++)
				for(var b = min_camy; b < max_camy; b++)
					if mineral[tipo][a, b]
						draw_circle(a * 16 + 8 - xpos, b * 16 + 8 - ypos, 6, false)
			draw_set_color(c_white)
			draw_text(0, 0, recurso_nombre[recurso_mineral[tipo]])
		}
		if modo = 2{
			draw_set_alpha(0.5)
			for(var a = min_camx; a < max_camx; a++)
				for(var b = min_camy; b < max_camy; b++)
					if not mar[a, b] and floor(belleza[a, b]) != 0.5{
						draw_set_color(make_color_rgb(2.55 * (100 - min(100, max(0, belleza[a, b]))), 2.55 * min(100, max(0, belleza[a, b])), 0))
						draw_rectangle(a * 16 - xpos, b * 16 - ypos, a * 16 + 15 - xpos, b * 16 + 15 - ypos, false)
					}
			draw_set_alpha(1)
			draw_set_color(c_white)
			draw_text(0, 0, "Belleza")
			if mouse_x > 0 and mouse_y > 0 and mouse_x < room_width and mouse_y < room_height
				if not mar[floor((mouse_x + xpos) / 16), floor((mouse_y + ypos) / 16)]
					draw_text(0, 20, min(100, max(0, belleza[floor((mouse_x + xpos) / 16), floor((mouse_y + ypos) / 16)])))
		}
		if modo = 3{
			for(var a = min_camx; a < max_camx; a++)
				for(var b = min_camy; b < max_camy; b++){
					draw_set_color(make_color_hsv(0, 0, 2.55 * (100 - min(100, max(0, contaminacion[a, b])))))
					draw_set_alpha(min(100, max(0, contaminacion[a, b])) / 200)
					draw_rectangle(a * 16 - xpos, b * 16 - ypos, a * 16 + 15 - xpos, b * 16 + 15 - ypos, false)
				}
			draw_set_alpha(1)
			draw_set_color(c_white)
			draw_text(0, 0, "Contaminación")
			if mouse_x > 0 and mouse_y > 0 and mouse_x < room_width and mouse_y < room_height
				draw_text(0, 20, min(100, max(0, contaminacion[floor((mouse_x + xpos) / 16), floor((mouse_y + ypos) / 16)])))
		}
	}
}
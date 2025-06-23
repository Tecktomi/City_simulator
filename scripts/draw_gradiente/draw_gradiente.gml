function draw_gradiente(tipo, modo){
	with control{
		if modo = 0{
			for(var a = min_camx; a < max_camx; a++)
				for(var b = min_camy; b < max_camy; b++)
					if not mar[a, b] and not bosque[# a, b] and not bool_edificio[# a, b]{
						var c = cultivo_max[a, b], d = (a - b) * tile_width - xpos, e = (a + b + 1) * tile_height - ypos
						draw_set_color(cultivo_color[a, b][tipo])
						draw_circle(d, e, tile_height / 2, false)
						if cultivo[c][# a, b] > 0
							draw_sprite_stretched(spr_recursos, recurso_cultivo[c], d - tile_height / 2, e - tile_height / 2, tile_height, tile_height)
					}
			show_string += $"Eficiencia de {recurso_nombre[recurso_cultivo[tipo]]}\n"
			var mx = clamp(floor(((mouse_x + xpos) / tile_width + (mouse_y + ypos) / tile_height) / 2), 0, xsize - 1)
			var my = clamp(floor(((mouse_y + ypos) / tile_height - (mouse_x + xpos) / tile_width) / 2), 0, ysize - 1)
			if not mar[mx, my]{
				var a = cultivo_max[mx, my], b = cultivo[a][# mx, my]
				if b > 0
					show_string += $"Mejor cultivo: {recurso_nombre[recurso_cultivo[a]]} ({floor(100 * b)}%)\n"
				else
					show_string += "Terreno estéril\n"
			}
		}
		else if modo = 1{
			draw_set_color(recurso_mineral_color[tipo])
			for(var a = min_camx; a < max_camx; a++)
				for(var b = min_camy; b < max_camy; b++)
					if not bosque[# a, b] and not bool_edificio[# a, b] and mineral[tipo][a, b]
						draw_circle((a - b) * tile_width - xpos, (a + b + 1) * tile_height - ypos, tile_height / 2, false)
			show_string += $"Depósitos de {recurso_nombre[recurso_mineral[tipo]]}\n"
		}
		else if modo = 2{
			draw_set_alpha(0.5)
			for(var a = min_camx; a < max_camx; a++)
				for(var b = min_camy; b < max_camy; b++)
					if not mar[a, b]{
						var c = 2.55 * clamp(belleza[a, b], 0, 100)
						draw_set_color(make_color_rgb(255 - c, c, 0))
						draw_rombo_coord(a, b, 1, 1, false)
					}
			draw_set_alpha(1)
			show_string += $"Belleza\n"
			var mx = clamp(floor(((mouse_x + xpos) / tile_width + (mouse_y + ypos) / tile_height) / 2), 0, xsize - 1)
			var my = clamp(floor(((mouse_y + ypos) / tile_height - (mouse_x + xpos) / tile_width) / 2), 0, ysize - 1)
			if mouse_x > 0 and mouse_y > 0 and mouse_x < room_width and mouse_y < room_height
				if not mar[mx, my]
					show_string += $"{clamp(belleza[mx, my], 0, 100)}%\n"
		}
		else if modo = 3{
			for(var a = min_camx; a < max_camx; a++)
				for(var b = min_camy; b < max_camy; b++){
					var c = clamp(contaminacion[# a, b], 0, 100)
					if c > 0{
						draw_set_color(make_color_hsv(0, 0, 2.55 * (100 - c)))
						draw_set_alpha(c / 200)
						draw_rombo_coord(a, b, 1, 1, false)
					}
				}
			draw_set_alpha(1)
			show_string += $"Contaminación\n"
			var mx = clamp(floor(((mouse_x + xpos) / tile_width + (mouse_y + ypos) / tile_height) / 2), 0, xsize - 1)
			var my = clamp(floor(((mouse_y + ypos) / tile_height - (mouse_x + xpos) / tile_width) / 2), 0, ysize - 1)
			if mouse_x > 0 and mouse_y > 0 and mouse_x < room_width and mouse_y < room_height
				show_string += $"{clamp(contaminacion[# mx, my], 0, 100)}%\n"
		}
		else if modo = 4{
			show_string += $"Ocupación Residencial\n"
			for(var c = 0; c < array_length(casas); c++){
				var casa = casas[c], a = casa.x, b = casa.y, width = casa.width, height = casa.height
				if a + width > min_camx and b + height > min_camy and a < max_camx and b < max_camy{
					var d = 255 * array_length(casa.familias) / edificio_familias_max[casa.tipo]
					draw_set_color(c_gray)
					draw_rombo_coord(a, b, width, height, false)
					draw_set_alpha(0.5)
					draw_set_color(make_color_rgb(255 - d, d, 0))
					draw_rombo_coord(a, b, width, height, false)
					draw_set_alpha(1)
				}
			}
			var mx = clamp(floor(((mouse_x + xpos) / tile_width + (mouse_y + ypos) / tile_height) / 2), 0, xsize - 1)
			var my = clamp(floor(((mouse_y + ypos) / tile_height - (mouse_x + xpos) / tile_width) / 2), 0, ysize - 1)
			if bool_edificio[# mx, my]{
				var edificio = id_edificio[# mx, my]
				if edificio_es_casa[edificio.tipo]
					show_string += $"Familias: {array_length(edificio.familias)}/{edificio_familias_max[edificio.tipo]}\n"
			}
		}
		else if modo = 5{
			show_string += $"Ocupación Laboral\n"
			for(var c = 0; c < array_length(trabajos); c++){
				var edificio = trabajos[c], a = edificio.x, b = edificio.y, width = edificio.width, height = edificio.height
				if a + width > min_camx and b + height > min_camy and a < max_camx and b < max_camy{
					var d = 255 * array_length(edificio.trabajadores) / edificio.trabajadores_max
					draw_set_color(c_gray)
					draw_rombo_coord(a, b, width, height, false)
					draw_set_alpha(0.5)
					draw_set_color(make_color_rgb(255 - d, d, 0))
					draw_rombo_coord(a, b, width, height, false)
					draw_set_alpha(1)
				}
			}
			var mx = clamp(floor(((mouse_x + xpos) / tile_width + (mouse_y + ypos) / tile_height) / 2), 0, xsize - 1)
			var my = clamp(floor(((mouse_y + ypos) / tile_height - (mouse_x + xpos) / tile_width) / 2), 0, ysize - 1)
			if bool_edificio[# mx, my]{
				var edificio = id_edificio[# mx, my]
				if edificio_es_trabajo[edificio.tipo]
					show_string += $"Trabajadores: {array_length(edificio.trabajadores)}/{edificio.trabajadores_max}\n"
			}
		}
		else if modo = 6{
			show_string += $"Depósitos de Petróleo\n"
			draw_set_color(c_black)
			for(var a = min_camx; a < max_camx; a++)
				for(var b = min_camy; b < max_camy; b++)
					if petroleo[# a, b] > 0
						draw_circle((a - b) * tile_width - xpos, (a + b + 1) * tile_height - ypos, tile_height / 2, false)
		}
		else if modo = 7{
			show_string += $"Protección contra incendios\n"
			for(var a = 0; a < array_length(edificios); a++){
				var edificio = edificios[a]
				draw_set_color(c_gray)
				draw_rombo_coord(edificio.x, edificio.y, edificio.width, edificio.height, false)
				draw_set_color(make_color_hsv(edificio.seguro_fuego * 12, 255, 255))
				draw_set_alpha(0.5)
				draw_rombo_coord(edificio.x, edificio.y, edificio.width, edificio.height, false)
				draw_set_alpha(1)
			}
			var mx = clamp(floor(((mouse_x + xpos) / tile_width + (mouse_y + ypos) / tile_height) / 2), 0, xsize - 1)
			var my = clamp(floor(((mouse_y + ypos) / tile_height - (mouse_x + xpos) / tile_width) / 2), 0, ysize - 1)
			if bool_edificio[# mx, my]{
				var a = id_edificio[# mx, my].seguro_fuego
				if a = 0
					show_string += $"Este edificio podría incendiarse\n"
				else
					show_string += $"Seguro por {a} mes{a = 1 ? "" : "es"}\n"
			}
		}
		else if modo = 8{
			show_string += $"Zonas de pesca\n"
			var mx = clamp(floor(((mouse_x + xpos) / tile_width + (mouse_y + ypos) / tile_height) / 2), 0, xsize - 1)
			var my = clamp(floor(((mouse_y + ypos) / tile_height - (mouse_x + xpos) / tile_width) / 2), 0, ysize - 1)
			var closer = -1, closer_dis = infinity, flag = (zona_pesca_num[# mx, my] > 0)
			for(var c = 0; c < array_length(zonas_pesca); c++){
				var zona_pesca = zonas_pesca[c], a = zona_pesca.a, b = zona_pesca.b
				draw_set_alpha(0.2 + 0.4 * zona_pesca.cantidad / zona_pesca.cantidad_max)
				draw_circle((a - b) * tile_width - xpos, (a + b + 1) * tile_height - ypos, tile_height * (1 + zona_pesca.cantidad / 800), false)
				if flag{
					var closer_current = sqrt(sqr(mx - a) + sqr(my - b))
					if closer_current < closer_dis{
						closer_dis = closer_current
						closer = c
					}
				}
			}
			draw_set_alpha(1)
			if closer >= 0
				show_string += $"Pescado: {floor(zonas_pesca[closer].cantidad)}\n"
		}
	}
}
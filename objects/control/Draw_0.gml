if window_get_cursor() != cursor
	window_set_cursor(cursor)
cursor = cr_arrow
if menu_principal{
	pos = 100
	draw_set_font(font_big)
	if draw_boton(room_width / 2, pos, iniciado ? "Continuar partida" : "Empezar partida", true){
		for(var a = 0; a < array_length(recurso_nombre); a++)
			if (dia / 360) >= recurso_anno[a]
				recurso_precio[a] = recurso_precio_original[a] + (recurso_precio[a] - recurso_precio_original[a]) / power(1.00125, floor(dia * 12 / 360) - 12 * recurso_anno[a])
		menu_principal = false
		iniciado = true
	}
	pos += 10
	if iniciado{
		if draw_boton(room_width / 2, pos, "Nueva partida", true){
			menu_principal = false
			game_restart()
		}
		pos += 10	
	}
	if draw_boton(room_width / 2, pos, $"Fecha inicial: {1800  + floor(dia / 360)}", true,,,,false,, true)
		if mouse_lastbutton = mb_right
			dia = max(0, dia - 360)
		else
			dia = min(dia + 360, 360 * (current_year - 1800))
	pos += 20
	if draw_boton(room_width / 2, pos, "Tutorial", true){
		tutorial = 0
		tutorial_bool = true
		velocidad = 0
		menu_principal = false
	}
	pos += 20
	if keyboard_check_pressed(vk_escape) or draw_boton(room_width / 2, pos, "Salir", true)
		game_end()
	//Imagen de carga
	if not menu_principal{
		draw_set_color(c_black)
		draw_rectangle(0, 0, room_width, room_height, false)
		draw_set_color(c_white)
		draw_text(room_width / 2, 100, "CARGANDO...")
		draw_set_font(font_normal)
		draw_set_halign(fa_left)
		year_history(floor(dia / 360))
	}
	//Pantalla completa
	if keyboard_check_pressed(vk_f4){
		window_set_fullscreen(not window_get_fullscreen())
		ini_open(roaming + "config.txt")
		ini_write_real("MAIN", "fullscreen", window_get_fullscreen())
		ini_close()
	}
	exit
}
#region Visual
	show_string = ""
	mouse_string = ""
	if keyboard_check(ord("Z"))
		for(var a = 0; a < array_length(carreteras); a++){
			var carretera = carreteras[a]
			show_string += $"Carretera {carretera.index}: {array_length(carretera.tramos)} tramos, {array_length(carretera.edificios)} edificios\n"
			for(var b = 0; b < array_length(carretera.edificios); b++)
				show_string += $"    {carretera.edificios[b].nombre}\n"
		}
	if tutorial_bool and not menu{
		tutorial_complete = false
		for(var a = 0; a < array_length(tutorial_keys[tutorial]); a++)
			keyboard_clear(tutorial_keys[tutorial, a])
		for(var a = 0; a < array_length(tutorial_mouse[tutorial]); a++)
			mouse_clear(tutorial_mouse[tutorial, a])
		if not (mouse_x > tutorial_xbox[tutorial] and mouse_y > tutorial_ybox[tutorial] and mouse_x < tutorial_wbox[tutorial] and mouse_y < tutorial_hbox[tutorial]){
			mouse_clear(mb_left)
			mouse_clear(mb_right)
		}
	}
	//Dibujar mundo
	if world_update{
		var prev_tile_width = tile_width
		tile_width = 32
		tile_height = 16
		var surf = surface_create(tile_width * 32, tile_height * 32)
		surface_set_target(surf)
		var i = xsize / 16, j = ysize / 16
		for(var a = 0; a < i; a++)
			for(var b = 0; b < j; b++)
				if chunk_update[a, b]{
					if sprite_exists(chunk[a, b])
						sprite_delete(chunk[a, b])
					draw_clear_alpha(c_black, 0)
					var e = min(16, xsize - a * 16), f = min(16, ysize - b * 16), g = a * 16, h = b * 16
					for(var c = 0; c < e; c++)
						for(var d = 0; d < f; d++)
							if escombros[# g + c, h + d]
								draw_sprite_ext(spr_tile, 0, tile_width * (16 + c - d), (c + d) * tile_height, 1, 1, 0, c_ltgray, 1)
							else if calle[# g + c, h + d]
								draw_sprite_ext(spr_calle, calle_sprite[# g + c, h + d], tile_width * (16 + c - d), (c + d) * tile_height, 1, 1, 0, c_white, 1)
							else
								draw_sprite_ext(spr_tile, 0, tile_width * (16 + c - d), (c + d) * tile_height, 1, 1, 0, altura_color[g + c, h + d], 1)
					var sprite = sprite_create_from_surface(surf, 0, 0, tile_width * 32, tile_height * 32, true, false, 0, 0)
					array_set(chunk[a], b, sprite)
					array_set(chunk_update[a], b, false)
				}
		surface_reset_target()
		surface_free(surf)
		world_update = false
		tile_width = prev_tile_width
		tile_height = prev_tile_width / 2
	}
	#region Dibujo de mundo
		var c = ceil(max_camx / 16), d = floor(min_camy / 16), e = ceil(max_camy / 16)
		for(var a = floor(min_camx / 16); a < c; a++)
			for(var b = d; b < e; b++)
				draw_sprite_stretched(chunk[a, b], 0, (a - b - 1) * 16 * tile_width - xpos, (a + b) * 16 * tile_height - ypos, 32 * tile_width, 32 * tile_height)
		if show_grid{
			draw_set_color(c_ltgray)
			for(var a = 0; a < xsize; a++)
				draw_line(a * tile_width - xpos, a * tile_height - ypos, (a - ysize) * tile_width - xpos, (a + ysize) * tile_height - ypos)
			for(var a = 0; a < ysize; a++)
				draw_line(-a * tile_width - xpos, a * tile_height - ypos, (xsize - a) * tile_width - xpos, (xsize + a) * tile_height - ypos)
	}
	#endregion
	//vistas pre-dibujo
	if not getstring{
		if keyboard_check(ord("G")) and not keyboard_check(vk_lcontrol){
			if mouse_wheel_up()
				build_type = (build_type + 1) mod array_length(recurso_cultivo)
			if mouse_wheel_down()
				build_type = (build_type + array_length(recurso_cultivo) - 1) mod array_length(recurso_cultivo)
			if build_type >= array_length(recurso_cultivo)
				build_type = 0
		}
		if keyboard_check(ord("G")) or (build_sel and edificio_nombre[build_index] = "Granja")
			draw_gradiente(build_type, 0)
		if keyboard_check(ord("M")) and not keyboard_check(vk_lcontrol){
			if mouse_wheel_up()
				build_type = (build_type + 1) mod array_length(recurso_mineral)
			if mouse_wheel_down()
				build_type = (build_type + array_length(recurso_mineral) - 1) mod array_length(recurso_mineral)
			if build_type >= array_length(recurso_mineral)
				build_type = 0
		}
		if keyboard_check(ord("M")) or (build_sel and edificio_nombre[build_index] = "Mina")
			draw_gradiente(build_type, 1)
		if keyboard_check(ord("B")) or (build_sel and (edificio_es_casa[build_index] or build_index = 21))
			draw_gradiente(0, 2)
		if keyboard_check(ord("C"))
			draw_gradiente(0, 3)
		if keyboard_check(ord("P")) or (build_sel and edificio_nombre[build_index] =  "Pozo Petrolífero")
			draw_gradiente(0, 6)
	}
	//Dibujo terrenos a la venta
	draw_set_alpha(0.5)
	draw_set_color(c_white)
	for(var a = 0; a < array_length(terrenos_venta); a++){
		var terreno_venta = terrenos_venta[a]
		draw_rombo_coord(terreno_venta.x, terreno_venta.y, terreno_venta.width, terreno_venta.height, false)
		draw_rombo_coord(terreno_venta.x, terreno_venta.y, terreno_venta.width, terreno_venta.height, true)
	}
	draw_set_alpha(1)
	//Dibujo de arboles y edificios
	for(var a = min_camx; a < max_camx; a++)
		for(var b = min_camy; b < max_camy; b++){
			if bosque[# a, b]
				draw_sprite_stretched(spr_arbol, 0, (a - b - 1) * tile_width - xpos, (a + b - 2) * tile_height - ypos, tile_width * 2, tile_width * 2)
			if bool_draw_edificio[# a, b]
				if edificio_sprite[id_edificio[# a, b].tipo]
					draw_sprite_stretched(edificio_sprite_id[id_edificio[# a, b].tipo], draw_edificio_flip[# a, b], (a - b - 1) * tile_width - xpos, (a + b - 2) * tile_height - ypos, tile_width * 2, tile_width * 2)
				else{
					var edificio = draw_edificio[# a, b], width = edificio.width, height = edificio.height
					c = edificio.x
					d = edificio.y
					e = edificio.tipo
					draw_set_color(make_color_hsv(edificio_color[e], 255, 255))
					draw_rombo_coord(c, d, width, height, false)
					if edificio_resize_no_productiva[e]{
						draw_set_color(c_red)
						draw_set_alpha(0.5)
						draw_rombo_coord(max(edificio.build_x, c - edificio_width[e]), max(edificio.build_y, d - edificio_height[e]), edificio_width[e], edificio_height[e], false)
						draw_set_alpha(1)
					}
					draw_set_color(c_white)
					draw_rombo_coord(c, d, width, height, true)
					if edificio.paro{
						draw_set_color(c_red)
						draw_circle((c - d) * tile_width - xpos, (c + d) * tile_height - ypos, 3, false)
						draw_set_color(c_white)
						draw_circle((c - d) * tile_width - xpos, (c + d) * tile_height - ypos, 3, true)
						if edificio.huelga{
							draw_set_color(c_white)
							draw_rectangle((c - d) * tile_width - xpos, (c + d) * tile_height - ypos, (c - d) * tile_width - xpos + string_width("PARO"), (c + d) * tile_height - ypos + string_height("PARO"), false)
							draw_set_color(c_red)
							draw_text((c - d) * tile_width - xpos, (c + d) * tile_height - ypos, "PARO")
						}
					}
			}
			if bool_draw_construccion[# a, b]{
				var next_build = draw_construccion[# a, b], width = next_build.width, height = next_build.height, var_edificio_nombre = edificio_nombre[next_build.id]
				c = next_build.x
				d = next_build.y
				e = next_build.id
				draw_set_color(make_color_hsv(edificio_color[e], 255, 255))
				draw_set_alpha(0.5)
				draw_rombo_coord(c, d, width, height, false)
				if edificio_resize_no_productiva[e]{
					draw_set_color(c_red)
					draw_rombo_coord(max(next_build.build_x, c - edificio_width[e]), max(next_build.build_y, d - edificio_height[e]), edificio_width[e], edificio_height[e], false)
				}
				draw_set_alpha(1)
				draw_set_color(c_white)
				draw_rombo_coord(c, d, width, height, true)
				draw_text((c - d) * tile_width - xpos, (c + d) * tile_height - ypos, $"{var_edificio_nombre}{var_edificio_nombre = "Mina" ? "\n" + recurso_nombre[recurso_mineral[next_build.tipo]] : ""}{var_edificio_nombre = "Granja" ? "\n" + recurso_nombre[recurso_cultivo[next_build.tipo]] : ""}{var_edificio_nombre = "Rancho" ? "\n" + ganado_nombre[next_build.tipo] : ""}")
			}
		}
	//Dibujo de autitos ^w^
	if tile_width >= 32{
		for(var a = 0; a < array_length(autos); a++){
			var auto = autos[a]
			auto.x += auto.hmove
			auto.y += auto.vmove
			if floor(100 * frac(auto.x)) = 0 and floor(100 * frac(auto.y)) = 0{
				c = auto.x
				d = auto.y
				var f = 0, g = 0, vecinos = [[c - 1, d], [c, d - 1], [c + 1, d], [c, d + 1]], flag  = false, temp_array = array_shuffle([0, 1, 2, 3])
				array_remove(temp_array, (auto.dir + 2) mod 4)
				for(e = 0; e < 4; e++)
					if calle[# vecinos[e, 0], vecinos[e, 1]]{
						flag = true
						break
					}
				if flag{
					flag = false
					while array_length(temp_array) > 0{
						e = array_pop(temp_array)
						f = vecinos[e, 0]
						g = vecinos[e, 1]
						if f >= 0 and f < xsize and g >= 0 and g < ysize and calle[# f, g]{
							flag = true
							auto.dir = e
							auto.hmove = (f - c) / 100
							auto.vmove = (g - d) / 100
							break
						}
					}
					if not flag
						array_delete(autos, a--, 1)
				}
				else
					array_delete(autos, a--, 1)
			}
			draw_sprite_ext(spr_auto, auto.dir, (auto.x - auto.y - 1) * tile_width - xpos, (auto.x + auto.y) * tile_height - ypos, tile_width / 32, tile_height / 16, 0, c_white, 1)
			auto.time--
			if auto.time = 0
				array_delete(autos, a--, 1)
		}
		if random(1) < 0.1{
			var a = irandom_range(min_camx, max_camx), b = irandom_range(min_camy, max_camy), vecinos = [[a - 1, b], [a, b - 1], [a + 1, b], [a, b + 1]], flag = false
			if calle[# a, b]{
				for(c = 0; c < 4; c++)
					if calle[# vecinos[c, 0], vecinos[c, 1]]{
						flag = true
						break
					}
				if flag{
					do{
						c = irandom(3)
						d = vecinos[c, 0]
						e = vecinos[c, 1]
					}
					until d >= 0 and e >= 0 and d < xsize and e < ysize and calle[# d, e]
					array_push(autos, {x : a, y : b, hmove : (d - a) / 100, vmove : (e - b) / 100, dir : c, time : irandom_range(300, 500)})
				}
			}
		}
	}
	#region vistas post-dibujo
		if keyboard_check(ord("Z"))
			for(var a = 0; a < array_length(carreteras); a++){
				var carretera = carreteras[a]
				c = (a mod 4) * 4
				d = floor(a / 4) * 4
				draw_set_color(make_color_hsv(255 * a / array_length(carreteras), 191, 255))
				for(var b = 0; b < array_length(carretera.tramos); b++){
					var temp_calle = carretera.tramos[b]
					draw_circle(tile_width * (temp_calle[0] - temp_calle[1]) - xpos + c, tile_height * (temp_calle[0] + temp_calle[1]) - ypos + d, 3, false)
				}
			}
		if keyboard_check(ord("V"))
			draw_gradiente(0, 4)
		if keyboard_check(ord("T"))
			draw_gradiente(0, 5)
		if keyboard_check(ord("F"))
			draw_gradiente(0, 7)
		if keyboard_check(ord("K")) or (build_sel and edificio_nombre[build_index] = "Pescadería")
			draw_gradiente(0, 8)
	#endregion
	//Información general
	draw_set_alpha(0.5)
	draw_set_color(c_ltgray)
	var text = $"FPS: {fps}\n{fecha(dia)}\n{array_length(personas)} habitante{array_length(personas) = 1 ? "" : "s"}\n$ {floor(dinero)}"
	draw_rectangle(0, room_height, string_width(text), room_height - string_height(text) - 25, false)
	tutorial_set(1, string_width(text) + 10, room_height - string_height(text) - 25,,, 0, room_height - string_height(text) - 25, string_width(text) + 10, room_height)
	tutorial_set(9,,,,, 0, room_height - string_height(text) - 25, string_width(text) + 10, room_height - string_height(text))
	draw_set_color(c_black)
	draw_set_valign(fa_bottom)
	pos = room_height
	draw_text_pos(0, pos, text)
	if draw_sprite_boton(spr_icono, 6, 10, room_height - last_height - 20) and not tutorial_bool
		velocidad = 0
	if draw_sprite_boton(spr_icono, 7, 40, room_height - last_height - 20) and not tutorial_bool
		velocidad = 1
	if draw_sprite_boton(spr_icono, 8, 70, room_height - last_height - 20) and not tutorial_bool
		velocidad = 6
	pos -= 40
	for(var a = 0; a < array_length(exigencia_nombre); a++)
		if exigencia_pedida[a]
			draw_text_pos(0, pos, $"{exigencia_nombre[a]} {exigencia[a].expiracion - dia} días restantes")
	if elecciones
		if draw_boton(0, pos, $"Elecciones en {360 - (dia mod 360)} días"){
			sel_info = false
			sel_build = true
			ministerio = 8
			show[1] = true
		}
	if var_total_comida < 180
		draw_text_pos(0, pos, (var_total_comida > 0) ? $"Poca comida: {var_total_comida} días" : "Sin comida!")
	if array_length(desausiado.clientes) > 0
		draw_text_pos(0, pos, $"Problemas de atención sanitaria: {array_length(desausiado.clientes)} sin tratamiento")
	draw_set_valign(fa_top)
	if show_noticia >= 0{
		draw_set_color(c_black)
		draw_set_alpha(0.25)
		draw_rectangle(0, 0, room_width, room_height, false)
		var noticia = noticias[show_noticia]
		text = $"{fecha(noticia.dia)}\n{noticia.descripcion}"
		var width = string_width(text), height = string_height(text)
		draw_set_alpha(1)
		draw_set_color(c_ltgray)
		draw_rectangle((room_width - width) / 2, (room_height - height) / 2, (room_width + width) / 2, (room_height + height) / 2, false)
		draw_set_color(c_black)
		draw_rectangle((room_width - width) / 2, (room_height - height) / 2, (room_width + width) / 2, (room_height + height) / 2, true)
		draw_set_halign(fa_center)
		draw_text(room_width / 2, (room_height - height) / 2, text)
		if mouse_check_button_pressed(mb_left) or mouse_check_button_pressed(mb_right){
			show_noticia = -1
			mouse_clear(mb_left)
			mouse_clear(mb_right)
		}
		draw_set_halign(fa_left)
	}
	else{
		draw_set_halign(fa_right)
		if draw_menu(room_width - 300, 0, $"{array_length(noticias)} Noticia{array_length(noticias) = 1 ? "" : "s"}", 40, true){
			var width = 0, height = 0
			for(var a = 0; a < min(20, array_length(noticias)); a++){
				width = max(width, string_width(noticias[a].titulo))
				height += string_height(noticias[a].titulo)
			}
			pos = 20
			draw_set_color(c_ltgray)
			draw_rectangle(room_width - 300, pos, room_width - 302 - width, pos + height, false)
			draw_set_color(c_black)
			draw_rectangle(room_width - 300, pos, room_width - 302 - width, pos + height, true)
			for(var a = 0; a < min(20, array_length(noticias)); a++)
				if draw_boton(room_width - 301, pos, noticias[a].titulo,,,,,,, true)
					if mouse_lastbutton = mb_left
						show_noticia = a
					else{
						array_delete(noticias, a, 1)
						if array_length(noticias) = 0
							show[40] = false
					}
		}
		draw_set_halign(fa_left)
	}
	draw_set_alpha(1)
	if sel_comisaria{
		draw_set_color(c_white)
		show_string += "Selecciona un edificio a vigilar"
		draw_rombo_coord(sel_edificio.x, sel_edificio.y, sel_edificio.width, sel_edificio.height, true)
		draw_set_color(c_black)
		if mouse_check_button_pressed(mb_right){
			sel_comisaria = false
			mouse_clear(mb_right)
		}
	}
	if getstring{
		text = $"{getstring_title}\n\n{keyboard_string}{current_second mod 2 = 1 ? "_" : ""}\n\nEnter para aceptar"
		var width = string_width(text), height = string_height(text)
		draw_set_alpha(0.3)
		draw_set_color(c_black)
		draw_rectangle(0, 0, room_width, room_height, false)
		draw_set_color(c_ltgray)
		draw_set_alpha(1)
		draw_rectangle((room_width - width) / 2, (room_height - height) / 2, (room_width + width) / 2, (room_height + height) / 2, false)
		draw_set_color(c_black)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_text(room_width / 2, room_height / 2, text)
		draw_set_halign(fa_left)
		draw_set_valign(fa_top)
		if keyboard_check_pressed(vk_enter){
			getstring_function(keyboard_string, getstring_param)
			getstring = false
		}
		if keyboard_check_pressed(vk_escape){
			getstring_function(getstring_default, getstring_param)
			getstring = false
		}
		if keyboard_check(vk_anykey)
			keyboard_clear(keyboard_lastkey)
		mouse_clear(mb_left)
		mouse_clear(mb_right)
	}
#endregion
//Menú principal
if menu{
	mouse_clear(mb_right)
	draw_set_alpha(0.5)
	draw_set_color(c_black)
	draw_rectangle(0, 0, room_width, room_height, false)
	draw_set_alpha(1)
	draw_set_color(c_ltgray)
	draw_rectangle(300, 100, room_width - 300, room_height - 100, false)
	draw_set_color(c_black)
	draw_set_halign(fa_center)
	draw_set_font(font_big)
	pos = 100
	draw_text_pos(room_width / 2, pos, "Isla Latina")
	draw_set_font(font_normal)
	pos += 40
	if draw_boton(room_width / 2, pos, "Salir al menú principal"){
		menu = false
		menu_principal = true
		exit
	}
	pos += 20
	if draw_boton(room_width / 2, pos, "Continuar")
		menu = false
	pos += 20
	if draw_boton(room_width / 2, pos, "Reiniciar")
		game_restart()
	pos += 20
	if draw_menu(room_width / 2, pos, $"Resolucion: {window_get_width()} x {window_get_height()}", 0){
		if draw_boton(room_width / 2, pos, "1120 x 630", , , function f1(){draw_set_halign(fa_left);draw_text(mouse_x + 10, mouse_y, "1120 x 630");draw_set_halign(fa_center)})
			scr_room_resize(1120, 630)
		if draw_boton(room_width / 2, pos, "1280 x 720", , , function f2(){draw_set_halign(fa_left);draw_text(mouse_x + 10, mouse_y, "1280 x 720");draw_set_halign(fa_center)})
			scr_room_resize(1280, 720)
		if draw_boton(room_width / 2, pos, "1366 x 768", , , function f3(){draw_set_halign(fa_left);draw_text(mouse_x + 10, mouse_y, "1366 x 768");draw_set_halign(fa_center)})
			scr_room_resize(1366, 768)
		if draw_boton(room_width / 2, pos, "1600 x 900", , , function f4(){draw_set_halign(fa_left);draw_text(mouse_x + 10, mouse_y, "1600 x 900");draw_set_halign(fa_center)})
			scr_room_resize(1600, 900)
		if draw_boton(room_width / 2, pos, "1920 x 1080", , , function f5(){draw_set_halign(fa_left);draw_text(mouse_x + 10, mouse_y, "1920 x 1080");draw_set_halign(fa_center)})
			scr_room_resize(1920, 1080)
	}
	if draw_boton(room_width / 2, pos, "Pantalla completa",,, function f6(){draw_set_halign(fa_left);draw_text(mouse_x + 10, mouse_y, "fullscreen");draw_set_halign(fa_center)}){
		window_set_fullscreen(not window_get_fullscreen())
		ini_open(roaming + "config.txt")
		ini_write_real("MAIN", "fullscreen", window_get_fullscreen())
		ini_close()
	}
	if tutorial_bool{
		pos += 30
		if draw_boton(room_width / 2, pos, "Salir del tutorial"){
			tutorial = 0
			tutorial_bool = false
		}
	}
	draw_set_halign(fa_left)
	if mouse_check_button_pressed(mb_left)
		mouse_clear(mb_left)
}
//Abrir menú de construcción
if mouse_check_button_pressed(mb_right) and not build_sel and not sel_build and not build_terreno and not build_calle and mouse_x < room_width - sel_info * 300{
	mouse_clear(mb_right)
	close_show()
	sel_build = true
	sel_info = false
	build_type = 0
	ministerio = -1
	subministerio = 0
	if tutorial = 4
		tutorial_complete = true
}
//Menú de construcción y ministros
if sel_build{
	draw_set_alpha(0.5)
	draw_set_color(c_black)
	draw_rectangle(0, 0, room_width, room_height, false)
	draw_set_alpha(1)
	draw_set_color(c_ltgray)
	draw_rectangle(100, 80, room_width - 100, room_height - 80, false)
	draw_set_color(c_black)
	draw_rectangle(100, 80, room_width - 100, room_height - 80, true)
	var b = 100
	for(var a = 0; a < array_length(edificio_categoria); a++){
		if draw_boton(b, 80, edificio_categoria_nombre[a], true){
			ministerio = -1
			subministerio = a
		}
		b += last_width + 10
	}
	if draw_boton(b, 80, "Privatizar terreno", true)
		ministerio = -2
	b = 100
	for(var a = 0; a < array_length(ministerio_nombre); a++){
		if draw_boton(b, room_height - 100, ministerio_nombre[a], true){
			close_show()
			ministerio = a
			if a = 5
				subministerio = -1
			if tutorial_bool{
				if tutorial = 18 and a = 0
					tutorial_complete = true
				if tutorial = 20 and a = 5
					tutorial_complete = true
			}
		}
		b += last_width + 10
	}
	pos = 100
	//Menú de construcción
	if ministerio = -1{
		for(var a = 0; a < array_length(edificio_categoria[subministerio]); a++){
			b = edificio_categoria[subministerio, a]
			if floor(dia / 360) >= edificio_anno[b]{
				if edificio_categoria_nombre[subministerio] = "Industria"{
					c = room_width - 120
					for(d = 0; d < array_length(edificio_industria_output_id[b]); d++){
						draw_sprite_boton(spr_recursos, edificio_industria_output_id[b, d], c, pos,,,, recurso_nombre[edificio_industria_output_id[b, d]])
						c -= 20
					}
					draw_text(c, pos, "->")
					c -= 30
					for(d = 0; d < array_length(edificio_industria_input_id[b]); d++){
						draw_sprite_boton(spr_recursos, edificio_industria_input_id[b, d], c, pos,,,, recurso_nombre[edificio_industria_input_id[b, d]])
						c -= 20
					}
				}
				else if edificio_categoria_nombre[subministerio] = "Materias Primas"{
					if edificio_nombre[b] = "Granja"{
						for(c = 0; c < array_length(recurso_cultivo); c++)
							draw_sprite_boton(spr_recursos, recurso_cultivo[c], room_width - 120 - 20 * c, pos,,,, recurso_nombre[recurso_cultivo[c]])
					}
					else if edificio_nombre[b] = "Aserradero"
						draw_sprite_boton(spr_recursos, 1, room_width - 120, pos,,,, recurso_nombre[1])
					else if edificio_nombre[b] = "Pescadería"
						draw_sprite_boton(spr_recursos, 8, room_width - 120, pos,,,, recurso_nombre[8])
					else if edificio_nombre[b] = "Mina"{
						for(c = 0; c < array_length(recurso_mineral); c++)
							draw_sprite_boton(spr_recursos, recurso_mineral[c], room_width - 120 - 20 * c, pos,,,, recurso_nombre[recurso_mineral[c]])
					}
					else if edificio_nombre[b] = "Rancho"{
						for(c = 0; c < array_length(recurso_ganado); c++)
							draw_sprite_boton(spr_recursos, recurso_ganado[c], room_width - 120 - 20 * c, pos,,,, recurso_nombre[recurso_ganado[c]])
					}
					else if edificio_nombre[b] = "Tejar"
						draw_sprite_boton(spr_recursos, 26, room_width - 120, pos,,,, recurso_nombre[26])
					else if edificio_nombre[b] = "Pozo Petrolífero"
						draw_sprite_boton(spr_recursos, 27, room_width - 120, pos,,,, recurso_nombre[27])
				}
				if draw_boton(110, pos, $"{edificio_nombre[b]} ${edificio_precio[b]}",,, function(b){
						draw_set_valign(fa_bottom)
						var text = "", temp_precio = 0
						for(var a = 0; a < array_length(edificio_recursos_id[b]); a++){
							text += $"{recurso_nombre[edificio_recursos_id[b, a]]}: {edificio_recursos_num[b, a]}   "
							temp_precio += recurso_precio[edificio_recursos_id[b, a]] * edificio_recursos_num[b, a]
						}
						draw_text(100, room_height - 100, text + $"(+${floor(temp_precio)})\n" +
							(edificio_es_casa[b] ? $"Espacio para {edificio_familias_max[b]} familias\n" : "") +
							(edificio_es_trabajo[b] ? $"Necesita {edificio_trabajadores_max[b]} trabajadores {edificio_trabajo_educacion[b] = 0 ? "sin educación" : "con " + educacion_nombre[edificio_trabajo_educacion[b]]}\n" : "") +
							(edificio_es_escuela[b] ? $"Enseña a {edificio_servicio_clientes[b]} alumnos\n" : "") +
							(edificio_es_medico[b] ? $"Atiende a {edificio_servicio_clientes[b]} pacientes\n" : "") +
							(edificio_es_ocio[b] or edificio_es_iglesia[b] ? $"Acepta {edificio_servicio_clientes[b]} visitantes\n" : "") + edificio_descripcion[b])
						draw_set_valign(fa_top)
					}, b) and dinero + 2500 >= edificio_precio[b]{
					build_index = b
					build_sel = true
					sel_build = false
					if tutorial_bool{
						if tutorial = 7 and edificio_nombre[b] = "Chabola"
							tutorial_complete = true
						if tutorial = 12 and edificio_nombre[b] = "Granja"
							tutorial_complete = true
						if tutorial = 14 and edificio_nombre[b] = "Aserradero"
							tutorial_complete = true
					}
				}
			}
		}
		if floor(dia / 360) > 80 and edificio_categoria_nombre[subministerio] = "Infrastructura" and draw_boton(110, pos, "Calles $10"){
			sel_build = false
			build_calle = true
		}
	}
	//Privatizar terreno
	else if ministerio = -2{
		draw_text_pos(100, pos, "Permisos de construcción")
		b = 0
		for(var a = 0; a < array_length(edificio_categoria_nombre); a++){
			if draw_boton(120, pos, $"{edificio_categoria_nombre[a]}: {build_terreno_permisos[a] ? "H" : "Desh"}abilitado")
				build_terreno_permisos[a] = not build_terreno_permisos[a]
			b += build_terreno_permisos[a]
		}
		pos += 20
		if b > 0 and draw_boton(100, pos, "Privatizar terreno"){
			sel_build = false
			build_terreno = true
		}
	}
	//Ministerios
	else{
		draw_text_pos(100, pos, $"Ministerio de {ministerio_nombre[ministerio]}")
		pos += 20
		//Ministerio de Población
		if ministerio = 0{
			var temp_nacimientos = 0, temp_muertos_viejos = 0, temp_muertos_accidentes = 0, temp_muertos_asesinados = 0, temp_inmigrados = 0, temp_emigrados = 0, temp_inanicion = 0, temp_enfermos = 0
			for(var a = 0; a < 12; a++){
				temp_nacimientos += mes_nacimientos[a]
				temp_muertos_viejos += mes_muertos_viejos[a]
				temp_muertos_accidentes += mes_muertos_accidentes[a]
				temp_muertos_asesinados += mes_muertos_asesinados[a]
				temp_inmigrados += mes_inmigrantes[a]
				temp_emigrados += mes_emigrantes[a]
				temp_inanicion += mes_muertos_inanicion[a]
				temp_enfermos += mes_muertos_enfermos[a]
			}
			var temp_total = temp_nacimientos + temp_inmigrados - temp_muertos_viejos - temp_muertos_accidentes - temp_muertos_asesinados - temp_emigrados - temp_inanicion - temp_enfermos
			draw_text_pos(110, pos, $"Población: {array_length(personas)}")
			if temp_total >= 0
				var temp_text = "Crecimiento "
			else
				temp_text = "Disminución "
			if draw_menu(120, pos, $"{temp_text} {abs(temp_total)}", 1){
				draw_set_color(c_green)
				draw_text_pos(130, pos, $"Nacimientos: {temp_nacimientos}")
				draw_text_pos(130, pos, $"Inmigración: {temp_inmigrados}")
				draw_set_color(c_red)
				if draw_menu(130, pos, $"Muertos: {temp_muertos_viejos + temp_muertos_accidentes + temp_muertos_asesinados + temp_inanicion + temp_enfermos}", 2){
					if temp_muertos_viejos > 0
						draw_text_pos(140, pos, $"Causas naturales: {temp_muertos_viejos}")
					if temp_muertos_accidentes > 0
						draw_text_pos(140, pos, $"Accidentes laborales: {temp_muertos_accidentes}")
					if temp_muertos_asesinados > 0
						draw_text_pos(140, pos, $"Asesinatos: {temp_muertos_asesinados}")
					if temp_inanicion > 0
						draw_text_pos(140, pos, $"Inanición: {temp_inanicion}")
					if temp_enfermos > 0
						if draw_boton(140, pos, $"Enfermedades: {temp_enfermos}")
							ministerio = 3
				}
				draw_text_pos(130, pos, $"Emigración: {temp_emigrados}")
				draw_set_color(c_black)
			}
			//Gráfico de edades
			if draw_menu(120, pos, "Edad", 0){
				var temp_edad, maxi = 0, edad_promedio = 0
				for(var a = 0; a <= 16; a++){
					temp_edad[false, a] = 0
					temp_edad[true, a] = 0
				}
				for(var a = 0; a < array_length(personas); a++){
					var persona = personas[a]
					temp_edad[persona.sexo, min(16, floor(persona.edad / 5))]++
					edad_promedio += persona.edad
				}
				for(var a = 0; a <= 16; a++)
					maxi = max(temp_edad[false, a], max(temp_edad[true, a], maxi))
				edad_promedio /= array_length(personas)
				draw_text_pos(140, pos, $"Edad promedio {round(edad_promedio)}")
				if esperanza_de_vida_num > 0
					draw_text_pos(140, pos, $"Esperanza de vida {round(esperanza_de_vida_sum / esperanza_de_vida_num)}")
				draw_set_halign(fa_center)
				draw_set_font(font_small)
				for(var a = 0; a <= 16; a++){
					draw_set_color(c_fuchsia)
					draw_rectangle(800, 300 - a * 10, 800 - 100 * temp_edad[true, a] / maxi, 309 - a * 10, false)
					draw_set_color(c_aqua)
					draw_rectangle(840, 300 - a * 10, 840 + 100 * temp_edad[false, a] / maxi, 309 - a * 10, false)
					draw_set_color(c_black)
					draw_text(820, 300 - a * 10, $"{a * 5}-{a * 5 + 4}")
				}
				draw_set_halign(fa_left)
				draw_set_font(font_normal)
			}
			//Felicidad
			if draw_menu(120, pos, $"Felicidad: {floor(felicidad_total)}", 3){
				draw_text_pos(130, pos, $"Mínimo esperado: {felicidad_minima}")
				var fel_tra = 0, fel_edu = 0, fel_viv = 0, fel_sal = 0, num_tra = 0, num_edu = 0, fel_oci = 0, fel_ali = 0, fel_tran = 0, num_tran = 0, fel_rel = 0, num_rel = 0, fel_ley = 0, num_ley = 0, fel_cri = 0, fel_temp = 0, len = array_length(personas)
				b = 0
				c = 0
				for(var a = 0; a < array_length(personas); a++){
					var persona = personas[a]
					fel_sal += persona.felicidad_salud
					fel_viv += persona.familia.felicidad_vivienda
					fel_ali += persona.familia.felicidad_alimento
					fel_oci += persona.felicidad_ocio
					fel_cri += persona.felicidad_crimen
					fel_temp += persona.felicidad_temporal
					if persona.familia.casa != homeless and (personas[a].escuela != null_edificio or not in(persona.trabajo, null_edificio, jubilado, delincuente, prostituta)){
						fel_tran += persona.felicidad_transporte
						num_tran++
					}
					if persona.es_hijo{
						fel_edu += persona.felicidad_educacion
						num_edu++
					}
					else{
						fel_ley += persona.felicidad_ley
						num_ley++
					}
					if not persona.es_hijo or (ley_eneabled[2] and persona.trabajo != null_edificio){
						fel_tra += personas[a].felicidad_trabajo
						num_tra++
					}
					if persona.religion{
						fel_rel += persona.felicidad_religion
						num_rel++
					}
				}
				if draw_boton(130, pos, $"Vivienda: {floor(fel_viv / len)}")
					ministerio = 1
				if draw_boton(130, pos, $"Trabajo: {floor(fel_tra / num_tra)}")
					ministerio = 2
				if draw_boton(130, pos, $"Salud: {floor(fel_sal / len)}")
					ministerio = 3
				if draw_boton(130, pos, $"Educación: {floor(fel_edu / num_edu)}")
					ministerio = 4
				draw_text_pos(130, pos, $"Alimentación: {floor(fel_ali / len)}")
				draw_text_pos(130, pos, $"Entretenimiento: {floor(fel_oci / len)}")
				draw_text_pos(130, pos, $"Transporte: {floor(fel_tran / num_tran)}")
				draw_text_pos(130, pos, $"Religión: {floor(fel_rel / num_rel)}")
				draw_text_pos(130, pos, $"Legislación: {floor(fel_ley / num_ley)}")
				draw_text_pos(130, pos, $"Delincuencia: {floor(fel_cri / len)}")
				draw_text_pos(130, pos, $"Eventos recientes: {floor(fel_temp / len)}")
				//Gráfico de felicidad
				if array_length(anno_felicidad) > 1{
					b = 200 / (array_length(anno_felicidad) - 1)
					draw_line(130, pos + 20, 130, pos + 120)
					draw_line(130, pos + 120, 330, pos + 120)
					for(var a = 0; a < array_length(anno_felicidad) - 1; a++)
						draw_line(130 + a * b, pos + 120 - anno_felicidad[a], 130 + (a + 1) * b, pos + 120 - anno_felicidad[a + 1])
				}
			}
			//Mostrar personas
			pos = 120
			if mouse_wheel_up()
				show_scroll--
			if mouse_wheel_down()
				show_scroll++
			if draw_menu(400, pos, show[5] ? $"Personas {array_length(personas)}" : $"Familias {array_length(familias)}", 5){
				if draw_menu(400, pos, show[4] ? "Favoritos" : "Todo el mundo", 4)
					var temp_array_personas = personas_favoritas
				else
					temp_array_personas = personas
				var last_pos = pos
				show_scroll = max(0, min(show_scroll, array_length(temp_array_personas) - 20))
				var max_width = 400, max_width_2 = 0
				if draw_boton(max_width, pos, "Nombre")
					array_sort(temp_array_personas, function(a = null_persona, b = null_persona){return (a.nombre > b.nombre) ? 1 : -1})
				for(var a = 0; a < min(20, array_length(temp_array_personas)); a++){
					var persona = temp_array_personas[a + show_scroll]
					if draw_boton(max_width, pos, name(persona))
						select(,, persona)
					max_width_2 = max(max_width_2, last_width)
				}
				max_width += max_width_2 + 10
				pos = last_pos
				max_width_2 = 0
				if draw_boton(max_width, pos, "Edad")
					array_sort(temp_array_personas, function(a = null_persona, b = null_persona){return (a.edad > b.edad) ? 1 : -1})
				for(var a = 0; a < min(20, array_length(temp_array_personas)); a++){
					var persona = temp_array_personas[a + show_scroll]
					draw_text_pos(max_width, pos, $"{persona.edad} años")
					max_width_2 = max(max_width_2, last_width)
				}
				max_width += max_width_2 + 10
				if array_length(temp_array_personas) > 20{
					draw_rectangle(max_width - 1, last_pos, max_width + 1, pos, false)
					draw_circle(max_width, last_pos + (show_scroll / (array_length(temp_array_personas) - 20)) * (pos - last_pos), 6, false)
					if mouse_x >= max_width - 5 and mouse_y > last_pos and mouse_x <= max_width + 5 and mouse_y <= pos{
						cursor = cr_handpoint
						if mouse_check_button_pressed(mb_left)
							build_pressed = true
					}
					if mouse_check_button_released(mb_left)
						build_pressed = false
					if build_pressed and mouse_y > last_pos and mouse_y <= pos
						show_scroll = floor((mouse_y - last_pos) * (array_length(temp_array_personas) - 20) / (pos - last_pos))
				}
			}
			else{
				show_scroll = max(0, min(show_scroll, array_length(familias) - 20))
				for(var a = 0; a < min(20, array_length(familias)); a++){
					var familia = familias[show_scroll + a]
					if draw_boton(400, pos, $"{name_familia(familia)} ({familia.integrantes})")
						select(, familia)
				}
			}
		}
		//Ministerio de Vivienda
		else if ministerio = 1{
			var temp_array, fel_viv = 0
			for(var a = 0; a < array_length(edificio_nombre); a++)
				if edificio_es_casa[a]
					temp_array[a] = 0
			for(var a = 0; a < array_length(personas); a++){
				fel_viv += personas[a].familia.felicidad_vivienda
				temp_array[personas[a].familia.casa.tipo]++
			}
			draw_text_pos(110, pos, $"Felicidad vivenda: {floor(fel_viv / array_length(personas))}")
			for(var a = 0; a < array_length(edificio_nombre); a++)
				if edificio_es_casa[a] and (edificio_nombre[a] = "Homeless" or array_length(edificio_count[a]) > 0)
					if draw_menu(110, pos, $"{edificio_nombre[a]}: {temp_array[a]} habitante{temp_array[a] = 1 ? "" : "s"} ({floor(temp_array[a] * 100 / array_length(personas))}%)", a)
						for(b = 0; b < array_length(edificio_count[a]); b++)
							if draw_boton(120, pos, edificio_count[a, b].nombre)
								select(edificio_count[a, b])
			if draw_menu(110, pos, $"{array_length(casas_libres)} vivienda{array_length(casas_libres) = 1 ? "" : "s"} libre{array_length(casas_libres) = 1 ? "" : "s"}", 0)
				for(var a = 0; a < array_length(casas_libres); a++)
					if draw_boton(120, pos, casas_libres[a].nombre)
						select(casas_libres[a])
			//Fujo de agua
			if (dia / 360) > 50{
				pos += 10
				draw_text_pos(120, pos, $"Entrada máxima de agua: {agua_input}")
				draw_text_pos(120, pos, $"Salida máxima de agua: {agua_output}")
				draw_text_pos(120, pos, $"Eficiencia: {min(100, 100 * agua_input / agua_output)}%")
			}
			//Flujo de energía
			if (dia / 360) > 90{
				pos += 10
				draw_text_pos(120, pos, $"Entrada máxima de energía: {energia_input}")
				draw_text_pos(120, pos, $"Salida máxima de energía: {energia_output}")
				draw_text_pos(120, pos, $"Eficiencia: {min(100, 100 * energia_input / energia_output)}%")
			}
		}
		//Ministerio de Trabajo
		else if ministerio = 2{
			var fel_tra= 0, num_tra = 0, temp_array, num_des = 0, num_temp = 0, trab_esta = 0, num_nin = 0, num_del = 0, num_pro = 0
			for(var a = 0; a < array_length(edificio_nombre); a++)
				temp_array[a] = 0
			for(var a = 0; a < array_length(personas); a++){
				var persona = personas[a]
				if not persona.es_hijo{
					fel_tra += persona.felicidad_trabajo
					num_tra++
					temp_array[persona.trabajo.tipo]++
					num_des += (persona.trabajo = null_edificio)
					trab_esta += not persona.trabajo.privado
					num_pro += (persona.trabajo = prostituta)
				}
				if persona.trabajo.tipo = delincuente.tipo
					num_del++
				num_nin += (persona.es_hijo and persona.trabajo != null_edificio)
			}
			var vacantes = 0, vacantes_tipo
			for(var a = 0; a < array_length(edificio_nombre); a++)
				if edificio_es_trabajo[a]{
					vacantes_tipo[a] = 0
					for(b = 0; b < array_length(edificio_count[a]); b++){
						var edificio = edificio_count[a, b]
						vacantes_tipo[a] += edificio.trabajadores_max_allow - array_length(edificio.trabajadores)
						if ley_eneabled[6] and a = 20
							num_temp += array_length(edificio.trabajadores)
					}
					vacantes += vacantes_tipo[a]
				}
			draw_text_pos(110, pos, $"Felicidad laboral: {floor(fel_tra / num_tra)}")
			draw_text_pos(110, pos, $"Desempleo: {floor(100 * num_des / num_tra)}%")
			if draw_menu(110, pos, $"{vacantes} puesto{vacantes = 1 ? "" : "s"} de trabajo disponible{vacantes = 1 ? "" : "s"}", 1)
				for(var a = 0; a < array_length(edificio_nombre); a++)
					if edificio_es_trabajo[a] and (edificio_nombre[a] = "Desempleado" or array_length(edificio_count[a]) > 0) and draw_menu(120, pos, $"{edificio_nombre[a]}: {temp_array[a]}/{vacantes_tipo[a] + temp_array[a]} trabajadores", a + 7)
						for(b = 0; b < array_length(edificio_count[a]); b++)
							if draw_boton(120, pos, $"{edificio_nombre[a]} {b + 1}")
								select(edificio_count[a, b])
			if draw_menu(110, pos, $"{array_length(cola_construccion)} edificio{array_length(cola_construccion) = 1 ? "" : "s"} en construcción", 0)
				for(var a = 0; a < array_length(cola_construccion); a++){
					var next_build = cola_construccion[a]
					if draw_boton(120, pos, $"{edificio_nombre[next_build.id]} {floor(100 * (1 - next_build.tiempo / next_build.tiempo_max))}%")
						select(,,, next_build)
				}
			draw_text_pos(110, pos, $"{num_temp} trabajador{num_temp = 1 ? "" : "es"} temporal{num_temp = 1 ? "" : "es"} ({floor(100 * num_temp / num_tra)}%)")
			draw_text_pos(110, pos, $"{floor(100 * num_del / num_tra)}% de delincuencia")
			draw_text_pos(110, pos, $"{floor(100 * num_pro / num_tra)}% de prostitución")
			draw_text_pos(110, pos, $"Piratería: {pirateria}%")
			if num_tra > 0
				draw_text_pos(110, pos, $"{floor(100 * trab_esta / num_tra)} % de trabajadores estatales.")
			if ley_eneabled[2] and num_tra > 0
				draw_text_pos(110, pos, $"{floor(100 * num_nin / num_tra)} % de trabajores son niños.")
			for(var a = 0; a < array_length(educacion_nombre); a++)
				if array_length(trabajo_educacion[a]) > 0 and draw_menu(110, pos, educacion_nombre[a], a + 2)
					for(b = 0; b < array_length(trabajo_educacion[a]); b++)
						draw_text_pos(120, pos, trabajo_educacion[a, b].nombre)
		}
		//Ministerio de Salud
		else if ministerio = 3{
			var fel_sal = 0, temp_enfermos = 0, num_sal = 0, temp_espera = 0, num_hambre = 0, num_almacenes = 0, temp_accidentes = 0, num_impor = 0, total_comida = 0
			for(var a = 0; a < array_length(personas); a++){
				fel_sal += personas[a].felicidad_salud
				if personas[a].medico != null_edificio{
					num_sal++
					if personas[a].medico != desausiado
						temp_espera++
				}
			}
			for(var a = 0; a < array_length(edificio_almacen_index); a++)
				for(b = 0; b < array_length(almacenes[edificio_almacen_index[a]]); b++){
					var edificio = almacenes[edificio_almacen_index[a], b]
					d = 0
					for(c = 0; c < array_length(recurso_comida); c++)
						d += edificio.almacen[recurso_comida[c]]
					if d > 0{
						total_comida += d
						num_almacenes++
					}
				}
			draw_text_pos(110, pos, $"Satisfación sanitaria: {floor(fel_sal / array_length(personas))}")
			for(var a = 0; a < 12; a++){
				temp_enfermos += mes_muertos_enfermos[a]
				temp_accidentes += mes_accidentes[a]
			}
			draw_text_pos(110, pos, $"{temp_enfermos} muerte{temp_enfermos = 1 ? "" : "s"} por enfermedad el último año")
			draw_text_pos(110, pos, $"{num_sal} persona{num_sal = 1 ? "" : "s"} enferma{num_sal = 1 ? "" : "s"}")
			draw_text_pos(120, pos, $"{array_length(desausiado.clientes)} persona{array_length(desausiado.clientes) = 1 ? "" : "s"} sin atención médica")
			draw_text_pos(120, pos, $"{temp_espera} persona{temp_espera = 1 ? "" : "s"} atendida{temp_espera = 1 ? "" : "s"}")
			draw_text_pos(120, pos, $"{temp_accidentes} accidente{temp_accidentes = 1 ? "" : "s"} laboral{temp_accidentes = 1 ? "" : "es"} el último año")
			if draw_menu(110, pos, $"{array_length(medicos) - 1} edificio{array_length(medicos) = 2 ? "" : "s"} médico{array_length(medicos) = 2 ? "" : "s"}", 0)
				for(var a = 0; a < array_length(edificio_nombre); a++)
					if edificio_es_medico[a]
						for(b = 0; b < array_length(edificio_count[a]); b++)
							if draw_boton(120, pos, $"{edificio_count[a, b].nombre} ({array_length(edificio_count[a, b].clientes)} cliente{array_length(edificio_count[a, b].clientes) = 1 ? "" : "s"})")
								select(edificio_count[a, b])
			for(var a = 0; a < array_length(familias); a++)
				num_hambre += (familias[a].felicidad_alimento < 10) * (real(familias[a].padre != null_persona) + real(familias[a].madre != null_persona) + array_length(familias[a].hijos))
			draw_text_pos(110, pos, $"{num_hambre} persona{num_hambre = 1 ? "" : "s"} hambrieta{num_hambre = 1 ? "" : "s"}")
			if draw_menu(110, pos, $"{num_almacenes} edificio{num_almacenes = 1 ? "" : "s"} distribuyendo comida", 1)
				for(var a = 0; a < array_length(edificio_almacen_index); a++)
					for(b = 0; b < array_length(almacenes[edificio_almacen_index[a]]); b++){
						var edificio = almacenes[edificio_almacen_index[a], b]
						d = 0
						for(c = 0; c < array_length(recurso_comida); c++)
							d += edificio.almacen[recurso_comida[c]]
						if d >= 1{
							if draw_boton(120, pos, edificio.nombre)
								select(edificio)
							draw_text_pos(130, pos, $"{floor(d)} comida almacenada")
						}
					}
			draw_text_pos(110, pos, $"Alimento necesario al año: {array_length(personas) * 12}")
			draw_text_pos(120, pos, $"Reservas para {floor(30 * total_comida / array_length(personas))} días")
			for(var a = 0; a < array_length(recurso_comida); a++)
				num_impor += recurso_importado_fijo[recurso_comida[a]]
			if num_impor > 0
				draw_text_pos(120, pos, $"({num_impor} alimentos importados)")
		}
		//Ministerio de Educación
		else if ministerio = 4{
			var fel_edu = 0, num_edu = 0, temp_educacion
			for(var a = 0; a < array_length(educacion_nombre); a++)
				temp_educacion[a] = 0
			for(var a = 0; a < array_length(personas); a++){
				if personas[a].es_hijo{
					fel_edu += personas[a].felicidad_educacion
					num_edu++
				}
				temp_educacion[personas[a].educacion]++
			}
			draw_text_pos(110, pos, $"Satisfacción educacional: {floor(fel_edu / num_edu)}")
			for(var a = 0; a < array_length(educacion_nombre); a++)
				draw_text_pos(120, pos, $"{educacion_nombre[a]}: {temp_educacion[a]} ({floor(temp_educacion[a] * 100 / array_length(personas))}%)")
			if draw_menu(110, pos, $"{array_length(escuelas)} instituci{array_length(escuelas) = 1 ? "ón" : "ones"} educativa{array_length(escuelas) = 1 ? "" : "s"}", 0)
				for(var a = 0; a < array_length(edificio_nombre); a++)
					if edificio_es_escuela[a]
						for(b = 0; b < array_length(edificio_count[a]); b++)
							if draw_boton(120, pos, $"{edificio_count[a, b].nombre} ({array_length(edificio_count[a, b].clientes)} estudiante{array_length(edificio_count[a, b].clientes) = 1 ? "" : "s"})")
								select(edificio_count[a, b])
			if radioemisoras > 0
				draw_text_pos(110, pos, $"Calidad de la radio: {floor(radioemisoras)}")
			if television > 0
				draw_text_pos(110, pos, $"Calidad de la televisión: {floor(television)}")
			if draw_boton(110, pos, $"Propaganda política: {adoctrinamiento}"){
				adoctrinamiento = ++adoctrinamiento mod 6
				if adoctrinamiento_escuelas
					for(var a = 0; a < array_length(edificio_count[6]); a++)
						set_calidad_servicio(edificio_count[6, a])
				if adoctrinamiento_biblioteca
					for(var a = 0; a < array_length(edificio_count[61]); a++)
						set_calidad_servicio(edificio_count[61, a])
				if adoctrinamiento_universidades
					for(var a = 0; a < array_length(edificio_count[62]); a++)
						set_calidad_servicio(edificio_count[62, a])
			}
			adoctrinamiento_escuelas = draw_boton_rectangle(110, pos, 125, pos + 15, adoctrinamiento_escuelas)
			draw_text_pos(130, pos, "Porpaganda en escuelas")
			adoctrinamiento_biblioteca = draw_boton_rectangle(110, pos, 125, pos + 15, adoctrinamiento_biblioteca)
			draw_text_pos(130, pos, "Porpaganda en bibliotecas")
			adoctrinamiento_universidades = draw_boton_rectangle(110, pos, 125, pos + 15, adoctrinamiento_universidades)
			draw_text_pos(130, pos, "Porpaganda en universidades")
			adoctrinamiento_periodico = draw_boton_rectangle(110, pos, 125, pos + 15, adoctrinamiento_periodico)
			draw_text_pos(130, pos, "Porpaganda en periódico")
			adoctrinamiento_prision = draw_boton_rectangle(110, pos, 125, pos + 15, adoctrinamiento_prision)
			draw_text_pos(130, pos, "Porpaganda en prisiones")
		}
		//Ministerio de Economía
		else if ministerio = 5{
			var temp_array, temp_grid, temp_text_array, count, maxi, temp_exportaciones, temp_exportaciones_id, temp_importaciones, temp_importaciones_id, temp_compra, temp_compra_id, temp_venta, temp_venta_id, temp_entrada_micelaneo, temp_salida_micelaneo, temp_construccion = 0, temp_construccion_precio = 0, temp_importacion_privada = 0
			#region Definición de variables
				temp_grid[0] = mes_renta
				temp_grid[1] = mes_tarifas
				temp_grid[2] = mes_herencia
				temp_grid[3] = mes_exportaciones
				temp_grid[4] = mes_sueldos
				temp_grid[5] = mes_mantenimiento
				temp_grid[6] = mes_construccion
				temp_grid[7] = mes_importaciones
				temp_grid[8] = mes_compra_interna
				temp_grid[9] = mes_venta_interna
				temp_grid[10] = mes_privatizacion
				temp_grid[11] = mes_estatizacion
				temp_grid[12] = mes_impuestos
				temp_grid[13] = mes_entrada_micelaneo
				temp_grid[14] = mes_salida_micelaneo
				temp_grid[15] = mes_investigacion
				temp_grid[16] = mes_venta_comida
				temp_grid[17] = mes_comida_privada
				temp_text_array[0] = "Renta"
				temp_text_array[1] = "Tarifas"
				temp_text_array[2] = "Herencia"
				temp_text_array[3] = "Exportaciones"
				temp_text_array[4] = "Sueldos"
				temp_text_array[5] = "Mantenimiento"
				temp_text_array[6] = "Construcción"
				temp_text_array[7] = "Importaciones"
				temp_text_array[8] = "Compra a Privados"
				temp_text_array[9] = "Venta a Privados"
				temp_text_array[10] = "Privatización"
				temp_text_array[11] = "Estatización"
				temp_text_array[12] = "Impuestos"
				temp_text_array[13] = "Otros"
				temp_text_array[14] = "Otros"
				temp_text_array[15] = "Tecnología"
				temp_text_array[16] = "Venta de comida"
				temp_text_array[17] = "Comida vendida por privados"
			#endregion
			for(var a = 0; a < array_length(temp_grid); a++){
				count[a] = 0
				maxi[a] = 0
			}
			for(var a = 0; a < array_length(recurso_nombre); a++){
				temp_exportaciones[a] = 0
				temp_exportaciones_id[a] = 0
				temp_importaciones[a] = 0
				temp_importaciones_id[a] = 0
				temp_compra[a] = 0
				temp_compra_id[a] = 0
				temp_venta[a] = 0
				temp_venta_id[a] = 0
				temp_construccion += recurso_construccion[a]
				temp_construccion_precio += recurso_precio[a] * recurso_construccion[a]
				temp_importacion_privada += recurso_importacion_privada[a]
			}
			for(var a = 0; a < 12; a++){
				for(b = 0; b < array_length(temp_grid); b++){
					count[b] += temp_grid[b, (a + current_mes) mod 12]
					maxi[b] = max(maxi[b], temp_grid[b, a])
				}
				for(b = 0; b < array_length(recurso_nombre); b++){
					temp_exportaciones[b] += mes_exportaciones_recurso[a, b]
					temp_exportaciones_id[b] += mes_exportaciones_recurso_num[a, b]
					temp_importaciones[b] += mes_importaciones_recurso[a, b]
					temp_importaciones_id[b] += mes_importaciones_recurso_num[a, b]
					temp_compra[b] += mes_compra_recurso[a, b]
					temp_compra_id[b] += mes_compra_recurso_num[a, b]
					temp_venta[b] += mes_venta_recurso[a, b]
					temp_venta_id[b] += mes_venta_recurso_num[a, b]
				}
			}
			for(var a = 0; a < array_length(temp_grid); a++){
				count[a] = round(count[a])
				maxi[a] = round(maxi[a])
			}
			var temp_ingresos = count[0] + count[1] + count[2] + count[3] + count[9] + count[10] + count[12] + count[13] + count[16]
			if temp_ingresos >= 1 and draw_menu(110, pos, $"Ingresos: ${temp_ingresos}", 0){
				if count[0] >= 1
					draw_text_pos(120, pos, $"{temp_text_array[0]}: ${floor(count[0])}")
				if count[1] >= 1
					draw_text_pos(120, pos, $"{temp_text_array[1]}: ${floor(count[1])}")
				if count[2] >= 1
					draw_text_pos(120, pos, $"{temp_text_array[2]}: ${floor(count[2])}")
				if count[3] >= 1 and draw_menu(120, pos, $"{temp_text_array[3]}: ${floor(count[3])}", 1)
					for(c = 0; c < array_length(recurso_nombre); c++)
						if temp_exportaciones[c] > 0
							draw_text_pos(130, pos, $"{recurso_nombre[c]}: ${floor(temp_exportaciones[c])} ({floor(temp_exportaciones_id[c])})")
				if count[9] >= 1 and draw_menu(120, pos, $"{temp_text_array[9]}: ${floor(count[9])}", 6)
					for(c = 0; c < array_length(recurso_nombre); c++)
						if temp_venta[c] > 0
							draw_text_pos(130, pos, $"{recurso_nombre[c]}: ${floor(temp_venta[c])} ({floor(temp_venta_id[c])})")
				if count[10]>= 1
					draw_text_pos(120, pos, $"{temp_text_array[10]}: ${floor(count[10])}")
				if count[12] >= 1
					draw_text_pos(120, pos, $"{temp_text_array[12]}: ${floor(count[12])}")
				if count[16] >= 1
					draw_text_pos(120, pos, $"{temp_text_array[16]}: ${floor(count[16])}")
				if count[13] >= 1
					draw_text_pos(120, pos, $"{temp_text_array[13]}: ${floor(count[13])}")
			}
			var temp_perdidas = count[4] + count[5] + count[6] + count[7] + count[8] + count[11] + count[14] + count[15]
			if temp_perdidas >= 1 and draw_menu(110, pos, $"Pérdidas: ${temp_perdidas}", 2){
				if count[4] >= 1
					draw_text_pos(120, pos, $"{temp_text_array[4]}: ${floor(count[4])}")
				if count[5] >= 1
					draw_text_pos(120, pos, $"{temp_text_array[5]}: ${floor(count[5])}")
				if count[6] >= 1
					draw_text_pos(120, pos, $"{temp_text_array[6]}: ${floor(count[6])}")
				if count[7] >= 1 and draw_menu(120, pos, $"{temp_text_array[7]}: ${floor(count[7])}", 3)
					for(c = 0; c < array_length(recurso_nombre); c++)
						if temp_importaciones[c] > 0
							draw_text_pos(130, pos, $"{recurso_nombre[c]}: ${floor(temp_importaciones[c])} ({floor(temp_importaciones_id[c])})")
				if count[8] >= 1 and draw_menu(120, pos, $"{temp_text_array[8]}: ${floor(count[8])}", 7)
					for(c = 0; c < array_length(recurso_nombre); c++)
						if temp_compra[c] > 0
							draw_text_pos(130, pos, $"{recurso_nombre[c]}: ${floor(temp_compra[c])} ({floor(temp_compra_id[c])})")
				if count[11] >= 1
					draw_text_pos(120, pos, $"{temp_text_array[11]}: ${floor(count[11])}")
				if count[15] >= 1
					draw_text_pos(120, pos, $"{temp_text_array[15]}: ${floor(count[15])}")
				if count[14] >= 1
					draw_text_pos(120, pos, $"{temp_text_array[14]}: ${floor(count[14])}")
			}
			draw_text_pos(110, pos, $"Balance: {temp_ingresos - temp_perdidas}")
			var temp_otros = floor(count[17])
			if temp_otros > 0{
				pos += 10
				if draw_menu(110, pos, $"Otros movimientos: {temp_otros}", 8){
					if count[17] >= 1
						draw_text_pos(120, pos, $"{temp_text_array[17]}: ${floor(count[17])}")
				}
			}
			if temp_construccion > 0{
				pos += 10
				if draw_menu(110, pos, $"Recursos construcción: {temp_construccion} (${floor(temp_construccion_precio)})", 9)
					for(var a = 0; a < array_length(recurso_nombre); a++)
						if recurso_construccion[a] > 0
							draw_text_pos(130, pos, $"{recurso_nombre[a]}: {recurso_construccion[a]}")
			}
			if temp_importacion_privada > 0{
				pos += 10
				if draw_menu(110, pos, $"Importación privada: {temp_importacion_privada}", 10)
					for(var a = 0; a < array_length(recurso_nombre); a++)
						if recurso_importacion_privada[a] > 0
							draw_text_pos(130, pos, $"{recurso_nombre[a]}: {recurso_importacion_privada[a]}")
				
			}
			pos += 20
			if draw_menu(110, pos, $"{array_length(encargos)} encargo{array_length(encargos) = 1 ? "" : "s"}", 4)
				for(var a = 0; a < array_length(encargos); a++){
					var encargo = encargos[a]
					if encargo.cantidad > 0{
						if encargo.edificio != null_edificio{
							if draw_boton(120, pos, $"{encargo.cantidad} de {recurso_nombre[encargo.recurso]} de {encargo.edificio.nombre}")
								select(encargo.edificio)
						}
						else
							draw_text_pos(120, pos, $"{encargo.cantidad} de {recurso_nombre[encargo.recurso]}")
					}
					else if draw_boton(120, pos, $"{-encargo.cantidad} de {recurso_nombre[encargo.recurso]} a {encargo.edificio.nombre}")
						select(encargo.edificio)
				}
			pos = 100
			draw_set_color(c_black)
			//Menú general
			if subministerio = -1{
				draw_text_pos(500, pos, "Mercado internacional")
				var max_width = 0, last_pos = 160, max_width_2 = 0
				if mouse_wheel_up()
					show_scroll--
				if mouse_wheel_down()
					show_scroll++
				show_scroll = clamp(show_scroll, 0, array_length(recurso_current) - 20)
				for(var a = 0; a < 20; a++){
					b = recurso_current[a + show_scroll]
					if draw_boton(420, last_pos + a * 20, recurso_nombre[b])
						subministerio = b
					max_width = max(max_width, last_width)
				}
				pos = 120
				draw_text_pos(420 + max_width, pos, "Exportar")
				pos += 20
				for(var a = 0; a < 20; a++){
					b = recurso_current[a + show_scroll]
					recurso_exportado[b] = draw_boton_rectangle(420 + max_width + last_width / 2 - 5, pos + a * 20, 420 + max_width + last_width / 2 + 13, pos + a * 20 + 18, recurso_exportado[b])
				}
				max_width += last_width + 10
				pos = 120
				draw_text_pos(420 + max_width, pos, "Importar")
				pos = 140
				draw_text_pos(420 + max_width, pos, "Única")
				max_width_2 = max(max_width_2, last_width)
				last_pos = pos
				for(var a = 0; a < 20; a++){
					b = recurso_current[a + show_scroll]
					if draw_boton(420 + max_width, last_pos + a * 20, $"{recurso_importado_fijo[b]}",,,,,,, true){
						c = 100 + 400 * keyboard_check(vk_lshift)
						if mouse_lastbutton = mb_left
							recurso_importado_fijo[b] += c
						else
							recurso_importado_fijo[b] = max(0, recurso_importado_fijo[b] - c)
					}
					max_width_2  = max(max_width_2, last_width)
				}
				max_width += max_width_2 + 10
				pos = 140
				draw_text_pos(420 + max_width, pos, "Anual")
				max_width_2 = last_width
				for(var a = 0; a < 20; a++){
					b = recurso_current[a + show_scroll]
					if draw_boton(420 + max_width, last_pos + a * 20, $"{recurso_importado[b]}",,,,,,, true){
						c = 100 + 400 * keyboard_check(vk_lshift)
						if mouse_lastbutton = mb_left
							recurso_importado[b] += c
						else
							recurso_importado[b] = max(0, recurso_importado[b] - c)
					}
					max_width_2 = max(max_width_2, last_width)
				}
				max_width += max_width_2 + 10
				pos = 120
				draw_text_pos(420 + max_width, pos, "Balance")
				pos += 20
				for(var a = 0; a < 20; a++){
					b = recurso_current[a + show_scroll]
					if draw_sprite_boton(spr_icono, 4 + (recurso_historial[b, 23] < recurso_historial[b, 0]), 430 + max_width, pos + a * 20, 20, 20){
						var flag = show[b + 11]
						close_show()
						show[b + 11] = not flag
					}
					draw_line(420, pos + a * 20, 460 + max_width, pos + a * 20)
				}
				for(var a = 0; a < array_length(recurso_nombre); a++)
					if show[a + 11]{
						draw_line(800, 150, 800, 350)
						draw_line(800, 350, 1040, 350)
						var mini = recurso_precio[a], maxa = recurso_precio[a]
						for(b = 0; b < 24; b++){
							mini = min(mini, recurso_historial[a, b])
							maxa = max(maxa, recurso_historial[a, b])
						}
						draw_set_halign(fa_right)
						draw_text(800, 150, $"${maxa}")
						draw_text(800, 350, $"${mini}")
						draw_set_halign(fa_center)
						draw_text(920, 350, $"{recurso_nombre[a]}")
						draw_set_halign(fa_left)
						maxa = maxa - mini
						draw_text(1040, 350 - 200 * (recurso_historial[a, 23] - mini) / maxa, $"${recurso_precio[a]}")
						for(b = 0; b < 23; b++)
							draw_line(800 + b * 10, 350 - 200 * (recurso_historial[a, b] - mini) / maxa, 800 + (b + 1) * 10, 350 - 200 * (recurso_historial[a, b + 1] - mini) / maxa)
					}
			}
			//Menú por recurso
			else{
				draw_text_pos(500, pos, "Detalles por Recurso")
				if mouse_wheel_up()
					show_scroll--
				if mouse_wheel_down()
					show_scroll++
				show_scroll = clamp(show_scroll, 0, array_length(recurso_current) - 20)
				var width = 0
				for(var a = 0; a < 20; a++){
					b = recurso_current[a + show_scroll]
					width = max(width, string_width(recurso_nombre[b]) + 10)
				}
				if draw_menu(500, pos, recurso_nombre[subministerio], 8){
					draw_set_color(c_ltgray)
					draw_rectangle(510, pos, 510 + width, pos + last_height * 20, false)
					draw_set_color(c_black)
					draw_rectangle(510, pos, 510 + width, pos + last_height * 20, true)
					for(var a = 0; a < 20; a++){
						b = recurso_current[a + show_scroll]
						if draw_boton(515, pos, recurso_nombre[b]){
							subministerio = b
							show[8] = false
						}
					}
				}
				else{
					draw_text_pos(500, pos, $"precio ${recurso_precio[subministerio]}")
					pos += 20
					if draw_boton(510, pos, $"Exportar: {recurso_exportado[subministerio] ? "Sí" : "No"}")
						recurso_exportado[subministerio] = not recurso_exportado[subministerio]
					wpos = 510
					draw_text_pos(wpos, pos, $"Importación puntual: ", false)
					if recurso_importado[subministerio] > 0
						if draw_boton(wpos, pos, " - ",,,,,, false)
							recurso_importado[subministerio] -= 100
					if draw_boton(wpos, pos, " + ",,,,,, false)
						recurso_importado[subministerio] += 100
					draw_text_pos(wpos, pos, recurso_importado[subministerio])
					wpos = 510
					draw_text_pos(wpos, pos, $"Importación anual: ", false)
					if recurso_importado_fijo[subministerio] > 0
						if draw_boton(wpos, pos, " - ",,,,,, false)
							recurso_importado_fijo[subministerio] -= 100
					if draw_boton(wpos, pos, " + ",,,,,, false)
						recurso_importado_fijo[subministerio] += 100
					draw_text_pos(wpos, pos, recurso_importado_fijo[subministerio])
					//Banda de precios
					if array_contains(recurso_comida, subministerio) or array_contains(recurso_lujo, subministerio){
						pos += 10
						if draw_boton(510, pos, $"Banda de precio: {recurso_banda[subministerio] ? "Sí" : "No"}"){
							recurso_banda[subministerio] = not recurso_banda[subministerio]
							recurso_banda_min[subministerio] = recurso_precio[subministerio] * 0.9
							recurso_banda_max[subministerio] = recurso_precio[subministerio] * 1.1
						}
						if recurso_banda[subministerio]{
							wpos = 520
							draw_text_pos(wpos, pos, $"Precio mínimo: {recurso_banda_min[subministerio]}", false)
							if draw_boton(wpos, pos, " - ",,,,,, false)
								recurso_banda_min[subministerio] *= 0.9
							if draw_boton(wpos, pos, " + "){
								recurso_banda_min[subministerio] /= 0.9
								recurso_banda_max[subministerio] = max(recurso_banda_min[subministerio], recurso_banda_max[subministerio])
							}
							wpos = 520
							draw_text_pos(wpos, pos, $"Precio máximo: {recurso_banda_max[subministerio]}", false)
							if draw_boton(wpos, pos, " - ",,,,,, false){
								recurso_banda_max[subministerio] *= 0.9
								recurso_banda_min[subministerio] = min(recurso_banda_min[subministerio], recurso_banda_max[subministerio])
							}
							if draw_boton(wpos, pos, " + ")
								recurso_banda_max[subministerio] /= 0.9
						}
					}
					pos += 10
					draw_text_pos(510, pos, "Producido en:")
					var flag = false
					var temp_text = ""
					for(var a = 0; a < array_length(edificio_categoria[5]); a++){
						b = edificio_categoria[5, a]
						for(c = 0; c < array_length(edificio_industria_output_id[b]); c++)
							if edificio_industria_output_id[b, c] = subministerio{
								flag = true
								if draw_boton(530, pos, edificio_nombre[b]){
									ministerio = -1
									subministerio = 5
								}
								break
							}
					}
					if array_contains(recurso_cultivo, subministerio)
						temp_text += $"{edificio_nombre[4]}\n"
					if array_contains(recurso_mineral, subministerio)
						temp_text += $"{edificio_nombre[15]}\n"
					if array_contains(recurso_ganado, subministerio)
						temp_text += $"{edificio_nombre[27]}\n"
					if subministerio = 1
						temp_text += $"{edificio_nombre[5]}\n"
					if subministerio = 8
						temp_text += $"{edificio_nombre[14]}\n"
					if subministerio = 26
						temp_text += $"{edificio_nombre[38]}\n"
					if subministerio = 27
						temp_text += $"{edificio_nombre[40]}\n"
					if temp_text = "" and not flag
						temp_text = "Solo importado"
					draw_text_pos(530, pos, temp_text)
					pos += 10
					draw_text_pos(510, pos, "Usado en:")
					temp_text = ""
					for(var a = 0; a < array_length(edificio_categoria[5]); a++){
						b = edificio_categoria[5, a]
						for(c = 0; c < array_length(edificio_industria_input_id[b]); c++)
							if edificio_industria_input_id[b, c] = subministerio{
								temp_text += $"{edificio_nombre[b]}\n"
								break
							}
					}
					if array_contains(recurso_comida, subministerio)
						temp_text += "Comida\n"
					if array_contains(recurso_lujo, subministerio)
						temp_text += "Bien de lujo\n"
					if array_contains(recurso_usado_construccion, subministerio)
						temp_text += "Construcción\n"
					if array_contains(recurso_usado_mejoras, subministerio)
						temp_text += "Mejoras\n"
					if temp_text = ""
						temp_text = "Solo exportado"
					draw_text_pos(530, pos, temp_text)
				}
				#region gráfico
					draw_line(800, 150, 800, 350)
					draw_line(800, 350, 1040, 350)
					var mini = recurso_precio[subministerio], maxa = recurso_precio[subministerio]
					for(b = 0; b < 24; b++){
						mini = min(mini, recurso_historial[subministerio, b])
						maxa = max(maxa, recurso_historial[subministerio, b])
					}
					draw_set_halign(fa_right)
					draw_text(800, 150, $"${maxa}")
					draw_text(800, 350, $"${mini}")
					draw_set_halign(fa_center)
					draw_text(920, 350, $"{recurso_nombre[subministerio]}")
					draw_set_halign(fa_left)
					maxa = maxa - mini
					draw_text(1040, 350 - 200 * (recurso_historial[subministerio, 23] - mini) / maxa, $"${recurso_precio[subministerio]}")
					for(b = 0; b < 23; b++)
						draw_line(800 + b * 10, 350 - 200 * (recurso_historial[subministerio, b] - mini) / maxa, 800 + (b + 1) * 10, 350 - 200 * (recurso_historial[subministerio, b + 1] - mini) / maxa)
				#endregion
			}
		}
		//Ministerio de Exterior
		else if ministerio = 6{
			draw_text_pos(100, pos, "Relaciones Exteriores")
			for(var a = 1; a < array_length(pais_current); a++){
				var pais = pais_current[a]
				d = 0
				var f = 0
				for(b = 0; b < array_length(recurso_nombre); b++){
					for(c = 0; c < array_length(recurso_tratados_venta[b]); c++)
						d += (recurso_tratados_venta[b, c].pais = pais)
					for(c = 0; c < array_length(recurso_tratados_compra[b]); c++)
						f += (recurso_tratados_compra[b, c].pais = pais)
				}
				if draw_menu(110, pos, $"{pais.nombre}: {pais.relacion} {d + f > 0 ? "(" + string(d + f) + ")" : ""}", a){
					if d + f > 0{
						draw_text_pos(120, pos, $"{d + f} tratado{d + f = 1 ? "" : "s"} comercial{d + f = 1 ? "" : "es"} activo{d + f = 1 ? "" : "s"}")
						for(b = 0; b < array_length(recurso_nombre); b++){
							for(c = 0; c < array_length(recurso_tratados_venta[b]); c++){
								var tratado = recurso_tratados_venta[b, c]
								if tratado.pais = pais
									if draw_boton(130, pos, $"Vender {tratado.cantidad} de {recurso_nombre[tratado.recurso]}, {tratado.tiempo} meses restantes.  (+{floor(tratado.factor * 100) - 100}%)",,,,,,, true) and mouse_lastbutton = mb_right{
										add_noticia("Tratado cancelado", $"Has cancelado el tratado de exportar {tratado.cantidad} de {recurso_nombre[tratado.recurso]} a {tratado.pais.nombre}")
										tratado.pais.relacion--
										array_remove(recurso_tratados_venta[tratado.recurso], tratado, 1)
										credibilidad_financiera = clamp(credibilidad_financiera - 1, 1, 10)
										tratados_num--
									}
							}
							for(c = 0; c < array_length(recurso_tratados_compra[b]); c++){
								var tratado = recurso_tratados_compra[b, c]
								if tratado.pais = pais
									if draw_boton(130, pos, $"Comprar {tratado.cantidad} de {recurso_nombre[tratado.recurso]}, {tratado.tiempo} meses restantes.  (-{floor(tratado.factor * 100) - 100}%)",,,,,,, true) and mouse_lastbutton = mb_right{
										add_noticia("Tratado cancelado", $"Has cancelado el tratado de importar {tratado.cantidad} de {recurso_nombre[tratado.recurso]} a {tratado.pais.nombre}")
										tratado.pais.relacion--
										array_remove(recurso_tratados_compra[tratado.recurso], tratado, 1)
										credibilidad_financiera = clamp(credibilidad_financiera - 1, 1, 10)
										tratados_num--
									}
							}
						}
					}
					if array_length(pais.guerras) > 0{
						var temp_array = [], temp_array_2 = [], flag = false, flag_2 = false
						for(b = 0; b < array_length(paises); b++){
							array_push(temp_array, false)
							array_push(temp_array_2, false)
						}
						for(b = 0; b < array_length(pais.guerras); b++){
							var guerra = pais.guerras[b]
							if array_contains(guerra.bando_a, pais){
								for(c = 0; c < array_length(guerra.bando_a); c++)
									if guerra.bando_a[c] != pais{
										temp_array_2[guerra.bando_a[c]] = true
										flag_2 = true
									}
								for(c = 0; c < array_length(guerra.bando_b); c++){
									temp_array[guerra.bando_b[c]] = true
									flag = true
								}
							}
							else{
								for(c = 0; c < array_length(guerra.bando_a); c++){
									temp_array[guerra.bando_a[c]] = true
									flag = true
								}
								for(c = 0; c < array_length(guerra.bando_b); c++)
									if guerra.bando_b[c] != pais{
										temp_array_2[guerra.bando_b[c]] = true
										flag_2 = true
									}
							}
						}
						if flag{
							draw_text_pos(120, pos, "En guerra con:")
							for(b = 0; b < array_length(paises); b++)
								if temp_array[b]
									draw_text_pos(130, pos, paises[b].nombre)
						}
						else
							draw_text_pos(120, pos, "Solo guerras internas")
						if flag_2{
							draw_text_pos(120, pos, "Aliado con:")
							for(b = 0; b < array_length(paises); b++)
								if temp_array_2[b]
									draw_text_pos(130, pos, paises[b].nombre)
						}
					}
					else
						draw_text_pos(120, pos, "Sin guerras")
				}
			}
			//Ofertas disponibles
			pos = 120
			draw_text_pos(580, pos, "Ofertas disponibles")
			draw_text_pos(590, pos, $"{tratados_num} aceptado{tratados_num = 1 ? "" : "s"} de {tratados_max}")
			for(var a = 0; a < array_length(tratados_ofertas); a++){
				var tratado = tratados_ofertas[a]
				if draw_boton_color(600, pos, $"{tratado.cantidad > 0 ? "#FF0000Vender" : "#0000FFComprar"}#000000 {abs(tratado.cantidad)} de #0000FF{recurso_nombre[tratado.recurso]}#000000 a #FF0000{tratado.pais.nombre}#000000 ({tratado.tipo ? "+" : "-"}{floor(100 * (tratado.factor - 1))}%)") and tratados_num < tratados_max{
					aceptar_tratado(tratado.recurso, tratado.cantidad, tratado.factor, tratado.tiempo, tratado.pais)
					array_delete(tratados_ofertas, a, 1)
				}
			}
		}
		//Propiedad privada
		else if ministerio = 7{
			draw_text_pos(110, pos, $"Credibilidad financiera: {credibilidad_financiera}")
			if draw_boton(110, pos, $"Impuesto por edificio ${impuesto_empresa}")
				impuesto_empresa = (impuesto_empresa + 5) mod 30
			if draw_boton(110, pos, $"Impuesto por patente ${impuesto_empresa_fijo}")
				impuesto_empresa_fijo = (impuesto_empresa_fijo + 5) mod 30
			if draw_boton(110, pos, $"Impuesto laboral {floor(100 * impuesto_trabajador)}%")
				impuesto_trabajador = ((20 * impuesto_trabajador + 1) mod 6) / 20
			if draw_boton(110, pos, $"Impuesto minero {round(100 * impuesto_minero)}%")
				impuesto_minero = ((10 * impuesto_minero + 1) mod 6) / 10
			if draw_boton(110, pos, $"Impuesto forestal {round(100 * impuesto_maderero)}%")
				impuesto_maderero = ((10 * impuesto_maderero + 1) mod 6) / 10
			if draw_boton(110, pos, $"Impuesto pesquero {round(100 * impuesto_pesquero)}%")
				impuesto_pesquero = ((20 * impuesto_pesquero + 1) mod 7) / 20
			if (dia / 360) >= 60 and draw_boton(110, pos, $"Impuesto petrolífero {round(100 * impuesto_petrolifero)}%")
				impuesto_petrolifero = ((10 * impuesto_petrolifero + 1) mod 6) / 10
			if draw_boton(110, pos, $"Valor terreno ${valor_terreno}")
				valor_terreno = max(10, (valor_terreno + 5) mod 30)
			pos += 20
			if array_length(edificios_a_la_venta) > 0 and draw_menu(110, pos, $"{array_length(edificios_a_la_venta)} edificio{array_length(edificios_a_la_venta) = 1 ? "" : "s"} a la venta", 0)
				for(var a = 0; a < array_length(edificios_a_la_venta); a++){
					var edificio = edificios_a_la_venta[a].edificio
					if draw_boton(120, pos, edificio.nombre)
						select(edificio)
				}
			if array_length(terrenos_venta) > 0 and draw_menu(110, pos, $"{array_length(terrenos_venta)} terreno{array_length(terrenos_venta) = 1 ? "" : "s"} a la venta", 2)
				for(var a = 0; a < array_length(terrenos_venta); a++){
					var terreno_venta = terrenos_venta[a]
					if draw_boton(120, pos, $"{terreno_venta.width}x{terreno_venta.height} terrenos en {terreno_venta.x}, {terreno_venta.y}")
						select(,,,, terreno_venta)
				}
			if draw_menu(110, pos, $"{array_length(empresas)} empresa{array_length(empresas) = 1 ? "" : "s"} en la isla", 1){
				for(var a = 0; a < array_length(empresas); a++){
					var empresa = empresas[a]
					if draw_menu(120, pos, $"{empresa.nombre}{empresa.nacional ? " (nacional)" : ""}{array_length(empresa.terreno) > 0 ? "(" + string(array_length(empresa.terreno)) + " terrenos)" : ""}{array_length(empresa.edificios) > 0 ? "(" + string(array_length(empresa.edificios)) + " edificios)" : ""}", a + 2){
						draw_text_pos(140, pos, $"Dinero: ${floor(empresa.dinero)}")
						if empresa.nacional and draw_boton(140, pos, $"Dueño: {name(empresa.jefe)}")
							select(,, empresa.jefe)
						if array_length(empresa.terreno) > 0
							draw_text_pos(140, pos, $"Dueños de {array_length(empresa.terreno)} terreno{array_length(empresa.terreno) = 1 ? "" : "s"}")
						if array_length(empresa.edificios) > 0{
							draw_text_pos(140, pos, $"Dueña de {array_length(empresa.edificios)} edificio{array_length(empresa.edificios) = 1 ? "" : "s"}")
							for(b = 0; b < array_length(empresa.edificios); b++)
								if draw_boton(160, pos, empresa.edificios[b].nombre)
									select(empresa.edificios[b])
						}
					}
				}
			}
		}
		//Leyes
		else if ministerio = 8{
			for(var a = 0; a < array_length(ley_nombre); a++)
				if (dia / 360) > ley_anno[a] and (ley_eneabled[1] or a != 23) and draw_boton(110, pos, $"{ley_eneabled[a] ? "Prohibir" : "Permitir"} {ley_nombre[a]}",,,
				function(a){
					draw_set_valign(fa_bottom)
					draw_text(100, room_height - 100, $"{ley_eneabled[a] ? "Prohibir" : "Permitir"} {ley_nombre[a]}    {ley_economia[a] = 3 ? "" : politica_economia_nombre[ley_economia[a]] + "    "}{ley_sociocultural[a] = 3 ? "" : politica_sociocultural_nombre[ley_sociocultural[a]]}\n{ley_descripcion[a]} (${ley_precio[a]}){ley_tiempo[a] = 0 ? "" : "\nDebes esperar " + string(ley_tiempo[a]) + " meses para cambiar esta ley de nuevo"}")
					draw_set_valign(fa_top)
				}, a) and ley_tiempo[a] = 0 and dinero >= ley_precio[a]{
					dinero -= ley_precio[a]
					mes_salida_micelaneo[current_mes] += ley_precio[a]
					if not debug
						ley_tiempo[a] = 12
					ley_eneabled[a] = not ley_eneabled[a]
					if in(a, 0, 15, 16, 21)
						politica_religion = 5 * ley_eneabled[0] + 5 * ley_eneabled[15] + 10 * ley_eneabled[16] + 10 * ley_eneabled[21]
					//Prohibir trabajo infantil
					if a = 2 and not ley_eneabled[a]
						for(b = 0; b < array_length(familias); b++)
							for(c = 0; c < array_length(familias[b].hijos); c++)
								if familias[b].hijos[c].edad > 12
									cambiar_trabajo(familias[b].hijos[c], null_edificio)
					//Crear jubilaciones
					if a = 3 and ley_eneabled[a]
						for(b = 0; b < array_length(personas); b++)
							if personas[a].edad > 65
								cambiar_trabajo(personas[a], jubilado)
					//Prohibir jubilaciones
					if a = 3 and not ley_eneabled[a]
						for(b = 0; b < array_length(personas); b++)
							if personas[a].edad > 65
								cambiar_trabajo(personas[a], null_edificio)
					//Aprobar trabajo temporal
					if a = 6 and ley_eneabled[a] and array_length(cola_construccion) = 0
						for(b = 0; b < array_length(edificio_count[20]); b++){
							var edificio = edificio_count[20, b]
							set_paro(true, edificio)
							while array_length(edificio.trabajadores) > 0
								cambiar_trabajo(edificio.trabajadores[0], null_edificio)
						}
					//Prohibir trabajo temporal
					if a = 6 and not ley_eneabled[a] and array_length(cola_construccion) = 0
						for(b = 0; b < array_length(edificio_count[20]); b++)
							set_paro(false, edificio_count[20, b])
					//Armas para la policía
					if a = 11 and ley_eneabled[a]
						recurso_construccion[28] += 10 * array_length(edificio_count[34])
					//Prostitución
					if a = 15{
						if ley_eneabled[a]
							prostituta.trabajo_riesgo = 0.01
						else
							prostituta.trabajo_riesgo = 0.05
					}
					//Estado laico
					if a = 16
						if ley_eneabled[a]{
							var temp_text = ""
							c = 0
							b = array_length(edificio_count[17])
							c += b
							if b > 0{
								d = array_length(edificio_count[7])
								temp_text += $"{b = 1 ? "" : $"{b} "}hospicio{b = 1 ? "" : "s"} ({d = 0 ? "No tienes consultorios" : $"tienes {d} consultorio{d = 1 ? "" : "s"}"}) "
							}
							b = array_length(edificio_count[18])
							c += b
							if b > 0{
								d = array_length(edificio_count[6])
								temp_text += $"{temp_text != "" ? "," : ""}{b = 1 ? "" : $"{b} "}escuela{b = 1 ? "" : "s"} parroquial{b = 1 ? "" : "es"} ({d = 0 ? "No tienes escuelas" : $"tienes {d} escuela{d = 1 ? "" : "s"}"}) "
							}
							b = array_length(edificio_count[19])
							c += b
							if b > 0
								temp_text += $"{temp_text != "" ? "y " : ""}{b = 1 ? "" : $"{b} "}albergue{b = 1 ? "" : "s"} "
							if temp_text != "" and not show_question($"Aprobar esta ley hará que tu{c = 1 ? "" : "s"} {temp_text}pase{c = 1 ? "" : "n"} a ser capilla{c = 1 ? "" : "s"}, deteniendo sus otras funciones.\n\n¿Continuar?"){
								ley_eneabled[a] = false
								dinero += ley_precio[a]
								mes_salida_micelaneo[current_mes] -= ley_precio[a]
								ley_tiempo[a] = 0
								politica_religion = 5 * ley_eneabled[0] + 5 * ley_eneabled[15] + 10 * ley_eneabled[16]
							}
							else{
								array_remove(edificio_categoria[0], 18, "Sacar los albergues de las residencias disponibles")
								while array_length(edificio_count[17]) > 0
									edificio_replace(16, edificio_count[17, 0])
								while array_length(edificio_count[18]) > 0
									edificio_replace(16, edificio_count[18, 0])
								while array_length(edificio_count[19]) > 0
									edificio_replace(16, edificio_count[19, 0])
							}
						}
					else
						array_push(edificio_categoria[0], 18)
					//Ley seca
					if a = 17
						if ley_eneabled[a]{
							prohibir_recurso(22, [11, 35])
							array_remove(edificio_categoria[3], 11)
							for(b = 0; b < array_length(edificio_count[11]); b++){
								var edificio = edificio_count[11, b]
								set_paro(true, edificio)
								while array_length(edificio.trabajadores) > 0
									cambiar_trabajo(edificio.trabajadores[0], null_edificio)
							}
						}
						else{
							array_push(recurso_lujo, 22)
							array_push(recurso_lujo_probabilidad, 1)
							array_push(edificio_categoria[3], 11)
							for(b = 0; b < array_length(edificio_count[11]); b++)
								set_paro(false, edificio_count[11, b])
						}
					//Ley anti-drogas
					if a = 18
						if ley_eneabled[a]
							prohibir_recurso(7)
						else{
							array_push(recurso_lujo, 7)
							array_push(recurso_lujo_probabilidad, 1)
						}
					//Ley anti-cigarros
					if a = 19
						if ley_eneabled[a]
							prohibir_recurso(4)
						else{
							array_push(recurso_lujo, 4)
							array_push(recurso_lujo_probabilidad, 1)
						}
					//Ley control de armas
					if a = 20
						if ley_eneabled[a]
							prohibir_recurso(28)
						else{
							array_push(recurso_lujo, 29)
							array_push(recurso_lujo_probabilidad, 0.1)
						}
					//Prohibir libertad de prensa
					if a = 22 and not ley_eneabled[a]{
						for(c = 0; c < array_length(medios_comunicacion); c++){
							d = medios_comunicacion[c]
							edificio_estatal[d] = true
							for(b = 0; b < array_length(edificio_count[d]); b++){
								var edificio = edificio_count[d, b]
								if edificio.privado{
									array_remove(edificio.empresa.edificios, edificio)
									edificio.empresa = null_empresa
									edificio.privado = false
								}
							}
						}
					}
					//Permitir libertad de prensa
					if a = 22 and ley_eneabled[a]{
						for(c = 0; c < array_length(medios_comunicacion); c++)
							edificio_estatal[medios_comunicacion[c]] = false
					}
					//Permitir condiciones laborales dignas
					if a = 25{
						if ley_eneabled[a]{
							for(c = 0; c < array_length(edificios); c++)
								edificios[c].trabajo_calidad += 10
						}
						else
							for(c = 0; c < array_length(edificios); c++)
								edificios[c].trabajo_calidad -= 10
					}
				}
			if draw_boton(110, pos, $"Sueldo mínimo: ${sueldo_minimo}"){
				credibilidad_financiera += floor(sueldo_minimo / 2)
				sueldo_minimo = ++sueldo_minimo mod 6
				credibilidad_financiera = clamp(credibilidad_financiera - floor(sueldo_minimo / 2), 1, 10)
				for(var a = 0; a < array_length(edificios); a++)
					edificios[a].trabajo_sueldo = max(sueldo_minimo, edificio_trabajo_sueldo[edificios[a].tipo] + edificios[a].presupuesto - 2)
			}
			if ley_eneabled[3] and draw_boton(110, pos, $"Pensión ${jubilado.trabajo_sueldo}"){
				jubilado.trabajo_sueldo = clamp((++jubilado.trabajo_sueldo mod 6), 1, 5)
				jubilado.trabajo_calidad = 11 + sqr(jubilado.trabajo_sueldo)
			}
			#region Mapa político
				b = 0
				c = 0
				d = array_length(ley_nombre)
				var tempx = 600, tempy = 150
				draw_text(tempx, tempy - 20, "Mapa político")
				for(var a = 0; a < d; a++)
					if ley_eneabled[a]{
						b += ley_economia[a]
						c += ley_sociocultural[a]
					}
					else{
						b += 6 - ley_economia[a]
						c += 6 - ley_sociocultural[a]
					}
				b += 3 - sueldo_minimo - jubilado.trabajo_sueldo
				politica_economia = b / d
				politica_sociocultural = c / d
				if politica_economia < 3
					politica_economia = 3 - 4 * (3 - politica_economia) / (3 - izquierda_extrema)
				else
					politica_economia = 3 + 4 * ((politica_economia - 3) / (derecha_extrema - 3))
				if politica_sociocultural < 3
					politica_sociocultural = 3 - 4 * (3 - politica_sociocultural) / (3 - libertario_extremo)
				else
					politica_sociocultural = 3 + 4 * ((politica_sociocultural - 3) / (autoritario_extremo - 3))
				politica_economia = clamp(politica_economia, 0, 6)
				politica_sociocultural = clamp(politica_sociocultural, 0, 6)
				draw_set_alpha(0.5)
				draw_set_color(c_red)
				draw_rectangle(tempx, tempy, tempx + 150, tempy + 150, false)
				draw_set_color(c_green)
				draw_rectangle(tempx, tempy + 300, tempx + 150, tempy + 150, false)
				draw_set_color(c_blue)
				draw_rectangle(tempx + 300, tempy, tempx + 150, tempy + 150, false)
				draw_set_color(c_yellow)
				draw_rectangle(tempx + 300, tempy + 300, tempx + 150, tempy + 150, false)
				draw_set_color(c_black)
				draw_set_font(font_small)
				draw_set_alpha(1)
				draw_line(tempx, tempy + 150, tempx + 300, tempy + 150)
				draw_line(tempx + 150, tempy, tempx + 150, tempy + 300)
				draw_text(tempx, tempy, "Izquierda autoritaria")
				draw_set_valign(fa_bottom)
				draw_text(tempx, tempy + 300, "Izquierda liberal")
				draw_set_halign(fa_right)
				draw_text(tempx + 300, tempy + 300, "Derecha liberal")
				draw_set_valign(fa_top)
				draw_text(tempx + 300, tempy, "Derecha autoritaria")
				draw_set_halign(fa_left)
				draw_set_font(font_normal)
				draw_set_valign(fa_top)
				pos = tempy + 300
				if draw_menu(tempx, pos, "Mostrar votantes", 0){
					draw_set_alpha(0.5)
					draw_set_color(c_black)
					for(var a = 0; a < array_length(personas); a++){
						var persona = personas[a]
						if not persona.candidato{
							b = tempx + 50 * persona.politica_economia
							c = tempy + 300 - 50 * persona.politica_sociocultural
							if not persona.es_hijo
								draw_circle(b, c, 4, false)
							else
								draw_triangle(b, c - 4, b - 3, c + 1, b + 3, c + 1, false)
						}
					}
					draw_set_alpha(1)
				}
				if elecciones and draw_menu(tempx, pos, $"Mostrar candidato{array_length(candidatos) = 1 ? "" : "s"}", 1){
					for(var a = 0; a < array_length(candidatos); a++){
						var persona = candidatos[a]
						draw_set_color(make_color_hsv(a * 255 / array_length(candidatos), 127, 255))
						draw_circle(tempx + 50 * persona.politica_economia, tempy + 300 - 50 * persona.politica_sociocultural, 8, false)
						draw_circle(tempx + 30, pos + last_height / 2, 6, false)
						draw_set_color(c_black)
						if draw_boton(tempx + 40, pos, $"{name(persona)} (~{floor(100 * candidatos_votos[a + 1] / candidatos_votos_total)}%)")
							select(,, persona)
					}
				}
				draw_set_color(c_white)
				draw_circle(tempx + 50 * politica_economia, tempy + 300 - 50 * politica_sociocultural, 10, false)
				if ley_eneabled[24] and (dia / 365) >= 110{
					b = tempx + 50 * politica_economia
					c = tempy + 300 - 50 * politica_sociocultural
					for(var a = 0; a < 2 * pi; a += pi / 32)
						if b + 200 * cos(a) > tempx and c + 200 * sin(a) > tempy and b + 200 * cos(a) < tempx + 300 and c + 200 * sin(a) < tempy + 300{
							d = a + pi / 32
							draw_line(b + 200 * cos(a), c + 200 * sin(a), b + 200 * cos(d), c + 200 * sin(d))
						}
				}
				draw_set_color(c_black)
			#endregion
		}
	}
	if mouse_check_button_pressed(mb_right){
		mouse_clear(mb_right)
		sel_build = false
	}
}
//Colocar edificio
if build_sel{
	var width = edificio_width[build_index], height = edificio_height[build_index], temp_altura = 0, temp_precio = edificio_precio[build_index], temp_tiempo = edificio_construccion_tiempo[build_index], var_edificio_nombre = edificio_nombre[build_index]
	text = ""
	var mx = clamp(floor(((mouse_x + xpos) / tile_width + (mouse_y + ypos) / tile_height) / 2), 0, xsize - width)
	var my = clamp(floor(((mouse_y + ypos) / tile_height - (mouse_x + xpos) / tile_width) / 2), 0, ysize - height)
	if keyboard_check_pressed(ord("R"))
		rotado = not rotado
	if rotado{
		var a = width
		width = height
		height = a
	}
	draw_set_color(make_color_hsv(edificio_color[build_index], 255, 255))
	draw_set_alpha(0.5)
	if not edificio_resize[build_index]
		draw_rombo_coord(mx, my, width, height, false)
	var flag = true
	//Edificios de tamaño editable
	if edificio_resize[build_index]{
		var edi_width = width, edi_height = height
		if mouse_check_button_pressed(mb_left){
			build_x = mx
			build_y = my
		}
		if build_pressed{
			if mx >= build_x{
				width = clamp(mx - build_x, width, 10)
				mx = build_x
			}
			else{
				mx = max(mx, build_x - 10 + edi_width)
				width = clamp(build_x - mx + edi_width, width, 10)
			}
			if my >= build_y{
				height = clamp(my - build_y, height, 10)
				my = build_y
			}
			else{
				my = max(my, build_y - 10 + edi_height)
				height = clamp(build_y - my + edi_height, height, 10)
			}
		}
		draw_rombo_coord(mx, my, width, height, false)
		if build_pressed and edificio_resize_no_productiva[build_index]{
			draw_set_color(c_red)
			draw_rombo_coord(max(build_x, mx - edi_width), max(build_y, my - edi_height), edi_width, edi_height, false)
		}
		draw_set_color(c_white)
		draw_set_alpha(1)
		if var_edificio_nombre = "Granja"{
			c = 0
			for(var a = mx; a < mx + width; a++)
				for(var b = my; b < my + height; b++)
					if (mx >= build_x ? (a >= mx + edi_width) : (a <= mx + width - edi_width)) or (my >= build_y ? (b >= my + edi_height) : (b <= my + height - edi_height))
						c += cultivo[build_type][# a, b]
			if c = 0{
				flag = false
				text += "Arrastra para agrandar la granja\n"
			}
			else{
				text += $"{width * height - 9} terreno cultibable\nEficiencia: {floor(c * 100 / (width * height - 9))}%\n"
				temp_tiempo += 5 * (width * height - 9)
			}
			if not keyboard_check(vk_lcontrol){
				if mouse_wheel_up(){
					do build_type = (build_type + 1) mod array_length(recurso_cultivo)
					until recurso_anno[recurso_cultivo[build_type]] <= dia / 360
				}
				if mouse_wheel_down(){
					do build_type = (build_type + array_length(recurso_cultivo) - 1) mod array_length(recurso_cultivo)
					until recurso_anno[recurso_cultivo[build_type]] <= dia / 360
				}
			}
		}
		else if var_edificio_nombre = "Rancho"{
			for(var a = 0; a < array_length(ganado_nombre); a++)
				show_string += $"{(build_type = a ? ">" : "")} {ganado_nombre[a]}\n"
			c = 0
			for(var a = mx; a < mx + width; a++)
				for(var b = my; b < my + height; b++)
					if (mx >= build_x ? (a >= mx + edi_width) : (a <= mx + width - edi_width)) or (my >= build_y ? (b >= my + edi_height) : (b <= my + height - edi_height))
						c += altura[# a, b] > 0.6
			if width = 4 and height = 4{
				flag = false
				text += "Arrastra para agrandar el rancho\n"
			}
			else{
				if c = 0{
					flag = false
					text += "Requiere terreno con pasto\n"
				}
				else{
					text += $"{c} terreno utilizable\n{5 + floor((width * height - 16) / 16)} trabajadores\nEficiencia: {100 + floor(c * 0.9)}%\n"
					temp_tiempo += 5 * (width * height - 9)
				}
			}
			if not keyboard_check(vk_lcontrol){
				if mouse_wheel_up()
					build_type = (build_type + 1) mod array_length(ganado_nombre)
				if mouse_wheel_down()
					build_type = (build_type + array_length(ganado_nombre) - 1) mod array_length(ganado_nombre)
			}
		}
	}
	draw_set_alpha(1)
	draw_set_color(c_white)
	//Minas
	if var_edificio_nombre = "Mina"{
		draw_rombo_coord(mx - 1, my - 1, width + 2, height + 2, true)
		flag = false
		c = 0
		d = min(xsize - 1, mx + width + 1)
		e = min(ysize - 1, my + height + 1)
		var f = max(0, my - 1)
		for(var a = max(0, mx - 1); a < d; a++)
			for(var b = f; b < e; b++)
				if mineral[build_type][a, b]{
					flag = true
					c += mineral_cantidad[build_type][a, b]
				}
		if not keyboard_check(vk_lcontrol){
			if mouse_wheel_up(){
				do build_type = (build_type + 1) mod array_length(recurso_mineral)
				until recurso_anno[recurso_mineral[build_type]] <= dia / 360
			}
			if mouse_wheel_down(){
				do build_type = (build_type + array_length(recurso_mineral) - 1) mod array_length(recurso_mineral)
				until recurso_anno[recurso_mineral[build_type]] <= dia / 360
			}
		}
		if flag
			text += $"Depósito: {c}\n"
		else
			text += $"Se necesita un depósito de {recurso_nombre[recurso_mineral[build_type]]}\n"
	}
	//Capilla
	else if in(build_index, 16, 17, 18, 19){
		if not ley_eneabled[16]
			for(var a = 0; a < 4; a++)
				show_string += $"{(build_index = 16 + a ? ">" : "")} {edificio_nombre[16 + a]}\n"
		if not keyboard_check(vk_lcontrol){
			if mouse_wheel_up()
				build_index++
			if mouse_wheel_down()
				build_index--
		}
		if ley_eneabled[16]
			build_index = 16
		else{
			if build_index > 19
				build_index = 16
			else if build_index < 16
				build_index = 19
		}
	}
	//Tejar
	else if var_edificio_nombre = "Tejar"{
		c = 0
		d = mx + width
		e = my + height
		for(var a = mx; a < d; a++)
			for(var b = my; b < e; b++)
				c += (altura[# a, b] > 0.6)
		c /= width * height
		text += $"Eficiencia: {floor(100 * c)}%\n"
	}
	//Pozo Petrolífero
	else if var_edificio_nombre = "Pozo Petrolífero"{
		c = 0
		d = mx + width
		e = my + height
		for(var a = mx; a < d; a++)
			for(var b = my; b < e; b++)
				c += petroleo[# a, b]
		if c = 0{
			flag = false
			text += "Se necesita petróleo cerca\n"
		}
		else
			text += $"Depósito: {c}\n"
	}
	draw_set_alpha(0.5)
	c = min(xsize - 1, mx + width + 5)
	d = min(ysize - 1, my + height + 5)
	e = max(0, my - 5)
	for(var a = max(0, mx - 5); a < c; a++)
		for(var b = e; b < d; b++)
			if zona_privada[# a, b] or bool_edificio[# a, b] or construccion_reservada[# a, b]{
				if zona_privada[# a, b]
					draw_set_color(c_blue)
				else if construccion_reservada[# a, b]
					draw_set_color(c_green)
				else if bool_edificio[# a, b]
					draw_set_color(c_red)
				draw_rombo_coord(a, b, 1, 1, false)
			}
	draw_set_color(c_white)
	draw_set_alpha(1)
	//Detectar terreno inválido
	if flag{
		flag = edificio_valid_place(mx, my, build_index,,, width, height)
		//Detectar árboles cerca
		if flag and var_edificio_nombre = "Aserradero"{
			draw_rombo_coord(mx - 5, my - 5, width + 10, height + 10, true)
			var flag_2 = false
			c = 0
			d = min(mx + width + 5, xsize)
			e = min(my + height + 5, ysize)
			var f = max(0, my - 5)
			for(var a = max(0, mx - 5); a < d; a++)
				for(var b = f; b < e; b++)
					if bosque[# a, b] and not bosque_venta[# a, b] and not (a >= mx and a < mx + width and b >= my and b < my + height){
						flag_2 = true
						c += bosque_madera[a, b]
					}
			if not flag_2{
				flag = false
				text += "Se necesitan árboles cerca\n"
			}
			else
				text += $"{c} madera disponible\n"
		}
	}
	if not flag
		text += "Construcción bloqueada\n"
	else{
		c = mx + width
		d = my + height
		if not edificio_plano[build_index]{
			var coste_aplanar = 0
			//Altura promedio
			for(var a = mx; a < c; a++)
				for(var b = my; b < d; b++)
					temp_altura += altura[# a, b]
			temp_altura /= width * height
			//Coste aplanar
			for(var a = mx; a < c; a++)
				for(var b = my; b < d; b++)
					coste_aplanar += 25 * sqrt(abs(altura[# a, b] - temp_altura))
			coste_aplanar = round(coste_aplanar)
			if coste_aplanar > 0{
				text += $"Coste aplanar: ${coste_aplanar}"
				temp_precio += coste_aplanar
			}
		}
		var coste_terreno = 0, coste_deforestar = 0, coste_escombros = 0
		for(var a = mx; a < c; a++)
			for(var b = my; b < d; b++){
				coste_terreno += valor_terreno * zona_privada[# a, b]
				coste_deforestar += 10 * bosque[# a, b]
				coste_escombros += 25 * escombros[# a, b]
			}
		if coste_terreno > 0{
			text += $"\nEstatizar terreno: ${coste_terreno}"
			temp_precio += coste_terreno
		}
		if coste_deforestar > 0{
			text += $"\nDeforestar terreno: ${coste_deforestar}"
			temp_precio += coste_deforestar
		}
		if coste_escombros > 0{
			text += $"\nRemover escombros: ${coste_escombros}"
			temp_precio += coste_escombros
		}
	}
	if text != ""
		draw_text((mx - my) * tile_width - xpos, (mx + my) * tile_height - ypos, text)
	//Construir
	if (mouse_check_button_pressed(mb_left) and not edificio_resize[build_index]) or (build_pressed and mouse_check_button_released(mb_left) and edificio_resize[build_index]){
		mouse_clear(mb_left)
		if flag{
			add_construccion(, mx, my, build_index, build_type, temp_tiempo, temp_altura, width, height, temp_precio,,, build_x, build_y)
			build_sel = keyboard_check(vk_lshift)
			dinero -= temp_precio
			mes_construccion[current_mes] += temp_precio
			if tutorial_bool and tutorial = 8
				tutorial_complete = true
			if ley_eneabled[11] and var_edificio_nombre = "Comisaría"
				recurso_construccion[28] += 10
		}
	}
	if mouse_check_button_pressed(mb_left)
		build_pressed = true
	if mouse_check_button_pressed(mb_right){
		mouse_clear(mb_right)
		build_sel = false
	}
}
//Privatizar terreno
if build_terreno{
	var mx = clamp(floor(((mouse_x + xpos) / tile_width + (mouse_y + ypos) / tile_height) / 2), 0, xsize - 1)
	var my = clamp(floor(((mouse_y + ypos) / tile_height - (mouse_x + xpos) / tile_width) / 2), 0, ysize - 1)
	draw_set_color(c_black)
	draw_set_alpha(0.3)
	draw_rectangle(0, 0, room_width, room_height, false)
	draw_set_alpha(1)
	draw_set_color(c_white)
	show_string += "Arrastra para privatizar\n"
	if mouse_check_button_pressed(mb_left){
		build_x = mx
		build_y = my
	}
	draw_set_alpha(0.5)
	draw_set_color(c_red)
	c = mx + 3
	d = my - 3
	e = my + 3
	for(var a = mx - 3; a <= c; a++)
		for(var b = d; b <= e; b++)
			if zona_privada[# a, b] or zona_privada_venta[# a, b]
				draw_rombo_coord(a, b, 1, 1, false)
	draw_set_alpha(1)
	if build_pressed{
		var width = clamp(abs(build_x - mx), 1, 10), height = clamp(abs(build_y - my), 1, 10), minx = max(min(build_x, mx + 1), build_x - width), miny = max(min(build_y, my + 1), build_y - height), flag = true
		draw_set_color(c_blue)
		draw_set_alpha(0.5)
		draw_rombo_coord(minx, miny, width, height, false)
		c = minx + width
		d = miny + height
		for(var a = minx; a < c; a++){
			for(var b = miny; b < d; b++)
				if (bool_edificio[# a, b] and edificio_nombre[id_edificio[# a, b].tipo] != "Toma") or mar[a, b] or construccion_reservada[# a, b] or zona_privada[# a, b] or zona_privada_venta[# a, b]{
					flag = false
					break
				}
			if not flag
				break
		}
		draw_set_color(c_white)
		draw_set_alpha(1)
		draw_text((mx - my) * tile_width - xpos, (mx + my) * tile_height - ypos, flag ? $"{width * height} terreno{width * height = 1 ? "" : "s"}" : "No puedes privatizar este terreno")
		if flag and mouse_check_button_released(mb_left){
			var terreno_venta = {
				x : minx,
				y : miny,
				width : width,
				height : height,
				privado : false,
				empresa : null_empresa
			}
			if keyboard_check(vk_lshift)
				build_pressed = false
			else{
				build_terreno = false
				select(,,,, terreno_venta)
			}
			array_push(terrenos_venta, terreno_venta)
			c = minx + width - 1
			d = miny + height - 1
			var temp_array = []
			array_copy(temp_array, 0, build_terreno_permisos, 0, array_length(build_terreno_permisos))
			ds_grid_set_region(zona_privada, minx, miny, c, d, true)
			ds_grid_set_region(zona_privada_venta, minx, miny, c, d, true)
			ds_grid_set_region(zona_privada_permisos, minx, miny, c, d, temp_array)
			ds_grid_set_region(zona_privada_venta_terreno, minx, miny, c, d, terreno_venta)
		}
	}
	if mouse_check_button_pressed(mb_left)
		build_pressed = true
	if mouse_check_button_pressed(mb_right){
		mouse_clear(mb_right)
		build_terreno = false
	}
}
//Construir calles
if build_calle{
	var mx = clamp(floor(((mouse_x + xpos) / tile_width + (mouse_y + ypos) / tile_height) / 2), 0, xsize - 1)
	var my = clamp(floor(((mouse_y + ypos) / tile_height - (mouse_x + xpos) / tile_width) / 2), 0, ysize - 1)
	draw_rombo_coord(mx, my, 1, 1, true)
	show_string += "Arrastra para construir una calle\nClic derecho para borrar calles\n"
	if mouse_check_button_pressed(mb_left){
		build_x = mx
		build_y = my
	}
	if abs(build_x - mx) > abs(build_y - my)
		my = build_y
	else
		mx = build_x
	if build_pressed{
		draw_set_color(c_black)
		draw_arrow((build_x - build_y) * tile_width - xpos, (build_x + build_y + 1) * tile_height - ypos, (mx - my) * tile_width - xpos, (mx + my + 1) * tile_height - ypos, 8)
		if mouse_check_button_released(mb_left){
			var b = 0
			if mx = build_x{
				for(var a = build_y; true; a += sign(my - build_y)){
					if not calle[# mx, a] and not mar[mx, a] and not bosque[# mx, a] and not zona_privada[# mx, a] and (not bool_edificio[# mx, a] or edificio_nombre[id_edificio[# mx, a]] = "Toma"){
						add_calle(mx, a)
						b++
					}
					if a = my
						break
				}
			}
			else for(var a = build_x; true; a += sign(mx - build_x)){
				if not calle[# a, my] and not mar[a, my] and not bosque[# a, my] and not zona_privada[# a, my] and (not bool_edificio[# a, my] or edificio_nombre[id_edificio[# a, my]] = "Toma"){
					add_calle(a, my)
					b++
				}
				if a = mx
					break
			}
			world_update = true
			dinero -= 10 * b
			mes_construccion[current_mes] += 10 * b
			recurso_construccion[26] += b
			if keyboard_check(vk_lshift)
				build_pressed = false
			else{
				build_calle = false
				select(,,,,, calle_carretera[# mx, my])
			}
		}
	}
	if mouse_check_button_pressed(mb_left)
		build_pressed = true
	if mouse_check_button_pressed(mb_right){
		mouse_clear(mb_right)
		if calle[# mx, my]
			destroy_calle(mx, my)
		else
			build_calle = false
	}
}
if not build_sel and not build_terreno and not sel_build and not build_calle
	build_pressed = false
//Seleccionar edificio
var mx = clamp(floor(((mouse_x + xpos) / tile_width + (mouse_y + ypos) / tile_height) / 2), 0, xsize - 1)
var my = clamp(floor(((mouse_y + ypos) / tile_height - (mouse_x + xpos) / tile_width) / 2), 0, ysize - 1)
if mx >= 0 and my >= 0 and mx < xsize and my < ysize and mouse_x < room_width - sel_info * 300 and not sel_build and not getstring and not build_terreno and not build_calle{
	if debug
		show_string += $"  ({mx}, {my}) Altura: {altura[# mx, my]}\n"
	if bool_edificio[# mx, my] or construccion_reservada[# mx, my] or zona_privada_venta[# mx, my] or calle[# mx, my]
		cursor = cr_handpoint
	if mouse_check_button_pressed(mb_left) and not build_sel{
		mouse_clear(mb_left)
		sel_info = bool_edificio[# mx, my] or construccion_reservada[# mx, my] or zona_privada_venta[# mx, my] or calle[# mx, my]
		if sel_info{
			sel_familia = null_familia
			sel_persona = null_persona
			close_show()
			if construccion_reservada[# mx, my]
				select(,,, draw_construccion[# mx, my])
			else if bool_edificio[# mx, my]{
				var edificio = id_edificio[# mx, my]
				if sel_comisaria{
					if not in(edificio_nombre[edificio.tipo], "Comisaría", "Prisión"){
						if sel_edificio.comisaria != null_edificio
							sel_edificio.comisaria.comisaria = null_edificio
						sel_edificio.comisaria = edificio
						edificio.comisaria = sel_edificio
					}
					sel_comisaria = false
				}
				select(edificio)
				if tutorial_bool and tutorial = 10
					tutorial_complete = true
			}
			else if zona_privada_venta[# mx, my]
				select(,,,, zona_privada_venta_terreno[# mx, my])
			else if calle[# mx, my]
				select(,,,,, calle_carretera[# mx, my])
		}
		else if sel_comisaria{
			if sel_edificio.comisaria != null_edificio
				sel_edificio.comisaria.comisaria = null_edificio
			sel_edificio.comisaria = null_edificio
			sel_comisaria = false
		}
	}
}
//Almanaque
if sel_info{
	draw_set_color(c_ltgray)
	draw_rectangle(room_width, 0, room_width - 300, room_height, false)
	draw_set_color(c_black)
	draw_set_halign(fa_right)
	pos = 0
	//Información edificios
	if sel_tipo = 0 and sel_edificio != null_edificio{
		x = sel_edificio.x
		y = sel_edificio.y
		var index = sel_edificio.tipo, width = sel_edificio.width, height = sel_edificio.height, var_edificio_nombre = edificio_nombre[index]
		draw_set_color(c_white)
		draw_rombo((x - y) * tile_width - xpos, (x + y) * tile_height - ypos - 1, (x - y - height) * tile_width - xpos - 1, (x + y + height) * tile_height - ypos, (x - y + width - height) * tile_width - xpos, (x + y + width + height) * tile_height - ypos + 1, (x - y + width) * tile_width - xpos + 1, (x + y + width) * tile_height - ypos, true)
		draw_set_color(c_black)
		if draw_boton(room_width, pos, sel_edificio.nombre)
			my_get_string("Nombre edificio", sel_edificio.nombre, function(text = "", edificio = [null_edificio]){
				edificio[0].nombre = text
			}, [sel_edificio])
		if sel_edificio.venta{
			draw_text_pos(room_width - 20, pos, "EDIFICIO A LA VENTA")
			pos += 20
			if draw_boton(room_width - 20, pos, "Cancelar venta"){
				for(var a = 0; a < array_length(edificios_a_la_venta); a++)
					if edificios_a_la_venta[a].edificio = sel_edificio{
						array_delete(edificios_a_la_venta, a, 1)
						break
					}
				set_paro(false, sel_edificio)
				sel_edificio.venta = false
			}
		}
		else{
			if sel_edificio.privado{
				draw_text_pos(room_width - 20, pos, "PRIVADO")
				if draw_boton(room_width - 20, pos, sel_edificio.empresa.nombre){
					sel_info = false
					sel_build = true
					ministerio = 7
					close_show()
					show[array_get_index(empresas, sel_edificio.empresa)] = true
				}
			}
			else if edificio_es_almacen[index] and var_edificio_nombre != "Mercado"{
				if draw_boton(room_width - 20, pos, $"{sel_edificio.es_almacen ? "Vendiendo al público" : "Sin vender al público"}"){
					if sel_edificio.es_almacen
						array_remove(almacenes[index], sel_edificio)
					else
						array_push(almacenes[index], sel_edificio)
					sel_edificio.es_almacen = not sel_edificio.es_almacen
				}
			}
			//Paro
			if sel_edificio.huelga{
				draw_text_pos(room_width - 20, pos, "Edificio en huelga")
				if sel_edificio.exigencia_fallida
					var a = 240 * array_length(sel_edificio.trabajadores)
				else
					a = 60 * array_length(sel_edificio.trabajadores)
				if draw_boton(room_width - 40, pos, $"Sobornar huelga ${a}") and dinero >= a{
					dinero -= a
					mes_salida_micelaneo[current_mes] += a
					sel_edificio.huelga = false
					set_paro(false, sel_edificio)
				}
				if draw_boton(room_width - 40, pos, exigencia_nombre[sel_edificio.huelga_motivo]) and show_question($"Aceptar exigencia?\n\n{exigencia_nombre[sel_edificio.huelga_motivo]}"){
					var array_edificio = [], b = sel_edificio.huelga_motivo
					for(a = 0; a < array_length(edificios); a++){
						var edificio = edificios[a]
						if edificio.huelga
							if edificio.huelga_motivo = b{
								array_push(array_edificio, edificio)
								edificio.huelga = false
								set_paro(false, edificio)
							}
					}
					var temp_exigencia = add_exigencia(b, array_edificio)
					for(a = 0; a < array_length(temp_exigencia.edificios); a++)
						temp_exigencia.edificios[a].exigencia = temp_exigencia
				}
				if array_length(edificio_count[34]) > 0 and draw_boton(room_width - 40, pos, "Que la policía haga su trabajo"){
					sel_edificio.huelga = false
					set_paro(false, sel_edificio)
					var flag = false
					while array_length(sel_edificio.trabajadores) > 0{
						var persona = sel_edificio.trabajadores[0]
						if brandom(){
							if ley_eneabled[11] and brandom(){
								destroy_persona(persona,, "Muerto por la policía")
								mes_muertos_asesinados[current_mes]++
								flag = true
								continue
							}
							else
								buscar_atencion_medica(persona)
						}
						arrestar_persona(persona, 6)
						persona.felicidad_temporal -= 40
						if persona.pareja != null_persona
							persona.pareja.felicidad_temporal -= 25
					}
					if flag
						for(a = 0; a < array_length(personas); a++)
							personas[a].felicidad_temporal -= 5
				}
				draw_set_alpha(0.5)
			}
			//Exigencia pendiente
			else if sel_edificio.exigencia != null_exigencia
				draw_text_pos(room_width - 20, pos, $"Esperando que cumplas {exigencia_nombre[sel_edificio.huelga_motivo]}")
			#region presupuesto
				if not sel_edificio.privado and var_edificio_nombre != "Toma"
					for(var a = 0; a < 5; a++)
						if draw_sprite_boton(spr_icono, 3 - (a > sel_edificio.presupuesto), room_width - 200 + a * 40, pos, 40, 40)
							if keyboard_check(vk_lshift){
								for(var b = 0; b < array_length(edificio_count[index]); b++)
									if not edificio_count[index, b].privado
										set_presupuesto(a, edificio_count[index, b])
							}
							else
								set_presupuesto(a, sel_edificio)
				pos += 40
				draw_text_pos(room_width - 40, pos, $"{edificio_es_trabajo[index] ? "Calidad laboral: " + string(floor(sel_edificio.trabajo_calidad)) + "  Sueldo: $" + string(sel_edificio.trabajo_sueldo) + "\n" : ""}{
					edificio_es_casa[index] ? "Calidad vivienda: " + string(floor(sel_edificio.vivienda_calidad)) + "  Renta: $" + string(sel_edificio.vivienda_renta) + "\n" : ""}{
					(edificio_servicio_calidad[index] > 0) ? "Calidad servicio: " + string(floor(sel_edificio.servicio_calidad)) + ((sel_edificio.servicio_tarifa > 0) ? "  Tarifa: $" + string(sel_edificio.servicio_tarifa + (var_edificio_nombre = "Taberna") ? ceil(recurso_precio[22] * 1.1) : 0) : "  Sin tarifa") + "\n" : ""}")
			#endregion
			//Prisiones
			if in(var_edificio_nombre, "Comisaría", "Prisión"){
				if draw_menu(room_width - 20, pos, $"{array_length(sel_edificio.clientes)} preso{array_length(sel_edificio.clientes) = 1 ? "" : "s"}", 2)
					for(var a = 0; a < array_length(sel_edificio.clientes); a++)
						if draw_boton(room_width - 40, pos, name(sel_edificio.clientes[a]))
							select(,, sel_edificio.clientes[a])
				if var_edificio_nombre = "Comisaría"{
					if sel_edificio.comisaria != null_edificio
						if draw_boton(room_width - 20, pos, $"Vigilando {sel_edificio.comisaria.nombre}")
							sel_edificio = sel_edificio.comisaria
					if draw_boton(room_width - 20, pos, "Vigilar un edificio"){
						sel_comisaria = true
						sel_info = false
					}
				}
			}
			else if sel_edificio.comisaria != null_edificio
				if draw_boton(room_width - 20, pos, $"Custodiado por {sel_edificio.comisaria.nombre}")
					sel_edificio = sel_edificio.comisaria
			//Información familias
			if edificio_es_casa[index]{
				if draw_menu(room_width - 20, pos, $"Familias: {array_length(sel_edificio.familias)}/{edificio_familias_max[index]}", 3)
					for(var a = 0; a < array_length(sel_edificio.familias); a++){
						var familia = sel_edificio.familias[a]
						if draw_boton(room_width - 40, pos, $"Familia {familia.padre.apellido} {familia.madre.apellido}")
							select(, familia)
					}
				if not sel_edificio.privado and edificio_nombre[sel_edificio.tipo] != "Toma" and draw_boton(room_width - 20, pos, sel_edificio.vivienda_renta = 0 ? "Generar tarifas" : "Subvencionar vivienda"){
					if sel_edificio.vivienda_renta = 0
						for(var a = 0; a < array_length(sel_edificio.familias); a++){
							var familia = sel_edificio.familias[a]
							for_familia(function(persona = null_persona){
								persona.felicidad_temporal -= 25
							}, familia)
						}
					if sel_edificio.vivienda_renta > 0
						for(var a = 0; a < array_length(sel_edificio.familias); a++){
							var familia = sel_edificio.familias[a]
							for_familia(function(persona= null_persona){
								persona.felicidad_temporal += 25
							}, familia, false)
						}
					sel_edificio.vivienda_renta = edificio_familias_renta[index] - sel_edificio.vivienda_renta
					set_calidad_vivienda(sel_edificio)
				}
			}
			mejora_requiere_agua = false
			mejora_requiere_energia = false
			//Información trabajadores
			if edificio_es_trabajo[index]{
				for(var a = 0; a < sel_edificio.trabajadores_max; a++){
					if a < array_length(sel_edificio.trabajadores){
						var persona = sel_edificio.trabajadores[a]
						if draw_sprite_boton(spr_icono, 12 + (persona.sexo), room_width - 25 - 25 * (a mod 10), pos + 25 * floor(a / 10),,, true, name(persona))
							if mouse_lastbutton = mb_left
								select(,, persona)
							else
								cambiar_trabajo(persona, null_edificio)
					}
					else if a < sel_edificio.trabajadores_max_allow{
						if draw_sprite_boton(spr_icono, (index = 24), room_width - 25 - 25 * (a mod 10), pos + 25 * floor(a / 10),,, true) and mouse_lastbutton = mb_right{
							sel_edificio.trabajadores_max_allow = a
							if array_length(sel_edificio.trabajadores) = a
								array_remove(trabajo_educacion[sel_edificio.trabajo_educacion], sel_edificio, "trabajo ya no está disponible")
						}
					}
					else if draw_sprite_boton(spr_icono, 14 + (index = 24), room_width - 25 - 25 * (a mod 10), pos + 25 * floor(a / 10)){
						sel_edificio.trabajadores_max_allow = a + 1
						if array_length(sel_edificio.trabajadores) < a + 1
							array_push(trabajo_educacion[sel_edificio.trabajo_educacion], sel_edificio)
					}
				}
				pos += 25 * ceil(sel_edificio.trabajadores_max / 10)
				if var_edificio_nombre = "Granja"{
					draw_text_pos(room_width - 40, pos, $"Eficiencia: {floor(sel_edificio.eficiencia * 100)}%")
					if contaminacion[# sel_edificio.x, sel_edificio.y] > 0
						draw_text_pos(room_width - 60, pos, $"Contaminación: -{floor(clamp(contaminacion[# sel_edificio.x, sel_edificio.y], 0, 100) / 2)}%")
					draw_text_pos(room_width - 20, pos, $"Produciendo {recurso_nombre[recurso_cultivo[sel_edificio.modo]]}")
					if not sel_edificio.privado and draw_boton(room_width - 40, pos, "Cambiar recurso", , not sel_edificio.huelga)
						sel_modo = not sel_modo
					if sel_modo
						for(var a = 0; a < array_length(recurso_cultivo); a++)
							if a != sel_edificio.modo{
								if draw_boton(room_width - 40, pos, recurso_nombre[recurso_cultivo[a]]){
									sel_edificio.modo = a
									sel_edificio.nombre = $"{var_edificio_nombre} de {recurso_nombre[recurso_cultivo[a]]} {++edificio_number_granja[a]}"
									show[3] = false
								}
								if mouse_x > room_width - 40 - last_width and mouse_y > pos - last_height and mouse_x < room_width - 40 and mouse_y < pos{
									draw_gradiente(a, 0)
									draw_set_color(c_black)
								}
							}
					//Mejoras
					var var_nombre_cultivo = recurso_nombre[recurso_cultivo[sel_edificio.modo]]
					edificio_mejora(sel_edificio, mejora_fertilizantes_sinteticos)
					edificio_mejora(sel_edificio, mejora_tractores)
					edificio_mejora(sel_edificio, mejora_pestisidas)
					edificio_mejora(sel_edificio, mejora_riego_por_goteo)
					edificio_mejora(sel_edificio, mejora_uso_de_drones)
					if var_nombre_cultivo = "Cereales"{
						edificio_mejora(sel_edificio, mejora_segadora)
						edificio_mejora(sel_edificio, mejora_trilladora)
					}
					else if var_nombre_cultivo = "Tabaco"{
						edificio_mejora(sel_edificio, mejora_trapiche_hidraulico)
						edificio_mejora(sel_edificio, mejora_maquina_enroladora)
					}
					else if var_nombre_cultivo = "Algodón"{
						edificio_mejora(sel_edificio, mejora_maquina_desmotadora)
						edificio_mejora(sel_edificio, mejora_trapiche_hidraulico)
					}
					else if var_nombre_cultivo = "Azucar"{
						edificio_mejora(sel_edificio, mejora_trapiche_hidraulico)
						edificio_mejora(sel_edificio, mejora_caldera_de_cristalizacion)
						edificio_mejora(sel_edificio, mejora_purificacion_con_cal_viva)
					}
					else if var_nombre_cultivo = "Plátano"
						edificio_mejora(sel_edificio, mejora_frigorificos)
				}
				else if var_edificio_nombre = "Pescadería"{
					var zona_pesca = sel_edificio.zona_pesca
					c = zona_pesca.a
					d = zona_pesca.b
					draw_set_color(c_white)
					draw_set_alpha(0.2 + 0.4 * zona_pesca.cantidad / zona_pesca.cantidad_max)
					draw_circle((c - d) * tile_width - xpos, (c + d + 1) * tile_height - ypos, tile_height * (1 + zona_pesca.cantidad / 800), false)
					draw_set_alpha(1)
					if sqrt(sqr(mx - c) + sqr(my - d)) < 5
						show_string += $"Pescado: {floor(zona_pesca.cantidad)}"
					draw_set_color(c_black)
					draw_text_pos(room_width - 40, pos, $"Eficiencia: {floor(100 * sel_edificio.eficiencia * (0.8 + 0.1 * sel_edificio.presupuesto))}%")
					if contaminacion[# sel_edificio.x, sel_edificio.y] > 0
						draw_text_pos(room_width - 50, pos, $"Contaminación: {100 - floor(clamp(contaminacion[# sel_edificio.x, sel_edificio.y], 0, 100) / 2)}%")
					//Mejoras
					edificio_mejora(sel_edificio, mejora_pesca_por_arrastre)
					edificio_mejora(sel_edificio, mejora_barcos_a_vapor)
					if array_contains(sel_edificio.input_id, 9)
						edificio_mejora(sel_edificio, mejora_motor_de_diesel)
					edificio_mejora(sel_edificio, mejora_barcos_factoria)
					edificio_mejora(sel_edificio, mejora_uso_de_drones)
					edificio_mejora(sel_edificio, mejora_frigorificos)
				}
				else if var_edificio_nombre = "Mina"{
					draw_text_pos(room_width - 20, pos, $"Extrayendo {recurso_nombre[recurso_mineral[sel_edificio.modo]]}")
					c = 0
					d = min(xsize - 1, sel_edificio.x + width + 1)
					e = min(xsize - 1, sel_edificio.y + height + 1)
					var f = max(0, sel_edificio.y - 1)
					for(var a = max(0, sel_edificio.x - 1); a < d; a++)
						for(var b = f; b < e; b++)
							if mineral[sel_edificio.modo][a, b]
								c += mineral_cantidad[sel_edificio.modo][a, b]
					draw_text_pos(room_width - 40, pos, $"Depósito: {c}")
					if not sel_edificio.privado and draw_menu(room_width - 20, pos, "Cambiar recurso", 3)
						for(var a = 0; a < array_length(recurso_mineral); a++)
							if a != sel_edificio.modo{
								if draw_boton(room_width - 40, pos, recurso_nombre[recurso_mineral[a]]){
									sel_edificio.modo = a
									sel_edificio.nombre = $"{var_edificio_nombre} de {recurso_nombre[recurso_mineral[a]]} {++edificio_number_mina[a]}"
									show[3] = false
									set_paro(false, sel_edificio)
								}
								if mouse_x > room_width - 40 - last_width and mouse_y > pos - last_height and mouse_x < room_width - 40 and mouse_y < pos{
									draw_gradiente(a, 1)
									draw_set_color(c_black)
								}
							}
					//Mejoras
					var var_nombre_mineral = recurso_nombre[recurso_mineral[sel_edificio.modo]]
					edificio_mejora(sel_edificio, mejora_ferrocarriles)
					edificio_mejora(sel_edificio, mejora_explosivos_mineros)
					edificio_mejora(sel_edificio, mejora_camiones)
					edificio_mejora(sel_edificio, mejora_computadores)
					edificio_mejora(sel_edificio, mejora_filtros_industriales)
					edificio_mejora(sel_edificio, mejora_uso_de_drones)
					if var_nombre_mineral = "Carbón"{
						edificio_mejora(sel_edificio, mejora_bomba_a_vapor)
						if array_contains(sel_edificio.input_id, 9)
							edificio_mejora(sel_edificio, mejora_motor_de_diesel)
						edificio_mejora(sel_edificio, mejora_mineria_a_cielo_abierto)
					}
					else if var_nombre_mineral = "Oro"{
						edificio_mejora(sel_edificio, mejora_canaletas_y_dragas)
						edificio_mejora(sel_edificio, mejora_cianuracion)
					}
					else if var_nombre_mineral = "Cobre"{
						edificio_mejora(sel_edificio, mejora_proceso_electrolitico)
						edificio_mejora(sel_edificio, mejora_reciclaje_de_materiales)
					}
					else if var_nombre_mineral = "Aluminio"
						edificio_mejora(sel_edificio, mejora_reciclaje_de_materiales)
				}
				else if var_edificio_nombre = "Rancho"{
					if contaminacion[# sel_edificio.x, sel_edificio.y] > 0
						draw_text_pos(room_width - 40, pos, $"Eficiencia: {100 - floor(clamp(contaminacion[# sel_edificio.x, sel_edificio.y], 0, 100) / 2)}%")
					draw_text_pos(room_width - 20, pos, $"Produciendo {ganado_nombre[sel_edificio.modo]}")
					if not sel_edificio.privado and draw_menu(room_width - 20, pos, "Cambiar recurso", 3)
						for(var a = 0; a < array_length(ganado_nombre); a++)
							if a != sel_edificio.modo and draw_boton(room_width - 40, pos, ganado_nombre[a]){
								for(var b = 0; b < array_length(ganado_produccion[sel_edificio.modo]); b++)
									sel_edificio.almacen[ganado_produccion[sel_edificio.modo, b]] = 0
								sel_edificio.modo = a
								sel_edificio.nombre = $"{var_edificio_nombre} de {ganado_nombre[a]} {++edificio_number_rancho[a]}"
								show[3] = false
							}
					//Mejoras
					var var_ganado_nombre = ganado_nombre[sel_edificio.modo]
					edificio_mejora(sel_edificio, mejora_vacunas)
					if var_ganado_nombre = "Vacas"
						edificio_mejora(sel_edificio, mejora_frigorificos)
					else if var_ganado_nombre = "Cabras"{
						edificio_mejora(sel_edificio, mejora_frigorificos)
						edificio_mejora(sel_edificio, mejora_pasteurizacion)
						edificio_mejora(sel_edificio, mejora_ordena_automatica)
					}
					else if var_ganado_nombre = "Ovejas"
						edificio_mejora(sel_edificio, mejora_esquiladora_electrica)
					else if var_ganado_nombre = "Cerdos"
						edificio_mejora(sel_edificio, mejora_frigorificos)
				}
				else if var_edificio_nombre = "Aserradero"{
					if draw_boton(room_width - 20, pos, $"{(sel_edificio.modo = 0) ? "Despejar bosque" : "Reforestación"}")
						sel_edificio.modo = 1 - sel_edificio.modo
					//Mejoras
					edificio_mejora(sel_edificio, mejora_sierras_a_vapor)
					if array_contains(sel_edificio.input_id, 9)
						edificio_mejora(sel_edificio, mejora_motor_de_diesel)
					edificio_mejora(sel_edificio, mejora_tractores)
					edificio_mejora(sel_edificio, mejora_motosierra)
				}
				else if var_edificio_nombre = "Pozo Petrolífero"{
					c = 0
					d = x + width
					e = y + height
					for(var a = x; a < d; a++)
						for(var b = y; b < e; b++)
							c += petroleo[# a, b]
					if c > 0
						draw_text_pos(room_width - 20, pos, $"Depósito: {c}")
					else
						draw_text_pos(room_width - 20, pos, "Depósito vacío")
					//Mejoras
					edificio_mejora(sel_edificio, mejora_bomba_rotativa)
					edificio_mejora(sel_edificio, mejora_destilacion_fraccionada)
					edificio_mejora(sel_edificio, mejora_fracking)
					edificio_mejora(sel_edificio, mejora_uso_de_drones)
				}
				else if var_edificio_nombre = "Bomba de Agua"{
					draw_text_pos(room_width - 20, pos, $"Empujando {floor(sel_edificio.count)} agua")
					if sel_edificio.almacen[1] + sel_edificio.almacen[9] + sel_edificio.almacen[27] = 0
						draw_text_pos(room_width - 30, pos, "Necesita combustible!")
					edificio_mejora(sel_edificio, mejora_bomba_rotativa)
					edificio_mejora(sel_edificio, mejora_computadores)
				}
				else if var_edificio_nombre = "Planta Siderúrgica"{
					//Mejoras
					edificio_mejora(sel_edificio, mejora_acero_inoxidable)
					edificio_mejora(sel_edificio, mejora_proceso_bassemer)
					edificio_mejora(sel_edificio, mejora_horno_de_arco_electrico)
				}
				else if var_edificio_nombre = "Banco"{
					edificio_mejora(sel_edificio, mejora_computadores)
					edificio_mejora(sel_edificio, mejora_internet)
					edificio_mejora(sel_edificio, mejora_criptografia)
				}
				else if var_edificio_nombre = "Muelle"{
					edificio_mejora(sel_edificio, mejora_ferrocarriles)
					edificio_mejora(sel_edificio, mejora_frigorificos)
					edificio_mejora(sel_edificio, mejora_camiones)
					edificio_mejora(sel_edificio, mejora_gruas_a_vapor)
					if array_contains(sel_edificio.input_id, 9)
						edificio_mejora(sel_edificio, mejora_motor_de_diesel)
					edificio_mejora(sel_edificio, mejora_gruas_electricas)
					edificio_mejora(sel_edificio, mejora_contenedores)
					edificio_mejora(sel_edificio, mejora_computadores)
				}
				else if var_edificio_nombre = "Oficina de Construcción"{
					edificio_mejora(sel_edificio, mejora_camiones)
					edificio_mejora(sel_edificio, mejora_gruas_electricas)
					edificio_mejora(sel_edificio, mejora_computadores)
				}
				else if var_edificio_nombre = "Oficina de Transporte"{
					edificio_mejora(sel_edificio, mejora_camiones)
					edificio_mejora(sel_edificio, mejora_contenedores)
					edificio_mejora(sel_edificio, mejora_gruas_electricas)
					edificio_mejora(sel_edificio, mejora_internet)
				}
				else if var_edificio_nombre = "Taller Textil"{
					edificio_mejora(sel_edificio, mejora_maquinas_de_coser)
					edificio_mejora(sel_edificio, mejora_linea_de_montaje)
					edificio_mejora(sel_edificio, mejora_computadores)
					edificio_mejora(sel_edificio, mejora_uso_de_drones)
				}
				else if var_edificio_nombre = "Astillero"{
					edificio_mejora(sel_edificio, mejora_ferrocarriles)
					if edificio_mejora(sel_edificio, mejora_barcos_a_vapor){
						set_industria_io(sel_edificio, [1], [0])
						add_industria_io(sel_edificio, [15], [20])
					}
					if edificio_mejora(sel_edificio, mejora_barcos_factoria){
						set_industria_io(sel_edificio, [1], [0])
						add_industria_io(sel_edificio, [15], [20])
					}
					edificio_mejora(sel_edificio, mejora_gruas_a_vapor)
					if array_contains(sel_edificio.input_id, 9)
						edificio_mejora(sel_edificio, mejora_motor_de_diesel)
					edificio_mejora(sel_edificio, mejora_gruas_electricas)
					edificio_mejora(sel_edificio, mejora_computadores)
				}
				else if var_edificio_nombre = "Destilería"{
					edificio_mejora(sel_edificio, mejora_destilacion_fraccionada)
					edificio_mejora(sel_edificio, mejora_bomba_a_vapor)
					if array_contains(sel_edificio.input_id, 9)
						edificio_mejora(sel_edificio, mejora_motor_de_diesel)
					edificio_mejora(sel_edificio, mejora_computadores)
					edificio_mejora(sel_edificio, mejora_filtros_industriales)
				}
				else if var_edificio_nombre = "Quesería"{
					edificio_mejora(sel_edificio, mejora_destilacion_fraccionada)
					edificio_mejora(sel_edificio, mejora_pasteurizacion)
					edificio_mejora(sel_edificio, mejora_filtros_industriales)
				}
				else if var_edificio_nombre = "Herrería"{
					edificio_mejora(sel_edificio, mejora_prensadora_a_vapor)
					if array_contains(sel_edificio.input_id, 9)
						edificio_mejora(sel_edificio, mejora_motor_de_diesel)
					edificio_mejora(sel_edificio, mejora_linea_de_montaje)
					edificio_mejora(sel_edificio, mejora_computadores)
					edificio_mejora(sel_edificio, mejora_uso_de_drones)
				}
				else if var_edificio_nombre = "Mueblería"{
					edificio_mejora(sel_edificio, mejora_motosierra)
					edificio_mejora(sel_edificio, mejora_linea_de_montaje)
					edificio_mejora(sel_edificio, mejora_computadores)
				}
				else if var_edificio_nombre = "Tejar"{
					edificio_mejora(sel_edificio, mejora_prensadora_a_vapor)
					if array_contains(sel_edificio.input_id, 9)
						edificio_mejora(sel_edificio, mejora_motor_de_diesel)
					edificio_mejora(sel_edificio, mejora_reciclaje_de_materiales)
				}
				else if var_edificio_nombre = "Planta Termoeléctrica"{
					draw_text_pos(room_width - 40, pos, $"Produciendo {floor(sel_edificio.count)} energía")
					edificio_mejora(sel_edificio, mejora_filtros_industriales)
				}
				else if var_edificio_nombre = "Oficina de Bomberos"{
					edificio_mejora(sel_edificio, mejora_bomba_a_vapor)
					if array_contains(sel_edificio.input_id, 9)
						edificio_mejora(sel_edificio, mejora_motor_de_diesel)
					edificio_mejora(sel_edificio, mejora_camiones)
				}
				else if var_edificio_nombre = "Armería"{
					edificio_mejora(sel_edificio, mejora_prensadora_a_vapor)
					edificio_mejora(sel_edificio, mejora_motor_de_diesel)
					edificio_mejora(sel_edificio, mejora_linea_de_montaje)
					edificio_mejora(sel_edificio, mejora_computadores)
				}
				else if var_edificio_nombre = "Planta Química"{
					edificio_mejora(sel_edificio, mejora_frigorificos)
					edificio_mejora(sel_edificio, mejora_proceso_electrolitico)
					edificio_mejora(sel_edificio, mejora_linea_de_montaje)
					edificio_mejora(sel_edificio, mejora_computadores)
					edificio_mejora(sel_edificio, mejora_filtros_industriales)
					edificio_mejora(sel_edificio, mejora_reciclaje_de_materiales)
				}
				else if var_edificio_nombre = "Fábrica de Vehículos"{
					edificio_mejora(sel_edificio, mejora_gruas_electricas)
					edificio_mejora(sel_edificio, mejora_linea_de_montaje)
					edificio_mejora(sel_edificio, mejora_computadores)
					edificio_mejora(sel_edificio, mejora_uso_de_drones)
				}
				else if var_edificio_nombre = "Taller de Costura"{
					edificio_mejora(sel_edificio, mejora_maquinas_de_coser)
					edificio_mejora(sel_edificio, mejora_linea_de_montaje)
					edificio_mejora(sel_edificio, mejora_computadores)
					edificio_mejora(sel_edificio, mejora_reciclaje_de_materiales)
				}
				else if var_edificio_nombre = "Refinería de Plásticos"{
					edificio_mejora(sel_edificio, mejora_linea_de_montaje)
					edificio_mejora(sel_edificio, mejora_computadores)
					edificio_mejora(sel_edificio, mejora_reciclaje_de_materiales)
					edificio_mejora(sel_edificio, mejora_uso_de_drones)
					edificio_mejora(sel_edificio, mejora_filtros_industriales)
				}
				else if in(var_edificio_nombre, "Comisaría", "Prisión"){
					edificio_mejora(sel_edificio, mejora_camiones)
					edificio_mejora(sel_edificio, mejora_internet)
					if var_edificio_nombre = "Prisión"{
						pos += 20
						draw_text_pos(room_width - 20, pos, (sel_edificio.modo = 0) ? "Aglomeración" : ((sel_edificio.modo = 1) ? "Campo de reeducación" : "Trabajo voluntario"))
						if draw_menu(room_width - 30, pos, "Cambiar modo", 3){
							if sel_edificio.modo != 0 and draw_boton(room_width - 40, pos, "Aglomeración"){
								sel_edificio.count = 12
								set_carcel_cantidad(sel_edificio)
								set_mantenimiento(10, sel_edificio)
								set_trabajo_educacion(0, sel_edificio)
								if sel_edificio.modo = 1
									add_trabajo_sueldo(-2, sel_edificio)
								sel_edificio.modo = 0
							}
							if sel_edificio.modo != 1 and draw_boton(room_width - 40, pos, "Campo de reeducación"){
								sel_edificio.modo = 1
								sel_edificio.count = 6
								set_mantenimiento(20, sel_edificio)
								set_carcel_cantidad(sel_edificio)
								set_trabajo_educacion(1, sel_edificio)
								add_trabajo_sueldo(2, sel_edificio)
							}
							if sel_edificio.modo != 2 and draw_boton(room_width - 40, pos, "Trabajo voluntario"){
								sel_edificio.servicio_max = 8
								set_mantenimiento(10, sel_edificio)
								set_carcel_cantidad(sel_edificio)
								set_trabajo_educacion(0, sel_edificio)
								if sel_edificio.modo = 1
									add_trabajo_sueldo(-2, sel_edificio)
								sel_edificio.modo = 2
							}
						}
					}
				}
				else if in(var_edificio_nombre, "Escuela", "Escuela parroquial"){
					edificio_mejora(sel_edificio, mejora_computadores)
					edificio_mejora(sel_edificio, mejora_internet)
					if var_edificio_nombre = "Escuela"{
						pos += 20
						draw_text_pos(room_width - 20, pos, sel_edificio.modo = 0 ? "Cobertura" : (sel_edificio.modo = 1 ? "Excelencia" : "Vespertina"))
						if draw_menu(room_width - 30, pos, "Cambiar modo", 3){
							if sel_edificio.modo != 0 and draw_boton(room_width - 40, pos, "Cobertura"){
								if sel_edificio.modo = 2{
									sel_edificio.modo = 0
									while array_length(sel_edificio.clientes) > 0
										buscar_escuela(array_pop(sel_edificio.clientes))
								}
								set_escuela_clientes_max(20, sel_edificio)
								sel_edificio.modo = 0
								set_calidad_servicio(sel_edificio)
								close_show()
							}
							if sel_edificio.modo != 1 and draw_boton(room_width - 40, pos, "Excelencia"){
								if sel_edificio.modo = 2{
									sel_edificio.modo = 1
									while array_length(sel_edificio.clientes) > 0
										buscar_escuela(array_pop(sel_edificio.clientes))
								}
								set_escuela_clientes_max(12, sel_edificio)
								sel_edificio.modo = 1
								set_calidad_servicio(sel_edificio)
								close_show()
							}
							if sel_edificio.modo != 2 and draw_boton(room_width - 40, pos, "Vespertina"){
								while array_length(sel_edificio.clientes) > 0
									buscar_escuela(array_pop(sel_edificio.clientes))
								set_escuela_clientes_max(20, sel_edificio)
								sel_edificio.modo = 2
								set_calidad_servicio(sel_edificio)
								close_show()
							}
						}
					}
				}
				else if in(var_edificio_nombre, "Consultorio", "Hospicio", "Hospital"){
					edificio_mejora(sel_edificio, mejora_anestesia)
					edificio_mejora(sel_edificio, mejora_penicilina)
					edificio_mejora(sel_edificio, mejora_vacunas)
					edificio_mejora(sel_edificio, mejora_computadores)
					edificio_mejora(sel_edificio, mejora_internet)
					if var_edificio_nombre = "Consultorio"{
						pos += 20
						draw_text_pos(room_width - 20, pos, "Tratamiento " + (sel_edificio.modo = 0) ? "convencional" : "tradicional")
						if draw_menu(room_width - 30, pos, "Cambiar modo", 3){
							if sel_edificio.modo != 0 and draw_boton(room_width - 40, pos, "Tratamiento convencional"){
								sel_edificio.modo = 0
								set_trabajo_educacion(3, sel_edificio)
								add_trabajo_sueldo(2, sel_edificio)
								set_calidad_servicio(sel_edificio)
								close_show()
							}
							if sel_edificio.modo != 1 and draw_boton(room_width - 40, pos, "Tratamiento tradicional"){
								sel_edificio.modo = 1
								set_trabajo_educacion(2, sel_edificio)
								add_trabajo_sueldo(-2, sel_edificio)
								set_calidad_servicio(sel_edificio)
								close_show()
							}
						}
					}
					else if var_edificio_nombre = "Hospital"{
						pos += 20
						draw_text_pos(room_width - 20, pos, "Tratamiento " + ((sel_edificio.modo = 0) ? "convencional" : ((sel_edificio.modo = 1) ? "ambulatorio" : "experimental")))
						if draw_menu(room_width - 30, pos, "Cambiar modo", 3){
							if sel_edificio.modo != 0 and draw_boton(room_width - 40, pos, "Tratamiento convencional"){
								sel_edificio.modo = 0
								sel_edificio.servicio_max = 30
								while array_length(sel_edificio.clientes) > 30
									buscar_atencion_medica(array_pop(sel_edificio.clientes))
								set_calidad_servicio(sel_edificio)
								set_trabajo_educacion(3, sel_edificio)
								set_trabajadores_max(8, sel_edificio)
								add_trabajo_sueldo(12 - sel_edificio.trabajo_sueldo, sel_edificio)
								close_show()
							}
							if sel_edificio.modo != 1 and draw_boton(room_width - 40, pos, "Tratamiento ambulatorio"){
								sel_edificio.modo = 1
								sel_edificio.servicio_max = 45
								set_calidad_servicio(sel_edificio)
								set_trabajo_educacion(3, sel_edificio)
								set_trabajadores_max(8, sel_edificio)
								add_trabajo_sueldo(12 - sel_edificio.trabajo_sueldo, sel_edificio)
								close_show()
							}
							if sel_edificio.modo != 2 and draw_boton(room_width - 40, pos, "Tratamiento experimental"){
								sel_edificio.modo = 2
								sel_edificio.servicio_max = 30
								while array_length(sel_edificio.clientes) > 30
									buscar_atencion_medica(array_pop(sel_edificio.clientes))
								set_calidad_servicio(sel_edificio)
								set_trabajo_educacion(4, sel_edificio)
								set_trabajadores_max(6, sel_edificio)
								add_trabajo_sueldo(15 - sel_edificio.trabajo_sueldo, sel_edificio)
								close_show()
							}
						}	
					}
				}
				else if var_edificio_nombre = "Mercado"{
					draw_text_pos(room_width - 20, pos, sel_edificio.count = 0 ? "Sin más ventas por este mes" : $"{sel_edificio.count} ventas disponibles")
					edificio_mejora(sel_edificio, mejora_frigorificos)
					edificio_mejora(sel_edificio, mejora_contenedores)
				}
				else if var_edificio_nombre = "Conservadora"{
					draw_text_pos(room_width - 20, pos, $"Enlatando {recurso_nombre[sel_edificio.array_complex[0].a]}")
					if not sel_edificio.privado and draw_menu(room_width - 20, pos, "Modos de trabajo", 3){
						var b = -1
						if draw_boton(room_width - 40, pos, "Enlatar carne")
							b = 0
						if draw_boton(room_width - 40, pos, "Enlatar pescado")
							b = 1
						if draw_boton(room_width - 40, pos, "Enlatar legumbres")
							b = 2
						if (dia / 360) > 100 and draw_boton(room_width - 40, pos, "Enlatar leche")
							b = 3
						if (dia / 360) > 110 and draw_boton(room_width - 40, pos, "Enlatar soya")
							b = 4
						if b >= 0{
							for(var a = 0; a < array_length(sel_edificio.array_complex); a++){
								var temp_complex = sel_edificio.array_complex[a]
								add_industria_io(sel_edificio, [real(temp_complex.a)], [-real(temp_complex.b)])
							}
							sel_edificio.modo = b
						}
						if b = 0
							sel_edificio.array_complex = [{a : 18, b : 1}]
						else if b = 1
							sel_edificio.array_complex = [{a : 8, b : 1}]
						else if b = 2
							sel_edificio.array_complex = [{a : 0, b : 1}]
						else if b = 3
							sel_edificio.array_complex = [{a : 19, b : 1}]
						else if b = 4
							sel_edificio.array_complex = [{a : 6, b : 1}]
						if b >= 0{
							for(var a = 0; a < array_length(sel_edificio.array_complex); a++){
								var temp_complex = sel_edificio.array_complex[a]
								add_industria_io(sel_edificio, [real(temp_complex.a)], [real(temp_complex.b)])
							}
							show[3] = false
						}
					}
					edificio_mejora(sel_edificio, mejora_frigorificos)
					edificio_mejora(sel_edificio, mejora_contenedores)
					edificio_mejora(sel_edificio, mejora_linea_de_montaje)
					edificio_mejora(sel_edificio, mejora_pasteurizacion)
					edificio_mejora(sel_edificio, mejora_latas_de_aluminio)
				}
				else if var_edificio_nombre = "Paneles Solares"
					draw_text_pos(room_width - 40, pos, $"Produciendo {floor(sel_edificio.count)} energía")
				else if var_edificio_nombre = "Taberna"
					edificio_mejora(sel_edificio, mejora_frigorificos)
				else if in(var_edificio_nombre, "Cine", "Capilla", "Teatro")
					edificio_mejora(sel_edificio, mejora_parlantes)
				else if in(var_edificio_nombre, "Periódico", "Antena de Radio", "Estudio de Televisión"){
					if sel_edificio.modo < 0
						draw_text_pos(room_width - 20, pos, $"Difamando a {name(candidatos[1 - sel_edificio.modo])}")
					else
						draw_text_pos(room_width - 20, pos, medios_comunicacion_modos[sel_edificio.modo])
					if not sel_edificio.privado and draw_menu(room_width - 20, pos, "Cambiar funcionamiento", 3){
						if sel_edificio.modo != 0 and draw_boton(room_width - 40, pos, medios_comunicacion_modos[0]){
							sel_edificio.modo = 0
							set_calidad_servicio(sel_edificio)
							close_show()
						}
						if elecciones{
							if sel_edificio.modo != 1 and draw_boton(room_width - 40, pos, medios_comunicacion_modos[1]){
								sel_edificio.modo = 1
								set_calidad_servicio(sel_edificio)
								close_show()
							}
							if draw_menu(room_width - 40, pos, "Difamar cantidato", 5){
								for(var a = 0; a < array_length(candidatos); a++)
									if draw_boton(room_width - 60, pos, name(candidatos[a])){
										sel_edificio.modo = -1 - a
										set_calidad_servicio(sel_edificio)
										close_show()
									}
							}
						}
						if sel_edificio.modo != 2 and draw_boton(room_width - 40, pos, medios_comunicacion_modos[2]){
							sel_edificio.modo = 2
							set_calidad_servicio(sel_edificio)
							close_show()
						}
					}
					//Mejoras
					if var_edificio_nombre = "Periódico"{
						edificio_mejora(sel_edificio, mejora_maquinas_de_escribir)
						edificio_mejora(sel_edificio, mejora_maquinas_de_escribir_electricas)
					}
					edificio_mejora(sel_edificio, mejora_computadores)
					edificio_mejora(sel_edificio, mejora_internet)
				}
				else if var_edificio_nombre = "Depósito de Taxis"{
					if array_length(sel_edificio.carreteras) = 0
						draw_text_pos(room_width - 20, pos, "¡Necesitamos conección a\ncarreteras para funcionar!")
					else{
						draw_text_pos(room_width - 20, pos, $"Haciendo {floor(sel_edificio.count)} viajes mensuales")
						draw_text_pos(room_width - 20, pos, "Conectado a")
						for(var a = 0; a < array_length(sel_edificio.carreteras); a++)
							draw_text_pos(room_width - 40, pos, $"Carretera {sel_edificio.carreteras[a].index}")
					}
				}
				else if var_edificio_nombre = "Biblioteca"{
					//Mejoras
					edificio_mejora(sel_edificio, mejora_maquinas_de_escribir)
					edificio_mejora(sel_edificio, mejora_maquinas_de_escribir_electricas)
					edificio_mejora(sel_edificio, mejora_computadores)
					edificio_mejora(sel_edificio, mejora_internet)
					pos += 20
					if sel_edificio.modo < 2
						draw_text_pos(room_width - 20, pos, sel_edificio.modo = 0 ? "Venta de libros" : "Libros educativos")
					else{
						draw_text_pos(room_width - 20, pos, $"Investigando {edificio_nombre[edificio_categoria[5, sel_edificio.modo - 2]]}")
						if draw_menu(room_width - 30, pos, "Cambiar industria", 4)
							for(var a = 0; a < array_length(edificio_categoria[5]); a++){
								var b = edificio_categoria[5, a]
								if sel_edificio.modo != (2 + a) and array_length(edificio_count[b]) > 0 and (dia / 360) >= edificio_anno[b] and draw_boton(room_width - 40, pos, edificio_nombre[b]){
									sel_edificio.modo = 2 + a
									close_show()
								}
							}
					}
					if draw_menu(room_width - 30, pos, "Cambiar modo", 3){
						if sel_edificio.modo != 0 and draw_boton(room_width - 40, pos, "Venta de libros"){
							sel_edificio.servicio_max = 20
							sel_edificio.servicio_tarifa = 3
							sel_edificio.modo = 0
							set_calidad_servicio(sel_edificio)
							close_show()
						}
						if sel_edificio.modo != 1 and draw_boton(room_width - 40, pos, "Libros educativos"){
							sel_edificio.servicio_max =  10
							sel_edificio.servicio_tarifa = 0
							sel_edificio.modo = 1
							set_calidad_servicio(sel_edificio)
							close_show()
						}
						var flag = false, a
						for(a = 0; a < array_length(edificio_categoria[5]); a++)
							if array_length(edificio_count[edificio_categoria[5, a]]) > 0{
								flag = true
								break
							}
						if flag and draw_boton(room_width - 40, pos, "Investigación"){
							sel_edificio.servicio_max = 0
							sel_edificio.servicio_tarifa = 0
							sel_edificio.modo = 2 + a
							close_show()
						}
					}
				}
				else if var_edificio_nombre = "Universidad"{
					//Mejoras
					edificio_mejora(sel_edificio, mejora_computadores)
					edificio_mejora(sel_edificio, mejora_internet)
					pos += 20
					if sel_edificio.modo < 2
						draw_text_pos(room_width - 20, pos, sel_edificio.modo = 0 ? "Educación Profesional" : "Educación Técnica")
					else{
						draw_text_pos(room_width - 20, pos, $"Investigando {edificio_nombre[edificio_categoria[5, sel_edificio.modo - 2]]}")
						if draw_menu(room_width - 30, pos, "Cambiar industria", 4)
							for(var a = 0; a < array_length(edificio_categoria[5]); a++){
								var b = edificio_categoria[5, a]
								if sel_edificio.modo != (2 + a) and array_length(edificio_count[b]) > 0 and (dia / 360) >= edificio_anno[b] and draw_boton(room_width - 40, pos, edificio_nombre[b]){
									sel_edificio.modo = 2 + a
									close_show()
								}
							}
					}
					if draw_menu(room_width - 30, pos, "Cambiar modo", 3){
						if sel_edificio.modo != 0 and draw_boton(room_width - 40, pos, "Educación Profesional"){
							sel_edificio.servicio_tarifa = 3
							set_escuela_servicio_max(4, sel_edificio)
							set_escuela_clientes_max(20, sel_edificio)
							sel_edificio.modo = 0
							set_calidad_servicio(sel_edificio)
							close_show()
						}
						if sel_edificio.modo != 1 and draw_boton(room_width - 40, pos, "Educación Técnica"){
							sel_edificio.servicio_tarifa = 2
							set_escuela_servicio_max(3.2, sel_edificio)
							set_escuela_clientes_max(30, sel_edificio)
							sel_edificio.modo = 1
							set_calidad_servicio(sel_edificio)
							close_show()
						}
						var flag = false, a
						for(a = 0; a < array_length(edificio_categoria[5]); a++)
							if array_length(edificio_count[edificio_categoria[5, a]]) > 0{
								flag = true
								break
							}
						if flag and draw_boton(room_width - 40, pos, "Investigación"){
							sel_edificio.servicio_tarifa = 2
							set_escuela_servicio_max(3.2, sel_edificio)
							set_escuela_clientes_max(20, sel_edificio)
							sel_edificio.modo = 2 + a
							close_show()
						}
					}
						
				}
				pos += 20
			}
			//Información escuelas / consultas
			if edificio_es_escuela[index] or edificio_es_medico[index]{
				for(var a = 0; a < sel_edificio.servicio_max; a++){
					if a < array_length(sel_edificio.clientes){
						var persona = sel_edificio.clientes[a]
						if draw_sprite_boton(spr_icono, 12 + (persona.sexo), room_width - 25 - 25 * (a mod 10), pos + 25 * floor(a / 10),,,, name(persona))
							select(,, persona)
					}
					else
						draw_sprite(spr_icono, 0, room_width - 25 - 25 * (a mod 10), pos + 25 * floor(a / 10))
				}
				pos += 25 * ceil(sel_edificio.servicio_max / 10)
			}
			//Información edificios de ocio
			if edificio_es_ocio[index] or edificio_es_iglesia[index]
				draw_text_pos(room_width - 20, pos, $"{sel_edificio.count} visitante{sel_edificio.count = 1 ? "" : "s"} este mes")
			//Conexión al agua potable
			if (edificio_bool_agua[index] or mejora_requiere_agua) and (dia / 360) > 50 and not sel_edificio.privado{
				var b = 0
				for(var a = 0; a < array_length(edificio_count[index]); a++)
					b += (not edificio_count[index, a].agua and not edificio_count[index, a].privado)
				if not sel_edificio.agua and draw_boton(room_width - 20, pos, keyboard_check(vk_shift) ? $"Conectar agua potable ${200 * b} ({b})" : "Conectar agua potable $200"){
					if keyboard_check(vk_lshift){
						for(var a = 0; a < array_length(edificio_count[index]); a++)
							if not edificio_count[index, a].privado
								add_tuberias(edificio_count[index, a])
					}
					else
						add_tuberias(sel_edificio)
				}
				if sel_edificio.agua
					draw_text_pos(room_width - 20, pos, $"Consumiendo {sel_edificio.agua_consumo} agua")
			}
			//Coneccion eléctrica
			if (edificio_bool_energia[index] or mejora_requiere_energia) and (dia / 360) > 90 and not sel_edificio.privado{
				var b = 0
				for(var a = 0; a < array_length(edificio_count[index]); a++)
					b += (not edificio_count[index, a].energia and not edificio_count[index, a].privado)
				if not sel_edificio.energia and draw_boton(room_width - 20, pos, keyboard_check(vk_lshift) ? $"Conectar cableado público ${100 * b} ({b})" : "Conectar cablado público $100")
					if keyboard_check(vk_lshift){
						for(var a = 0; a < array_length(edificio_count[index]); a++)
							if not edificio_count[index, a].privado
								add_energia(edificio_count[index, a])
					}
					else
						add_energia(sel_edificio)
				if sel_edificio.energia
					draw_text_pos(room_width - 20, pos, $"Consumiendo {sel_edificio.energia_consumo} energía")
			}
			//Almacen / edificios cercanos
			if not sel_edificio.privado{
				var flag = false
				for(var a = 0; a < array_length(recurso_nombre); a++)
					if floor(sel_edificio.almacen[a]) != 0{
						flag = true
						break
					}
				if flag and draw_menu(room_width - 20, pos, "Almacen", 1, , false){
					text = ""
					for(var a = 0; a < array_length(recurso_nombre); a++)
						if floor(sel_edificio.almacen[a]) != 0
							text += $"{text != "" ? "\n" : ""}{recurso_nombre[a]}: {floor(sel_edificio.almacen[a])}"
					draw_text_pos(room_width - 40, pos, text != "" ? text : "Sin recursos")
				}
				if edificio_es_casa[index]{
					for(var a = 0, b = 0; a < array_length(educacion_nombre); a++)
						b += array_length(sel_edificio.trabajos_cerca[a])
					if draw_menu(room_width - 20, pos, $"{b} trabajos cerca", 0)
						for(var b = 0; b < array_length(educacion_nombre); b++)
							for(var a = 0; a < array_length(sel_edificio.trabajos_cerca[b]); a++){
								var temp_edificio = sel_edificio.trabajos_cerca[b, a]
								if draw_boton(room_width - 40, pos, temp_edificio.nombre){
									sel_edificio = temp_edificio
									break
								}
						}
					}
				if edificio_es_trabajo[index] and draw_menu(room_width - 20, pos, $"{array_length(sel_edificio.casas_cerca)} casas cerca", 0)
					for(var a = 0; a < array_length(sel_edificio.casas_cerca); a++){
						var temp_edificio = sel_edificio.casas_cerca[a]
						if draw_boton(room_width - 40, pos, temp_edificio.nombre){
							sel_edificio = temp_edificio
							break
						}
					}
			}
			//Privatizar / Estatizar
			if not edificio_estatal[index] and not sel_edificio.huelga{
				pos += 20
				var complex_2 = valorizar_edificio(sel_edificio)
				var temp_precio = complex_2.int, temp_text = complex_2.str
				if sel_edificio.privado{
					temp_precio = floor(temp_precio * 1.1)
					if draw_boton(room_width, pos, $"Estatizar Edificio -${temp_precio}") and dinero >= temp_precio{
						var empresa = sel_edificio.empresa
						mes_estatizacion[current_mes] += temp_precio
						dinero -= temp_precio
						dinero_privado += temp_precio
						empresa.dinero += temp_precio
						inversion_privada -= temp_precio
						sel_edificio.privado = false
						ds_grid_set_region(zona_privada, x, y, x + width - 1, y + height - 1, false)
						ds_grid_set_region(zona_empresa, x, y, x + width - 1, y + height - 1, null_empresa)
						for(var a = 0; a < array_length(empresa.terreno); a++){
							var complex = empresa.terreno[a]
							if complex.a >= x and complex.a < x + width and complex.b >= y and complex.b < y + height
								array_delete(empresa.terreno, a--, 1)
						}
					}
				}
				else{
					temp_precio = floor(temp_precio * 0.9)
					if draw_boton(room_width, pos, $"Privatizar Edificio +${temp_precio}"){
						array_push(edificios_a_la_venta, {
							edificio : sel_edificio,
							precio : temp_precio,
							width : width,
							height : height,
							estatal : true,
							empresa : null_edificio})
						set_paro(true, sel_edificio)
						sel_edificio.venta = true
					}
					
				}
				draw_text_pos(room_width - 20, pos, temp_text)
			}
			if not sel_edificio.privado{
				pos += 20
				draw_text_pos(room_width, pos, $"Balance: ${floor(sel_edificio.ganancia)}")
			}
			//Abrir ministerio de economía
			if var_edificio_nombre = "Muelle"{
				if draw_boton(room_width, pos, "Abrir ministerio de economía"){
					sel_build = true
					sel_info = false
					ministerio = 5
				}
			}
			else if draw_boton(room_width, pos, $"Muelle más cercano a {round(sel_edificio.distancia_muelle_cercano)}")
				sel_edificio = sel_edificio.muelle_cercano
			pos += 80
			//Destruir edificio
			pos += 40
			if not sel_edificio.privado and ((var_edificio_nombre != "Muelle" and var_edificio_nombre != "Oficina de Construcción") or array_length(edificio_count[index]) > 1) and draw_boton(room_width, pos, "Destruir Edificio", , not sel_edificio.huelga)
				destroy_edificio(sel_edificio)
		}
		draw_set_alpha(1)
	}
	//Información familias
	else if sel_tipo = 1 and sel_familia != null_familia{
		draw_text_pos(room_width, pos, name_familia(sel_familia))
		pos += 20
		if sel_familia.padre != null_persona and draw_boton(room_width - 20, pos, $"Padre: {name(sel_familia.padre)}")
			select(,, sel_familia.padre)
		if sel_familia.madre != null_persona and draw_boton(room_width - 20, pos, $"Madre: {name(sel_familia.madre)}")
			select(,, sel_familia.madre)
		draw_text_pos(room_width - 20, pos, (array_length(sel_familia.hijos) > 0) ? "Hijos" : "Sin hijos")
		for(var a = 0; a < array_length(sel_familia.hijos); a++)
			if draw_boton(room_width - 40, pos, name(sel_familia.hijos[a]))
				select(,, sel_familia.hijos[a])
		pos += 20
		if sel_familia.casa = homeless
			draw_text_pos(room_width - 20, pos, "Sin hogar")
		else if draw_boton(room_width - 20, pos, $"Vivienda: {sel_familia.casa.nombre}")
			select(sel_familia.casa)
		draw_text_pos(room_width - 20, pos, $"Sueldo familiar ${sel_familia.sueldo}")
		draw_text_pos(room_width - 20, pos, $"Riqueza familiar ${sel_familia.riqueza}")
	}
	//Información personas
	else if sel_tipo = 2 and sel_persona != null_persona{
		draw_text_pos(room_width, pos, name(sel_persona))
		if draw_sprite_boton(spr_icono, 10 + sel_persona.favorito, room_width - 300, pos - last_height){
			if sel_persona.favorito
				array_remove(personas_favoritas, sel_persona)
			else
				array_push(personas_favoritas, sel_persona)
			sel_persona.favorito = not sel_persona.favorito
		}
		if sel_persona.preso
			draw_text_pos(room_width - 20, pos, $"Pres{sel_persona.sexo ? "a" : "o"}")
		draw_text_pos(room_width - 20, pos, $"Edad: {sel_persona.edad} ({fecha(sel_persona.cumple, false)})")
		draw_text_pos(room_width - 20, pos, $"Nacionalidad: {sel_persona.nacionalidad.nombre}")
		if draw_boton(room_width - 20, pos, name_familia(sel_persona.familia))
			select(, sel_persona.familia)
		pos += 10
		if sel_persona.familia.casa = homeless
			draw_text_pos(room_width - 20, pos, "Sin hogar")
		else if draw_boton(room_width - 20, pos, $"Vive en: {sel_persona.familia.casa.nombre}")
			select(sel_persona.familia.casa)
		if sel_persona.trabajo = null_edificio
			draw_text_pos(room_width - 20, pos, "Sin trabajo")
		else if draw_boton(room_width - 20, pos, $"Trabaja en: {sel_persona.trabajo.nombre}")
			select(sel_persona.trabajo)
		draw_text_pos(room_width - 20, pos, $"Educación: {educacion_nombre[floor(sel_persona.educacion)]}")
		if sel_persona.escuela != null_edificio and draw_boton(room_width - 40, pos, $"Estudiando en {sel_persona.escuela.nombre}")
			select(sel_persona.escuela)
		else if sel_persona.es_hijo
			draw_text_pos(room_width - 40, pos, "Sin escolarizar")
		if sel_persona.medico != null_edificio{
			draw_text_pos(room_width - 20, pos, $"Enferm{sel_persona.sexo ? "a" : "o"}")
			if sel_persona.medico = desausiado
				draw_text_pos(room_width - 40, pos, "Sin tratamiento")
			else if draw_boton(room_width - 40, pos, $"Tratándose en {sel_persona.medico.nombre}")
				select(sel_persona.medico)
		}
		if sel_persona.religion
			draw_text_pos(room_width - 20, pos, "Creyente")
		else
			draw_text_pos(room_width - 20, pos, $"Ate{sel_persona.sexo ? "a" : "o"}")
		if elecciones and sel_persona.candidato{
			var a = 0, b = 0, flag = false, edificio
			for(a = 0; a < array_length(candidatos); a++)
				if sel_persona = candidatos[a]
					break
			draw_text_pos(room_width, pos, $"Candidat{sel_persona.sexo ? "a" : "o"} electoral (~{floor(100 * candidatos_votos[a + 1] / candidatos_votos_total)}%)")
			for(b = 0; b < array_length(edificio_count[43]); b++){
				edificio = edificio_count[43, b]
				if edificio.modo = -1{
					flag = true
					break
				}
			}
			if flag and draw_boton(room_width - 20, pos, $"Difamar ({edificio.nombre})"){
				edificio.modo = a
				set_calidad_servicio(edificio)
			}
		}
		if not sel_persona.es_hijo and array_length(edificio_count[34]) > 0{
			if not sel_persona.preso and draw_boton(room_width - 20, pos, $"Arrestar opositor{sel_persona.sexo ? "a" : ""} $ 500"){
				dinero -= 500
				mes_mantenimiento[current_mes] += 500
				if elecciones and sel_persona.candidato{
					var a
					for(a = 0; a < array_length(candidatos); a++)
						if sel_persona = candidatos[a]
							break
					for(var b = 0; b < array_length(personas); b++){
						var persona = personas[b]
						persona.felicidad_temporal -= 25
						if voto_persona(persona) = a
							persona.felicidad_temporal -= 40
					}
					credibilidad_financiera = clamp(credibilidad_financiera - 1, 1, 10)
				}
				arrestar_persona(sel_persona, 24)
			}
			if ley_eneabled[11] and draw_boton(room_width - 20, pos, $"Silenciar opositor{sel_persona.sexo ? "a" : ""} $1000"){
				dinero -= 1000
				mes_mantenimiento[current_mes] += 1000
				if sel_persona.pareja != null_persona
					sel_persona.pareja.felicidad_temporal -= 50
				if sel_persona.familia.padre != null_persona
					sel_persona.familia.padre.felicidad_temporal -= 50
				if sel_persona.familia.madre != null_persona
					sel_persona.familia.madre.felicidad_temporal -= 50
				for(var a = 0; a < array_length(sel_persona.familia.hijos); a++)
					sel_persona.familia.hijos[a].felicidad_temporal -= 50
				if not in(sel_persona.trabajo.tipo, null_edificio, jubilado, delincuente, prostituta)
					for(var a = 0; a < array_length(sel_persona.trabajo.trabajadores); a++)
						sel_persona.trabajo.trabajadores[a].felicidad_temporal -= 50
				if elecciones and sel_persona.candidato{
					var a
					for(a = 0; a < array_length(candidatos); a++)
						if sel_persona = candidatos[a]
							break
					for(var b = 0; b < array_length(personas); b++){
						var persona = personas[b]
						persona.felicidad_temporal -= 50
						if voto_persona(persona) = a
							persona.felicidad_temporal -= 50
					}
					credibilidad_financiera = clamp(floor(credibilidad_financiera / 2), 1, 10)
				}
				destroy_persona(sel_persona)
				sel_persona = null_persona
				sel_info = false
			}
		}
		pos += 10
		if draw_menu(room_width, pos, $"Felicidad: {sel_persona.felicidad}", 0){
			draw_text_pos(room_width - 20, pos, $"Vivienda: {sel_persona.familia.felicidad_vivienda}")
			if not sel_persona.es_hijo or (ley_eneabled[2] and sel_persona.trabajo != null_edificio)
				draw_text_pos(room_width - 20, pos, $"Trabajo: {sel_persona.felicidad_trabajo}")
			draw_text_pos(room_width - 20, pos, $"Salud: {sel_persona.felicidad_salud}")
			if sel_persona.es_hijo
				draw_text_pos(room_width - 20, pos, $"Educación: {sel_persona.felicidad_educacion}")
			draw_text_pos(room_width - 20, pos, $"Alimentación: {sel_persona.familia.felicidad_alimento}")
			draw_text_pos(room_width - 20, pos, $"Entretenimiento: {sel_persona.felicidad_ocio}")
			draw_text_pos(room_width - 20, pos, $"Transporte: {sel_persona.felicidad_transporte}")
			if sel_persona.religion
				draw_text_pos(room_width - 20, pos, $"Religión: {sel_persona.felicidad_religion}")
			if not sel_persona.es_hijo
				draw_text_pos(room_width - 20, pos, $"Legislación: {sel_persona.felicidad_ley}")
			draw_text_pos(room_width - 20, pos, $"Delincuencia: {sel_persona.felicidad_crimen}")
			draw_text_pos(room_width - 20, pos, $"Eventos recientes: {sel_persona.felicidad_temporal}")
		}
		if draw_menu(room_width, pos, "Opinión política", 1){
			draw_text_pos(room_width - 20, pos, politica_economia_nombre[sel_persona.politica_economia])
			draw_text_pos(room_width - 20, pos, politica_sociocultural_nombre[sel_persona.politica_sociocultural])
		}
		draw_relacion(room_width - 150, room_height - 80, sel_persona.relacion)
	}
	//Información construcciones
	else if sel_tipo = 3 and sel_construccion != null_construccion{
		x = sel_construccion.x
		y = sel_construccion.y
		var index = sel_construccion.id, width = sel_construccion.width, height = sel_construccion.height
		draw_text_pos(room_width, pos, edificio_nombre[index])
		draw_text_pos(room_width - 20, pos, $"Progreso: {floor(100 * (sel_construccion.tiempo_max - sel_construccion.tiempo) / sel_construccion.tiempo_max)}%")
		if not sel_construccion.privado{
			if cola_construccion[0] != sel_construccion and draw_boton(room_width - 20, pos, "Priorizar construcción"){
				array_remove(cola_construccion, sel_construccion, "Priorizar una construcción")
				array_insert(cola_construccion, 0, sel_construccion)
			}
			if draw_boton(room_width - 20, pos, $"Terminar edificio ${edificio_precio[index]}") and dinero >= edificio_precio[index]{
				dinero -= edificio_precio[index]
				mes_construccion[current_mes] += edificio_precio[index]
				acelerar_edificio(sel_construccion)
			}
			if draw_boton(room_width - 20, pos, "Cancelar construcción"){
				ds_grid_set_region(construccion_reservada, x, y, x + width - 1, y + height - 1, false)
				ds_grid_set(bool_draw_construccion, x, y, false)
				ds_grid_set_region(draw_construccion, x, y, x + width - 1, y + height - 1, null_construccion)
				array_remove(cola_construccion, sel_construccion)
				if array_length(cola_construccion) = 0 and ley_eneabled[6]
					for(var a = 0; a < array_length(edificio_count[20]); a++){
						var edificio = edificio_count[20, a]
						set_paro(true, edificio)
						while array_length(edificio.trabajadores) > 0
							cambiar_trabajo(edificio.trabajadores[0], null_edificio)
					}
				dinero += sel_construccion.precio
				mes_entrada_micelaneo[current_mes] += sel_construccion.precio
				sel_construccion = null_construccion
				sel_info = false
			}
		}
		else{
			draw_text_pos(room_width - 20, pos, "PRIVADO")
			if draw_boton(room_width - 20, pos, sel_construccion.empresa.nombre){
				sel_info = false
				sel_build = true
				ministerio = 7
				close_show()
				show[array_get_index(empresas, sel_construccion.empresa)] = true
			}
		}
	}
	//Información terrenos a la venta
	else if sel_tipo = 4 and sel_terreno != null_terreno{
		x = sel_terreno.x
		y = sel_terreno.y
		var width = sel_terreno.width, height = sel_terreno.height
		draw_text_pos(room_width, pos, "Terreno a la venta")
		pos += 20
		draw_text_pos(room_width - 20, pos, $"{sel_terreno.width}x{sel_terreno.height} terrenos")
		draw_text_pos(room_width - 20, pos, "Permisos de construcción:")
		if not show[0]{
			for(var a = 0; a < array_length(edificio_categoria); a++)
				if zona_privada_permisos[# x, y][a]
					draw_text_pos(room_width - 40, pos, edificio_categoria_nombre[a])
		}
		else
			for(var a = 0; a < array_length(edificio_categoria); a++)
				if draw_boton(room_width - 40, pos, (zona_privada_permisos[# x, y][a] ? "-" : "+") + edificio_categoria_nombre[a])
					array_set(zona_privada_permisos[# x, y], a, not zona_privada_permisos[# x, y][a])
		if not sel_terreno.privado
			draw_menu(room_width - 20, pos, "Cambiar permisos", 0)
		pos += 20
		if not sel_terreno.privado{
			if draw_boton(room_width - 20, pos, "Cancelar venta"){
				var a = x + width - 1, b = y + height - 1
				ds_grid_set_region(zona_privada, x, y, a, b, false)
				ds_grid_set_region(zona_privada_venta, x, y, a, b, false)
				ds_grid_set_region(zona_privada_permisos, x, y, a, b, [false, false, false, false, false, false])
				ds_grid_set_region(zona_privada_venta_terreno, x, y, a, b, null_terreno)
				array_remove(terrenos_venta, sel_terreno)
				sel_terreno = null_terreno
				sel_info = false
			}
			if width * height > 1{
				var temp_division = (width > height)
				if draw_boton(room_width - 20, pos, "Dividir terreno",,, function(inputs){
					var terreno = inputs[0], temp_division = inputs[1]
					draw_set_alpha(0.5)
					draw_set_color(c_red)
					if temp_division
						draw_rombo_coord(terreno.x, terreno.y, floor(terreno.width / 2), terreno.height, false)
					else
						draw_rombo_coord(terreno.x, terreno.y, terreno.width, floor(terreno.height / 2), false)
					draw_set_color(c_black)
					draw_set_alpha(1)
				}, [sel_terreno, temp_division]){
					var new_terreno = null_terreno
					if temp_division{
						new_terreno = {
							x : sel_terreno.x + floor(sel_terreno.width / 2),
							y : sel_terreno.y,
							width : ceil(sel_terreno.width / 2),
							height : sel_terreno.height,
							privado : false,
							empresa : null_empresa
						}
						sel_terreno.width = floor(width / 2)
					}
					else{
						new_terreno = {
							x : sel_terreno.x,
							y : sel_terreno.y + floor(sel_terreno.height / 2),
							width : sel_terreno.width,
							height : ceil(sel_terreno.height / 2),
							privado : false,
							empresa : null_empresa
						}
						sel_terreno.height = floor(height / 2)
					}
					c = new_terreno.x
					d = new_terreno.y
					ds_grid_set_region(zona_privada_venta_terreno, x, y, x + new_terreno.width - 1, y + new_terreno.height - 1, new_terreno)
					array_push(terrenos_venta, new_terreno)
				}
			}
		}
		draw_set_alpha(0.5)
		draw_set_color(c_white)
		draw_rombo_coord(x, y, width, height, false)
		draw_rombo_coord(x, y, width, height, true)
		draw_set_color(c_black)
		draw_set_alpha(1)
	}
	//Información carreteras
	else if sel_tipo = 5 and sel_carretera != null_carretera{
		draw_text_pos(room_width, pos, $"Carretera {sel_carretera.index}")
		pos += 20
		draw_text_pos(room_width - 20, pos, $"Taxis: {sel_carretera.taxis}")
		draw_set_color(c_red)
		draw_set_alpha(0.5)
		for(var a = 0; a < array_length(sel_carretera.tramos); a++){
			var temp_array = sel_carretera.tramos[a]
			draw_rombo_coord(temp_array[0], temp_array[1], 1, 1, false)
		}
		draw_set_color(c_blue)
		for(var a = 0; a < array_length(sel_carretera.edificios); a++){
			var edificio = sel_carretera.edificios[a]
			draw_rombo_coord(edificio.x, edificio.y, edificio.width, edificio.height, false)
		}
		draw_set_color(c_black)
		draw_set_alpha(1)
	}
	draw_set_halign(fa_left)
}
//Movimiento de la cámara
if (not tutorial_bool or tutorial_camara[tutorial]) and not menu{
	if keyboard_check(vk_lcontrol){
		if mouse_wheel_up() and tile_width < 64{
			var center_x = ((room_width / 2 + xpos) / tile_width + (room_height / 2 + ypos) / tile_height) / 2
			var center_y = ((room_height / 2 + ypos) / tile_height - (room_width / 2 + xpos) / tile_width) / 2
			tile_width *= power(2, 0.1)
			tile_height *= power(2, 0.1)
			xpos = (center_x - center_y) * tile_width - room_width / 2
			ypos = (center_x + center_y) * tile_height - room_height / 2
		}
		if mouse_wheel_down() and tile_width > 8{
			var center_x = ((room_width / 2 + xpos) / tile_width + (room_height / 2 + ypos) / tile_height) / 2
			var center_y = ((room_height / 2 + ypos) / tile_height - (room_width / 2 + xpos) / tile_width) / 2
			tile_width /= power(2, 0.1)
			tile_height /= power(2, 0.1)
			xpos = (center_x - center_y) * tile_width - room_width / 2
			ypos = (center_x + center_y) * tile_height - room_height / 2
		}
	}
	if mouse_x < 20 or keyboard_check(ord("A"))
		xpos = max(-ysize * tile_width, xpos - (4 + 12 * keyboard_check(vk_lshift)))
	if mouse_y < 20 or keyboard_check(ord("W"))
		ypos = max(0, ypos - (4 + 12 * keyboard_check(vk_lshift)))
	if mouse_x > room_width - 20 or keyboard_check(ord("D"))
		xpos = min(xsize * tile_width - room_width, xpos + (4 + 12 * keyboard_check(vk_lshift)))
	if mouse_y > room_height - 20 or keyboard_check(ord("S"))
		ypos = min((xsize + ysize) * tile_height - room_height, ypos + (4 + 12 * keyboard_check(vk_lshift)))
	min_camx = max(0, floor((xpos / tile_width + ypos / tile_height) / 2))
	min_camy = max(0, floor((ypos / tile_height - (xpos + room_width) / tile_width) / 2))
	max_camx = min(xsize, ceil(((room_width + xpos) / tile_width + (room_height + ypos) / tile_height) / 2))
	max_camy = min(ysize, ceil(((room_height + ypos) / tile_height - xpos / tile_width) / 2))
}
//Pasar día
step += velocidad * (not menu and not getstring)
if (keyboard_check(vk_space) or step >= 60){
	step = 0
	repeat(1 + 29 * (keyboard_check(vk_space) and keyboard_check(vk_lshift))){
		dia++
		current_mes = floor(dia / 30) mod 12
		var dia_de_anno = (dia mod 360), dia_de_mes = (dia mod 30)
		#region ajuste eventos diarios
			radioemisoras -= dia_radioemisoras[dia_de_mes]
			dia_radioemisoras[dia_de_mes] = 0
			television -= dia_television[dia_de_mes]
			dia_television[dia_de_mes] = 0
			energia_input -= dia_energia[dia_de_mes]
			dia_energia[dia_de_mes] = 0
			agua_input -= dia_agua[dia_de_mes]
			dia_agua[dia_de_mes] = 0
			naval -= dia_naval[dia_de_mes]
			dia_naval[dia_de_mes] = 0
			for(var a = 0; a < array_length(carreteras); a++){
				var carretera = carreteras[a]
				carretera.taxis -= carretera.dia_taxis[dia_de_mes]
				carretera.dia_taxis[dia_de_mes] = 0
			}
		#endregion
		//Día nacional
		if pais_dia[dia_de_anno] > 0 and array_contains(pais_current, pais_dia[dia_de_anno]){
			var pais = pais_dia[dia_de_anno], industria = pais.industria, b = 0
			c = 0
			text = $"{fecha(dia)} {pais.nombre}: ["
			for(var a = 0; a < array_length(recurso_nombre); a++){
				if array_contains(recurso_prima, a)
					b = pais.recursos[a] + random_range(-0.02 * industria, 0.02 * (1 - industria))
				else
					b = pais.recursos[a] + random_range(-0.02 * (1 - industria), 0.02 * industria)
				pais.recursos[a] = b
				c += abs(b)
			}
			for(var a = 0; a < array_length(recurso_nombre); a++){
				b = pais.recursos[a] / c
				pais.recursos[a] = b
				text += $"{b}, "
			}
			if debug
				show_debug_message(text + "]")
		}
		//Actualizar exigencias
		for(var a = 0; a < array_length(exigencia_nombre); a++)
			if exigencia_pedida[a] and dia = exigencia[a].expiracion{
				if a = 2
					cumplir_exigencia(2)
				else
					fallar_exigencia(a)
			}
		//Avanzar en construcciones
		if array_length(cola_construccion) > 0{
			var b = 0
			for(var a = 0; a < array_length(edificio_count[20]); a++){
				var edificio = edificio_count[20, a]
				b += round(array_length(edificio.trabajadores) * (0.8 + 0.1 * edificio.presupuesto) * edificio.eficiencia * edificio_experiencia[20] * (edificio.energia ? 1 + min(1, energia_input / energia_output) : 1))
			}
			var next_build = cola_construccion[0]
			next_build.tiempo -= b
			//Edificio_terminado
			if next_build.tiempo <= 0
				acelerar_edificio(next_build)
		}
		//Mover recursos
		if array_length(encargos) > 0{
			c = 0
			var rss_in = [], rss_out = []
			for(var a = 0; a < array_length(edificio_count[22]); a++){
				var edificio = edificio_count[22, a]
				c += 3 * array_length(edificio.trabajadores) * (0.8 + 0.1 * edificio.presupuesto) * edificio.eficiencia * edificio_experiencia[22] * (edificio.energia ? 1 + min(1, energia_input / energia_output) : 1)
			}
			for(var a = 0; a < array_length(edificio_count[13]); a++){
				var edificio = edificio_count[13, a]
				if not (current_mes mod 6) = (edificio.mes_creacion mod 6)
					c += 2 * array_length(edificio.trabajadores) * (0.8 + 0.1 * edificio.presupuesto) * edificio.eficiencia * edificio_experiencia[22] * (edificio.energia ? 1 + min(1, energia_input / energia_output) : 1)
			}
			c = round(c)
			for(var a = 0; a < array_length(recurso_nombre); a++){
				array_push(rss_in, false)
				array_push(rss_out, false)
			}
			for(var a = 0; a < array_length(encargos); a++){
				var next_encargo = encargos[a], edificio = next_encargo.edificio.muelle_cercano, b = 0, distance = (10 + next_encargo.edificio.distancia_muelle_cercano) / 10
				//Encargo hacia el Muelle
				if next_encargo.cantidad > 0 and not rss_in[next_encargo.recurso]{
					rss_in[next_encargo.recurso] = true
					b = min(floor(c / distance), next_encargo.cantidad)
					next_encargo.cantidad -= b
					if b >= recurso_construccion[next_encargo.recurso]{
						b -= recurso_construccion[next_encargo.recurso]
						recurso_construccion[next_encargo.recurso] = 0
					}
					else{
						recurso_construccion[next_encargo.recurso] -= b
						b = 0
					}
					edificio.almacen[next_encargo.recurso] += b
					if next_encargo.cantidad = 0
						array_delete(encargos, a--, 1)
					c -= b * distance
					if c < 1
						break
				}
				//Encargo hacia la Fábrica
				if next_encargo.cantidad < 0 and not rss_out[next_encargo.recurso]{
					rss_out[next_encargo.recurso] = true
					b = min(c, -next_encargo.cantidad, edificio.almacen[next_encargo.recurso])
					next_encargo.cantidad += b
					edificio.almacen[next_encargo.recurso] -= b
					next_encargo.edificio.almacen[next_encargo.recurso] += b
					next_encargo.edificio.pedido[next_encargo.recurso] -= b
					if next_encargo.cantidad = 0
						array_delete(encargos, a--, 1)
					c -= b
					if c = 0
						break
				}
			}
		}
		//Random tick
		repeat(max(xsize * ysize / 10000, 1)){
			mx = irandom(xsize - 1)
			my = irandom(ysize - 1)
			if bosque[# mx, my]
				array_set(bosque_madera[mx], my, min(200, bosque_madera[mx, my] + 20, bosque_max[mx, my]))
		}
		//Incendios
		if dia > 3650 and random(1) < 0.005 and array_length(edificios) > 0{
			var edificio = array_pick(edificios)
			if edificio.seguro_fuego = 0 and edificio_nombre[edificio.tipo] != "Estación de Bomberos" and random(1) < 0.05 + edificio.trabajo_riesgo{
				var b = 0
				for(var a = 0; a < array_length(edificio.trabajadores); a++)
					if random(1) < 0.2{
						b++
						destroy_persona(edificio.trabajadores[a--],, "Muerto en un incendio")
						mes_muertos_accidentes[current_mes]++
					}
				for(var a = 0; a < array_length(edificio.familias); a++){
					var familia = edificio.familias[a]
					c = mes_muertos_accidentes[current_mes]
					for_familia(function(persona = null_persona){
						if random(1) < 0.2{
							destroy_persona(persona,, "Muerto en un incendio")
							mes_muertos_accidentes[current_mes]++
						}
					}, familia)
					b += mes_muertos_accidentes[current_mes] - c
				}
				if edificio_nombre[edificio.tipo] = "Prisión"
					while array_length(edificio.clientes) > 0
						destroy_persona(edificio.clientes[0], true, "Preso muerto en incendio")
				add_noticia("Incendio", $"Se ha quemado {edificio.nombre}{b = 0 ? "" : ", ha"}{b = 1 ? "" : "n"} muerto {b} persona{b = 1 ? "" : "s"}")
				c = edificio.x + edificio.width
				d = edificio.y + edificio.height
				ds_grid_set_region(escombros, edificio.x, edificio.y, c - 1, d - 1, true)
				for(var a = edificio.x; a < c; a++)
					for(b = edificio.y; b < d; b++)
						array_set(chunk_update[floor(a / 16)], floor(b / 16), true)
				world_update = true
				destroy_edificio(edificio)
			}
		}
		//Robo de pescado
		if random(1) < 0.0002 * pirateria and array_length(zonas_pesca) > 0{
			if random(sqrt(naval)) > 10
				pirateria = max(--pirateria, 10)
			else{
				pirateria = min(++pirateria, 100)
				var zona_pesca = array_pick(zonas_pesca)
				zona_pesca.cantidad -= 100 + irandom_range(dia / 5, dia / 3)
				zona_pesca_agotada(zona_pesca)
			}
		}
		//Eventos mensuales
		if dia_mes(dia) = 0{
			mes_muertos_enfermos[current_mes] = 0
			mes_emigrantes[current_mes] = 0
			mes_muertos_viejos[current_mes] = 0
			mes_muertos_accidentes[current_mes] = 0
			mes_muertos_asesinados[current_mes] = 0
			mes_inmigrantes[current_mes] =0
			mes_nacimientos[current_mes] = 0
			mes_muertos_inanicion[current_mes] = 0
			mes_renta[current_mes] = 0
			mes_mantenimiento[current_mes] = 0
			mes_sueldos[current_mes] = 0
			mes_tarifas[current_mes] = 0
			mes_exportaciones[current_mes] = 0
			mes_herencia[current_mes] = 0
			mes_construccion[current_mes] = 0
			mes_importaciones[current_mes] = 0
			mes_compra_interna[current_mes] = 0
			mes_venta_interna[current_mes] = 0
			mes_privatizacion[current_mes] = 0
			mes_estatizacion[current_mes] = 0
			mes_impuestos[current_mes] = 0
			mes_accidentes[current_mes] = 0
			mes_investigacion[current_mes] = 0
			mes_venta_comida[current_mes] = 0
			mes_entrada_micelaneo[current_mes] = 0
			mes_salida_micelaneo[current_mes] = 0
			mes_comida_privada[current_mes] = 0
			//Actualizar precios de recursos y tratados comerciales
			for(var a = 0; a < array_length(recurso_nombre); a++){
				array_set(mes_exportaciones_recurso[current_mes], a, 0)
				array_set(mes_exportaciones_recurso_num[current_mes], a, 0)
				array_set(mes_importaciones_recurso[current_mes], a, 0)
				array_set(mes_importaciones_recurso_num[current_mes], a, 0)
				array_set(mes_compra_recurso[current_mes], a, 0)
				array_set(mes_compra_recurso_num[current_mes], a, 0)
				array_set(mes_venta_recurso[current_mes], a, 0)
				array_set(mes_venta_recurso_num[current_mes], a, 0)
				if recurso_anno[a] = 0 or recurso_anno[a] <= floor(dia / 360) + 5
					recurso_precio[a] *= random_range(0.95, 1.05)
				else if recurso_anno[a] <= floor(dia / 360)
					recurso_precio[a] *= random_range(0.95, 1)
				array_shift(recurso_historial[a])
				array_push(recurso_historial[a], recurso_precio[a])
				for(var b = 0; b < array_length(recurso_tratados_venta[a]); b++){
					var tratado = recurso_tratados_venta[a, b]
					tratado.tiempo--
					if tratado.tiempo = 0{
						add_noticia("Tratado fallido", $"No has podido cumplir el tratado de exportar {tratado.cantidad} de {recurso_nombre[tratado.recurso]} a {tratado.pais.nombre}")
						tratado.pais.relacion--
						array_delete(recurso_tratados_venta[a], b--, 1)
						credibilidad_financiera = clamp(credibilidad_financiera - 1, 1, 10)
						tratados_num--
					}
				}
				for(var b = 0; b < array_length(recurso_tratados_compra[a]); b++){
					var tratado = recurso_tratados_compra[a, b]
					tratado.tiempo--
					if tratado.tiempo = 0{
						add_noticia("Tratado fallido", $"No has podido cumplir el tratado de importar {tratado.cantidad} de {recurso_nombre[tratado.recurso]} a {tratado.pais.nombre}")
						tratado.pais.relacion--
						array_delete(recurso_tratados_compra[a], b--, 1)
						credibilidad_financiera = clamp(credibilidad_financiera - 1, 1, 10)
						tratados_num--
					}
				}
			}
			for(var a = 0; a < array_length(ley_nombre); a++)
				if ley_tiempo[a] > 0
					ley_tiempo[a]--
			generar_tratado()
			if array_length(tratados_ofertas) > 20
				array_shift(tratados_ofertas)
			//Inmigración
			if ley_eneabled[1]
				repeat(ley_eneabled[23] + (irandom(felicidad_total) > felicidad_minima or irandom(credibilidad_financiera) > 7 or dia < 360)){
					var b = 0, origen = null_pais
					if brandom(){
						for(var a = 0; a < array_length(pais_current); a++)
							b += max(pais_current[a].relacion, 0)
						if b > 0{
							b = irandom(b - 1)
							for(var a = 0; a < array_length(pais_current); a++)
								if max(pais_current[a].relacion, 0) <= b
									b -= max(pais_current[a].relacion, 0)
								else{
									origen = pais_current[a]
									break
								}
						}
					}
					var familia = add_familia(origen)
					if not ley_eneabled[23] or brandom(){
						if familia.padre != null_persona and brandom(){
							buscar_trabajo(familia.padre)
							buscar_casa(familia.padre)
						}
						if familia.madre != null_persona and brandom(){
							buscar_trabajo(familia.madre)
							buscar_casa(familia.madre)
						}
						for(var a = 0; a < array_length(familia.hijos); a++)
							buscar_escuela(familia.hijos[a])
					}
					else{
						if familia.padre != null_persona and brandom()
							cambiar_trabajo(familia.padre, delincuente)
						if familia.madre != null_persona and brandom()
							cambiar_trabajo(familia.madre, choose(delincuente, prostituta))
					}
				}
			//Cooldown exigencias cumplidas
			for(var a = 0; a < array_length(exigencia_nombre); a++){
				if exigencia_cumplida[a]{
					exigencia_cumplida_time[a]--
					if exigencia_cumplida_time[a] = 0
						exigencia_cumplida[a] = false
				}
			}
			//Tratar a todos los enfermos
			if exigencia_pedida[5] and array_length(desausiado.clientes) = 0
				cumplir_exigencia(5)
			//Subir la felicidad alimentaria
			if exigencia_pedida[6]{
				var fel_ali = 0
				for(var a = 0; a < array_length(familias); a++)
					fel_ali += familias[a].felicidad_alimento
				if fel_ali / array_length(familias) >= 50
					cumplir_exigencia(6)
			}
			if elecciones{
				for(var a = 0; a <= array_length(candidatos); a++){
					candidatos_votos[a] = 0
					if a < array_length(candidatos)
						candidatos[a].candidato_popularidad *= random_range(0.9, 1.1)
				}
				candidatos_votos_total = 0
				repeat(40){
					var a = voto_persona(array_pick(personas))
					if a != -1{
						candidatos_votos[a]++
						candidatos_votos_total++
					}
				}
			}
			//Zonas de pesca
			for(var a = 0; a < array_length(zonas_pesca); a++){
				var zona_pesca = zonas_pesca[a]
				zona_pesca.cantidad = min(floor(zona_pesca.cantidad * random_range(0.95, 1.1)), zona_pesca.cantidad_max)
			}
		}
		//Eventos anuales
		if (dia_de_anno) = 0{
			var anno = floor(dia / 360)
			felicidad_minima = floor(20 + 50 * (1 + anno) / (100 + anno))
			array_push(anno_felicidad, felicidad_total)
			credibilidad_financiera = clamp(credibilidad_financiera + sign((dinero_privado + inversion_privada) - prev_beneficio_privado), 1, 10)
			prev_beneficio_privado = dinero_privado + inversion_privada
			if array_length(empresas) < irandom(credibilidad_financiera)
				add_empresa(irandom_range(1000, 2000))
			year_history(anno)
			//Elecciones
			if elecciones{
				var votos = [0]
				for(var a = 0; a < array_length(candidatos); a++)
					array_push(votos, 0)
				e = 0
				for(var a = 0; a < array_length(personas); a++){
					var persona = personas[a], b = voto_persona(persona)
					if b != -1{
						votos[b]++
						e++
					}
				}
				var b = 0, temp_text = $"Resultados:\nVotantes: {e}\n\n"
				c = 0
				for(var a = 0; a < array_length(votos); a++){
					if a = 0
						temp_text += $"Su Alteza: {votos[a]}"
					else
						temp_text += $"\n{name(candidatos[a - 1])}: {votos[a]}"
					if votos[a] > b{
						b = votos[a]
						c = a
					}
				}
				show_message(temp_text)
				show_debug_message(temp_text)
				if c = 0
					show_message($"Has ganado las elecciones con {b} votos!")
				else{
					show_message($"Has perdido las elecciones\n\nAhora el poder lo tiene un tal {name(candidatos[c - 1])}")
					if show_question("Volver a jugar?")
						game_restart()
					else
						game_end()
				}
				while array_length(candidatos) > 0{
					var persona = array_shift(candidatos)
					persona.candidato = false
				}
				candidatos_votos = [0]
				elecciones = false
				campanna = 0
				for(b = 0; b < array_length(medios_comunicacion); b++){
					c = medios_comunicacion[b]
					for(var a = 0; a < array_length(edificio_count[c]); a++){
						var edificio = edificio_count[c, a]
						if edificio.modo = 1 or edificio.modo < 0
							edificio.modo = 0
					}
				}
			}
			if not debug and (anno mod 6) = 0 and anno > 0{
				text = ""
				candidatos_votos = [0]
				repeat(5){
					var persona = array_pick(personas)
					if persona.edad > 30 and persona.edad < 65 and not persona.candidato and persona.medico = null_edificio and (persona.pareja = null_persona or not persona.pareja.candidato) and not persona.preso and (not persona.sexo or ley_eneabled[10]){
						persona.candidato = true
						array_push(candidatos, persona)
						array_push(candidatos_votos, 0)
						elecciones = true
						text += (text = "" ? "" : "\n") + name(persona)
					}
				}
				add_noticia("Elecciones", $"Se han presentado {array_length(candidatos)} candidatos: " + text)
				repeat(40){
					var a = voto_persona(array_pick(personas))
					if a != -1{
						candidatos_votos[a]++
						candidatos_votos_total++
					}
				}
			}
		}
		#region Personas
			//Ciclo normal de las personas
			for(var a = 0; a < array_length(cumples[dia_de_anno]); a++){
				var persona = cumples[dia_de_anno, a]
				persona.edad++
				//Enfermar
				if random(1) < 0.2 - 0.1 * persona.familia.casa.agua + 0.1 * persona.edad < 12 and persona.medico = null_edificio
					buscar_atencion_medica(persona)
				//Estudiar
				if persona.escuela != null_edificio{
					var escuela = persona.escuela
					persona.educacion += random_range(0.1, 0.1 + escuela.servicio_calidad / 100)
					if (adoctrinamiento_escuelas and edificio_nombre[escuela.tipo] = "Escuela") or (adoctrinamiento_universidades and edificio_nombre[escuela.tipo] = "Universidad")
						adoctrinar(persona)
					if escuela.servicio_tarifa > 0{
						persona.familia.riqueza -= 12 * escuela.servicio_tarifa
						mes_tarifas[current_mes] += pagar(clamp(12 * escuela.servicio_tarifa, 0, persona.familia.riqueza), escuela)
						if persona.familia.riqueza < 0{
							persona.familia.riqueza = 0
							cambiar_escuela(persona, null_edificio)
						}
					}
					if persona.educacion >= edificio_escuela_max[escuela.tipo]{
						persona.educacion = edificio_escuela_max[escuela.tipo]
						cambiar_escuela(persona, null_edificio)
					}
					else if ley_eneabled[2] and random(1) < 0.1 and buscar_trabajo(persona){
						cambiar_escuela(persona, null_edificio)
						buscar_escuela(persona)
					}
					if persona.edad > 18 and random(1) < 0.1
						cambiar_escuela(persona, null_edificio)
				}
				//Acciones de un niño
				if persona.edad > 4 and persona.edad < 18{
					//Buscar escuela
					if persona.escuela = null_edificio and not persona.preso
						buscar_escuela(persona)
					//Mudarse a un albergue
					if persona.familia.padre = null_persona and persona.familia.madre = null_persona and edificio_nombre[persona.familia.casa.tipo] != "Albergue" and array_length(edificio_count[18]) > 0{
						var edificio = array_pick(edificio_count[18])
						var b = 0
						if array_length(edificio.familias) = edificio_familias_max[18]{
							for(b = 0; b < array_length(edificio.familias); b++)
								if edificio.familias[b].padre != null_persona or edificio.familias[b].madre != null_persona
									break
							if b < edificio_familias_max[18]
								cambiar_casa(edificio.familias[b], homeless)
						}
						if b < edificio_familias_max[18]
							cambiar_casa(persona.familia, edificio)
					}
				}
				//Dejar de estudiar
				if persona.edad = 18 and persona.escuela != null_edificio
					cambiar_escuela(persona, null_edificio)
				//Trabajo infantil :D
				if ley_eneabled[2] and persona.es_hijo and persona.edad > 12 and not persona.preso{
					cambiar_escuela(persona, null_edificio)
					buscar_trabajo(persona)
				}
				//Independizarse
				if persona.edad > 18 and (irandom_range(persona.edad, 24) = 24 or persona.edad > 24) and persona.es_hijo and not persona.preso{
					if buscar_trabajo(persona) or persona.edad > 24{
						var prev_familia = persona.familia, herencia = 0, b = prev_familia.felicidad_vivienda
						c = prev_familia.felicidad_alimento
						array_remove(prev_familia.hijos, persona, "hijo se independiza")
						if prev_familia.padre = null_persona and prev_familia.madre = null_persona and array_length(prev_familia.hijos) = 0{
							if prev_familia.riqueza > 0
								herencia = prev_familia.riqueza
							destroy_familia(prev_familia, true)
						}
						var familia = add_familia(, false)
						if persona.sexo
							familia.madre = persona
						else
							familia.padre = persona
						familia.riqueza = herencia
						persona.familia = familia
						persona.es_hijo = false
					}
				}
				//Adultez
				else if persona.edad > 24 and persona.edad < 60 and not persona.preso{
					if not ley_eneabled[16] and not persona.religion and random(1) < 0.02
						persona.religion = true
					//Casarse
					if persona.pareja = null_persona and (persona.religion or ley_eneabled[16]){
						var persona_2 = array_pick(personas)
						if ((persona.sexo != persona_2.sexo) or ley_eneabled[21]) and persona_2.edad > 18 and abs(persona.edad - persona_2.edad) < 8 and persona_2.pareja = null_persona and (persona_2.familia.padre = persona_2 or persona_2.familia.madre = persona_2) and persona.familia != persona_2.familia and (persona_2.religion or ley_eneabled[16]){
							persona.pareja = persona_2
							persona_2.pareja = persona
							//Transferir hijos
							for(var b = 0; b < array_length(persona_2.familia.hijos); b++){
								var hijo = persona_2.familia.hijos[b]
								hijo.familia = persona.familia
								array_push(persona.familia.hijos, hijo)
							}
							persona.familia.integrantes += persona_2.familia.integrantes
							destroy_familia(persona_2.familia)
							persona_2.familia = persona.familia
							if persona.sexo
								persona.familia.padre = persona_2
							else
								persona.familia.madre = persona_2
							persona.relacion.pareja = persona_2.relacion
							persona_2.relacion.pareja = persona.relacion
						}
					}
					//Divorcio
					else if ley_eneabled[0] and random(1) < 0.01{
						var persona_2 = persona.pareja, old_familia = persona.familia, familia = add_familia(, false)
						familia.riqueza = floor(old_familia.riqueza / 2)
						old_familia.riqueza = ceil(old_familia.riqueza / 2)
						if persona.sexo{
							old_familia.madre = null_persona
							familia.madre = persona
						}
						else{
							old_familia.padre = null_persona
							familia.padre = persona
						}
						persona.familia = familia
						persona.pareja = null_persona
						persona_2.pareja = null_persona
						persona.relacion.pareja = null_relacion
						persona_2.relacion.pareja = null_relacion
						for(var b = 0; b < array_length(old_familia.hijos); b++)
							if brandom(){
								var hijo = old_familia.hijos[b]
								array_delete(old_familia.hijos, b, 1)
								array_push(familia.hijos, hijo)
								hijo.familia = familia
								familia.integrantes++
								b--
							}
						buscar_trabajo(persona)
						buscar_casa(persona)
					}
					//Tener hijos
					else if irandom(3 + probabilidad_hijos * array_length(persona.familia.hijos)) = 0 and persona.familia.madre != null_persona and persona.familia.madre.edad < 45 and persona.familia.madre.embarazo = -1 and not (persona.pareja != null_persona and persona.pareja.sexo != persona.sexo){
						persona.familia.madre.embarazo = (dia + irandom_range(240, 280)) mod 360
						array_push(embarazo[persona.familia.madre.embarazo], persona.familia.madre)
					}
					buscar_trabajo(persona)
					//Buscar educación vespertina
					if (floor(persona.educacion) = 0 or brandom()) and persona.trabajo = null_edificio
						buscar_escuela(persona)
					//Crear empresa nacional
					else if persona.empresa = null_empresa and irandom(persona.familia.riqueza) > 750{
						var empresa = add_empresa(500, true, persona)
						persona.empresa = empresa
						persona.familia.riqueza -= 500
						add_noticia("Empresa nacional", $"Se ha creado la empresa {empresa.nombre}")
					}
					//Mudarse
					if not buscar_casa(persona) and persona.familia.casa = homeless and ley_eneabled[7] and not in(persona.trabajo, null_edificio, jubilado, delincuente, prostituta){
						var temp_array_coord = [], edificio = persona.trabajo, index = edificio.tipo, width = edificio.width, height = edificio.height
						d = edificio.x + width + 2
						e = edificio.y + height + 2
						var f = edificio.y - 2
						for(var b = edificio.x - 2; b < d; b++)
							for(c = f; c < e; c++)
								if not bool_edificio[# b, c] and not construccion_reservada[# b, c] and not mar[b, c] and not bosque[# b, c] and not calle[# b, c]
									array_push(temp_array_coord, {x : b, y : c})
						temp_array_coord = array_shuffle(temp_array_coord)
						edificio = spawn_build(temp_array_coord, 32)
						if edificio != null_edificio
							cambiar_casa(persona.familia, edificio)
					}
					//Ir al trabajo en taxi
					if floor(dia / 360) >= 80 and persona.familia.riqueza > 6 and not in(persona.trabajo, null_edificio, jubilado, delincuente, prostituta){
						for(var b = 0; b < array_length(persona.familia.casa.carreteras); b++){
							var carretera = persona.familia.casa.carreteras[b]
							if carretera.taxis > 0{
								if array_contains(carretera.edificios, persona.trabajo){
									persona.familia.riqueza -= 6
									dinero += 6
									mes_tarifas[current_mes] += 6
									for(c = 0; c < array_length(carretera.edificios); c++){
										var edificio = carretera.edificios[c]
										if edificio_nombre[edificio.tipo] = "Depósito de Taxis"{
											edificio.count--
											edificio.ganancia += 6
											break
										}
									}
									carretera.taxis--
									persona.felicidad_transporte = (100 + persona.felicidad_transporte) / 2
									break
								}
							}
						}
					}
				}
				//Volverse delincuente
				if persona.edad > 12 and persona.escuela = null_edificio and persona.trabajo = null_edificio and irandom(persona.educacion) = 0 and random(persona.edad) < 20 and random(persona.felicidad) < 30{
					if brandom()
						cambiar_trabajo(persona, delincuente)
					else if persona.sexo
						cambiar_trabajo(persona, prostituta)
				}
				if persona.trabajo = delincuente{
					var familia = array_pick(familias)
					if familia != persona.familia and (familia.casa = homeless or familia.casa.ladron = null_persona){
						if familia.casa != homeless{
							familia.casa.ladron = persona
							persona.ladron = familia.casa
						}
						var b = clamp(irandom(familia.riqueza), 0, 24)
						if b > 0{
							familia.riqueza -= b
							persona.familia.riqueza += b
							for_familia(function(persona = null_persona, a = 0){
								persona.felicidad_crimen = max(0, persona.felicidad_crimen - a)
							}, familia,, 2 * b - 5)
						}
					}
				}
				//Vejez
				else if persona.edad > 60{
					//Jubilarse
					if not persona.preso
						if ley_eneabled[3] and persona.edad >= 65 - 5 * persona.sexo and (persona.religion or ley_eneabled[16])
							cambiar_trabajo(persona, jubilado)
						else{
							buscar_trabajo(persona)
							buscar_casa(persona)
						}
					//Morir
					if irandom(persona.edad) > 60{
						persona.muerte = irandom(359)
						array_push(muerte[persona.muerte], persona)
					}
				}
				//Acciones no para niños
				if not persona.es_hijo{
					//Accidentes laborales
					if persona.trabajo != null_edificio and random(1) < persona.trabajo.trabajo_riesgo{
						mes_accidentes[current_mes]++
						if persona.medico != null_edificio{
							add_noticia("Accidente", $"Ha muerto {name(persona)} en un accidente laboral en {persona.trabajo.nombre}")
							if ley_eneabled[12] and (persona.religion or ley_eneabled[16]) and persona.familia.integrantes > 0{
								persona.familia.riqueza += 100
								mes_salida_micelaneo[current_mes] += pagar(-100, persona.trabajo)
							}
							destroy_persona(persona,, "Accidente laboral")
							mes_muertos_accidentes[current_mes]++
						}
						else
							buscar_atencion_medica(persona)
					}
					for(var b = 0; b < array_length(recurso_lujo); b++)
						persona.lujos[b] = false
				}
				//Acudir a edificios de ocio
				if not persona.preso{
					var temp_array = array_shuffle(edificios_ocio_index)
					persona.felicidad_ocio = 0
					if persona.familia.casa.energia or persona.trabajo.energia{
						persona.felicidad_ocio += min(30, irandom(min(1, energia_input / energia_output) * radioemisoras))
						if persona.familia.casa.energia
							persona.felicidad_ocio += min(30, irandom(min(1, energia_input / energia_output) * television))
					}
					for(var b = 0; b < array_length(temp_array); b++){
						c = temp_array[b]
						var var_edificio_nombre = edificio_nombre[c]
						if array_length(edificio_count[c]) > 0 and (persona.edad > 12 or (var_edificio_nombre != "Taberna")) and (array_length(persona.familia.hijos) > 0 or (var_edificio_nombre != "Circo")) and ((not persona.sexo and persona.edad > 15) or (var_edificio_nombre != "Cabaret")) and (persona.educacion >= 0.6 or not in(var_edificio_nombre, "Periódico", "Biblioteca")){
							var ocio = array_pick(edificio_count[c]), temp_precio = ocio.servicio_tarifa
							if var_edificio_nombre = "Taberna"{
								temp_precio += ceil(recurso_precio[22] * 1.1)
								if ocio.almacen[22] = 0
									continue
							}
							else if var_edificio_nombre = "Biblioteca"{
								if ocio.modo = 1
									persona.educacion = min(persona.educacion + random(0.1), 1.6)
							}
							set_calidad_servicio(ocio)
							if ocio.count < ocio.servicio_max and persona.familia.riqueza >= temp_precio{
								persona.familia.riqueza -= temp_precio
								mes_tarifas[current_mes] += pagar(temp_precio, ocio)
								if var_edificio_nombre = "Periódico"{
									persona.informado = true
									if adoctrinamiento_periodico and not ocio.privado
										adoctrinar(persona)
								}
								else if var_edificio_nombre = "Taberna"{
									persona.lujos[2] = true
									ocio.almacen[22]--
								}
								else if var_edificio_nombre = "Biblioteca"{
									if adoctrinamiento_biblioteca
										adoctrinar(persona)
								}
								ocio.count++
								persona.ocios[b] = ocio.servicio_calidad
								persona.felicidad_ocio += persona.ocios[b]
							}
							else{
								persona.ocios[b] /= 2
								persona.felicidad_ocio += persona.ocios[b]
							}
						}
						else{
							persona.ocios[b] /= 2
							persona.felicidad_ocio += persona.ocios[b]
						}
					}
					persona.felicidad_ocio = clamp(floor(persona.felicidad_ocio), 0, 100)
				}
				else
					persona.felicidad_ocio = 0
				//Comprar productos de lujo
				if persona.edad > 12
					for(var b = 0; b < array_length(recurso_lujo); b++)
						if persona.lujos[b] = false{
							c = recurso_lujo[b]
							if not persona.preso and random(1) < recurso_lujo_probabilidad[b] and (c != 35 or persona.familia.casa.energia){
								var temp_precio = ceil(recurso_precio[c] * 1.1)
								if recurso_banda[c]
									temp_precio = clamp(temp_precio, recurso_banda_min[c], recurso_banda_max[c])
								if persona.familia.sueldo > 0 and persona.familia.riqueza > temp_precio and array_length(edificio_count[35]) > 0{
									var tienda = array_pick(edificio_count[35])
									if tienda.count > 0 and tienda.almacen[c] >= 1{
										tienda.count--
										tienda.almacen[c]--
										persona.felicidad_ocio = min(100, persona.felicidad_ocio + recurso_lujo_ocio[b])
										mes_tarifas[current_mes] += pagar(temp_precio, tienda)
									}
								}
							}
						}
				//Ir a la iglesia
				if array_length(iglesias) > 0 and (persona.religion or (persona.edad < 12 and random(1) < 0.1)) and not persona.preso{
					persona.religion = true
					var iglesia= null_edificio
					if persona.familia.casa != homeless{
						if array_length(persona.familia.casa.iglesias_cerca) > 0
							iglesia = array_pick(persona.familia.casa.iglesias_cerca)
					}
					else
						iglesia = array_pick(iglesias)
					if iglesia.count < iglesia.servicio_max{
						iglesia.count++
						persona.felicidad_religion = min(110, persona.felicidad_religion + edificio_servicio_calidad[iglesia.tipo])
					}
				}
				#region Calculo de felicidad
					felicidad_total = felicidad_total * array_length(personas) - persona.felicidad
					if array_length(medicos) = 1
						persona.felicidad_salud = floor(persona.felicidad_salud / 2)
					else{
						var temp_contaminacion = 0.25;
						if persona.familia.casa != homeless
							temp_contaminacion = (1 - clamp(contaminacion[# persona.familia.casa.x, persona.familia.casa.y], 0, 100) / 100)
						if not in(persona.trabajo, null_edificio, jubilado, delincuente, prostituta)
							temp_contaminacion *= (1 - clamp(contaminacion[# persona.trabajo.x, persona.trabajo.y], 0, 100) / 100)
						if persona.escuela != null_edificio
							temp_contaminacion *= (1 - clamp(contaminacion[# persona.escuela.x, persona.escuela.y], 0, 100) / 100)
						temp_contaminacion = 100 * temp_contaminacion
						persona.felicidad_salud = floor((persona.felicidad_salud + 3 * temp_contaminacion) / 4)
					}
					set_calidad_vivienda(persona.familia.casa)
					persona.familia.felicidad_vivienda = floor((persona.familia.felicidad_vivienda + 3 * persona.familia.casa.vivienda_calidad) / 4)
					var temp_array = [persona.felicidad_salud, persona.familia.felicidad_vivienda, persona.felicidad_ocio, persona.familia.felicidad_alimento, persona.felicidad_crimen]
					persona.felicidad_crimen = min(persona.felicidad_crimen + 5, 100)
					if persona.es_hijo{
						persona.felicidad_educacion = floor((persona.felicidad_educacion + 3 * edificio_servicio_calidad[persona.escuela.tipo]) / 4)
						array_push(temp_array, persona.felicidad_educacion)
					}
					else{
						c = 0
						d = 0
						var familia = persona.familia
						for(var b = 0; b < array_length(ley_nombre); b++)
							if ley_eneabled[b]{
								c += sqrt(sqr(persona.politica_economia - ley_economia[b]) + sqr(persona.politica_sociocultural - ley_sociocultural[b]))
								d++
							}
						c = round(100 * (1 - c / (d * 6 * sqrt(2))))
						d = 0
						if persona.religion
							d -= politica_religion
						if (persona = familia.padre or persona = familia.madre) and array_length(familia.hijos) > 0
							d += -20 * ley_eneabled[2] + 10 * (ley_eneabled[9] and (persona.religion or ley_eneabled[16]))
						if persona.edad > 65 and ley_eneabled[3] and (persona.religion or ley_eneabled[16])
							d += 15
						if (persona.sexo or persona.educacion = 0) and not ley_eneabled[10]
							d -= 10
						if not persona.religion and ley_eneabled[16]
							d += 15
						if persona.trabajo.comisaria != null_edificio
							d -= 10
						if persona.familia.casa.comisaria != null_edificio
							d -= 10
						c = clamp(c + d, 0, 100)
						persona.felicidad_ley = floor((persona.felicidad_ley + c) / 2)
						array_push(temp_array, persona.felicidad_ley)
						if persona.informado{
							array_push(temp_array, persona.felicidad_ley)
							persona.informado = false
						}
					}
					if persona.trabajo != null_edificio{
						var b = 1 + real(persona.es_hijo and ley_eneabled[2])
						persona.felicidad_trabajo = floor((persona.felicidad_trabajo + 3 * (persona.trabajo.trabajo_calidad / (b + persona.trabajo.huelga))) / 4)
						array_push(temp_array, persona.felicidad_trabajo)
					}
					if persona.religion{
						persona.felicidad_religion = floor(persona.felicidad_religion * 0.9)
						array_push(temp_array, persona.felicidad_religion)
					}
					if persona.familia.casa != homeless and (persona.escuela != null_edificio or not in(persona.trabajo, null_edificio, jubilado, delincuente, prostituta))
						array_push(temp_array, persona.felicidad_transporte)
					persona.felicidad = calcular_felicidad(temp_array) + persona.felicidad_temporal / array_length(temp_array)
					felicidad_total = (felicidad_total + persona.felicidad) / array_length(personas)
					if abs(persona.felicidad_temporal) <= 10
						persona.felicidad_temporal = 0
					else
						persona.felicidad_temporal /= 2
				#endregion
				//Descontento
				if persona.edad > 18 and persona.edad < 60 and irandom(felicidad_minima) >= persona.felicidad + 5 * (persona.nacionalidad = 0) and dia > 360{
					//Emigrar
					if ley_eneabled[5] and persona.familia.riqueza >= 10 * real(persona.familia.integrantes) and brandom() and not persona.preso{
						var familia = persona.familia
						if familia.padre.felicidad < 15 and familia.madre.felicidad < 15{
							for_familia(function(persona = null_persona){
								destroy_persona(persona, false, "Emigrado")
								mes_emigrantes[current_mes]++
							}, familia)
						}
					}
					//Protestas
					else if not in(persona.trabajo, null_edificio, jubilado, delincuente, prostituta) and not persona.trabajo.paro and persona.trabajo.exigencia = null_exigencia and not persona.trabajo.privado and not persona.preso and persona.trabajo.comisaria = null_edificio and not in(edificio_nombre[persona.trabajo.tipo], "Comisaría", "Prisión") and persona.familia.casa.comisaria = null_edificio{
						var edificio = persona.trabajo, fel_ali = 0, fel_sal = 0, fel_edu = 0, num_edu = 0, fel_div = 0, fel_rel = 0
						for(var b = 0; b < array_length(edificio.trabajadores); b++){
							var trabajador = edificio.trabajadores[b]
							fel_ali += trabajador.familia.felicidad_alimento
							fel_sal += trabajador.felicidad_salud
							num_edu += array_length(trabajador.familia.hijos)
							for(c = 0; c < array_length(trabajador.familia.hijos); c++)
								fel_edu += trabajador.familia.hijos[c].felicidad_educacion
							fel_div += trabajador.felicidad_ocio
							if trabajador.religion
								fel_rel += trabajador.felicidad_religion
						}
						//Exigencia de alimento
						if fel_ali / array_length(edificio.trabajadores) < 30{
							if not exigencia_cumplida[2] and (not edificio.exigencia_fallida or exigencia_cumplida[6])
								add_huelga(2, edificio)
							else if not exigencia_cumplida[6]
								add_huelga(6, edificio)
						}
						//Exigencia de salud
						else if fel_sal / array_length(edificio.trabajadores) < 30{
							if not exigencia_cumplida[0] and (not edificio.exigencia_fallida or exigencia_cumplida[5])
								add_huelga(0, edificio)
							else if not exigencia_cumplida[5]
								add_huelga(5, edificio)
						}
						//Exigencia de educación
						else if fel_edu / num_edu < 25 and brandom() and not exigencia_cumplida[1]{
							add_huelga(1, edificio)
						}
						//Exigencia de diversión
						else if fel_div / array_length(edificio.trabajadores) < 25 and brandom() and not exigencia_cumplida[3]{
							add_huelga(3, edificio)
						}
						//Exigencia de religión
						else if fel_rel / array_length(edificio.trabajadores) < 30 and not exigencia_cumplida[4]{
							add_huelga(4, edificio)
						}
					}
				}
			}
			//Nacimientos
			while array_length(embarazo[dia_de_anno]) > 0{
				var persona = array_pop(embarazo[dia_de_anno])
				persona.embarazo = -1
				var hijo = add_persona()
				hijo.familia = persona.familia
				if persona.familia.padre != null_persona
					hijo.apellido = persona.familia.padre.apellido
				else
					hijo.apellido = persona.familia.madre.apellido
				hijo.edad = 0
				array_pop(cumples[hijo.cumple])
				hijo.cumple = (dia mod 360)
				array_push(cumples[hijo.cumple], hijo)
				array_push(persona.familia.hijos, hijo)
				mes_nacimientos[current_mes]++
				hijo.es_hijo = true
				hijo.relacion.padre = persona.pareja.relacion
				hijo.relacion.madre = persona.relacion
				array_push(persona.relacion.hijos, hijo)
				if persona.pareja != null_persona
					array_push(persona.pareja.relacion.hijos, hijo)
				persona.familia.integrantes++
			}
			//Muertes
			while array_length(muerte[dia_de_anno]) > 0{
				var persona = array_shift(muerte[dia_de_anno])
				destroy_persona(persona,, "Muerte de causa natural")
				mes_muertos_viejos[current_mes]++
			}
		#endregion
		//Ciclo de las empresas
		for(var a = 0; a < array_length(dia_empresas[dia_de_mes]); a++){
			var empresa = dia_empresas[dia_de_mes, a]
			//Compra de terrenos
			if array_length(terrenos_venta) > 0{
				var terreno_venta = terrenos_venta[0], width = terreno_venta.width, height = terreno_venta.height, temp_precio = valor_terreno * width * height
				if not empresa.quiebra and irandom(10) < credibilidad_financiera and empresa.dinero > 5 * temp_precio + array_length(empresa.terreno){
					x = terreno_venta.x
					y = terreno_venta.y
					array_shift(terrenos_venta)
					if sel_terreno = terreno_venta{
						sel_terreno = null_terreno
						if sel_tipo = 4
							sel_info = false
					}
					empresa.dinero -= temp_precio
					if terreno_venta.privado
						terreno_venta.empresa.dinero += temp_precio
					else{
						dinero += temp_precio
						mes_privatizacion[current_mes] += temp_precio
					}
					d = x + width
					e = y + height
					ds_grid_set_region(zona_empresa, x, y, d - 1, e - 1, empresa)
					ds_grid_set_region(zona_privada_venta, x, y, d - 1, e - 1, false)
					ds_grid_set_region(zona_privada_venta_terreno, x, y, d - 1, e - 1, null_terreno)
					for(var b = x; b < d; b++)
						for(c = y; c < e; c++)
							array_push(empresa.terreno, {a : b, b : c})
				}
			}
			//Compra de edificios
			if array_length(edificios_a_la_venta) > 0{
				var temp_compra = edificios_a_la_venta[0], edificio = temp_compra.edificio, temp_precio = temp_compra.precio, width = temp_compra.width, height = temp_compra.height
				if not empresa.quiebra and irandom(10) < credibilidad_financiera and empresa.dinero > 2 * temp_precio{
					empresa_comprado = null_empresa
					array_shift(edificios_a_la_venta)
					x = edificio.x
					y = edificio.y
					if temp_compra.estatal{
						mes_privatizacion[current_mes] += temp_precio
						dinero += temp_precio
						dinero_privado -= temp_precio
						inversion_privada += temp_precio
					}
					else if temp_compra.empresa != null_empresa{
						array_remove(temp_compra.empresa.ventas, temp_compra, "edificio eliminado de los edificios a la venta de una empresa")
						temp_compra.empresa.dinero += temp_precio
						for(var b = 0; b < array_length(temp_compra.empresa.terreno); b++){
							var complex = temp_compra.empresa.terreno[b]
							if complex.a >= x and complex.a < x + width and complex.b >= y and complex.b < y + height
								array_delete(temp_compra.empresa.terreno, b--, 1)
						}
					}
					empresa.dinero -= temp_precio
					edificio.privado = true
					if edificio_nombre[edificio.tipo] = "Aserradero"{
						edificio.modo = 0
						for(var b = 0; b < array_length(edificio.array_complex); b++){
							var temp_complex = edificio.array_complex[b]
							ds_grid_set(bosque_venta, temp_complex.a, temp_complex.b, true)
						}
					}
					else if in(edificio_nombre[edificio.tipo], "Periódico", "Antena de Radio", "Televisión")
						edificio.modo = 2
					edificio.empresa = empresa
					array_push(empresa.edificios, edificio)
					set_presupuesto(0, edificio)
					var temp_bool_array = []
					for(var b = 0; b < array_length(edificio_categoria_nombre); b++)
						array_push(temp_bool_array, array_contains(edificio_categoria[b], edificio.tipo))
					d = x + width
					e = y + height
					ds_grid_set_region(zona_privada, x, y, d - 1, e - 1, true)
					ds_grid_set_region(zona_empresa, x, y, d - 1, e - 1, empresa)
					ds_grid_set_region(zona_privada_permisos, x, y, d - 1, e - 1, temp_bool_array)
					for(var b = x; b < d; b++)
						for(c = y; c < e; c++)
							array_push(empresa.terreno, {a : b, b : c})
					edificio.venta = false
					set_paro(false, edificio)
				}
				else{
					if empresa_comprado = null_empresa
						empresa_comprado = empresa
					else if empresa_comprado = empresa and array_length(edificios_a_la_venta) > 1{
						array_shift(edificios_a_la_venta)
						array_push(edificios_a_la_venta, temp_compra)
					}
				}
			}
			//Construcción
			if array_length(empresa.terreno) > 0{
				var terreno = array_pick(empresa.terreno), temp_array = []
				mx = terreno.a
				my = terreno.b
				while zona_empresa[# mx - 1, my] = empresa and (not bool_edificio[# mx - 1, my] or id_edificio[# mx - 1, my].tipo = 32)
					mx--
				while zona_empresa[# mx, my - 1] = empresa and (not bool_edificio[# mx, my - 1] or id_edificio[# mx, my - 1].tipo = 32)
					my--
				for(var b = 0; b < array_length(edificio_categoria_nombre); b++)
					if zona_privada_permisos[# mx, my][b]
						for(c = 0; c < array_length(edificio_categoria[b]); c++){
							d = edificio_categoria[b, c]
							if floor(dia / 360) >= edificio_anno[d] and not edificio_estatal[d]
								array_push(temp_array, d)
						}
				if array_length(temp_array) > 0{
					temp_array = array_shuffle(temp_array)
					var index = -1
					do index = array_shift(temp_array)
					until array_length(temp_array) = 0
					if index >= 0{
						var temp_precio = edificio_precio[index], temp_precio_2 = 0, temp_altura = 0, width = edificio_width[index], height = edificio_height[index], tipo = 0, flag = true, var_edificio_nombre = edificio_nombre[index], temp_tiempo = 0
						if zona_empresa[# mx + width - 1, my + height - 1] != empresa
							continue
						if var_edificio_nombre = "Mina"{
							var max_c = mx + width + 1, max_d = my + height + 1
							flag = false
							for(var b = 0; b < array_length(recurso_mineral); b++){
								e = 0
								var f = my - 1
								for(c = mx - 1; c < max_c; c++)
									for(d = f; d < max_d; d ++)
										if mineral[b][c, d]
											e += mineral_cantidad[b][c, d]
								temp_precio_2 = recurso_precio[recurso_mineral[b]] * e
								if (temp_precio_2 * (1 - impuesto_minero) > 1000 + 2 * edificio_precio[index]){
									temp_precio_2 *= impuesto_minero
									tipo = b
									flag = true
									break
								}
							}
						}
						else if var_edificio_nombre = "Aserradero"{
							var b = 0, max_c = mx + width + 5, max_d = my + height + 5
							e = my - 5
							for(c = mx - 5; c < max_c; c++)
								for(d = e; d < max_d; d++)
									if bosque[# c, d] and not bosque_venta[# c, d]
										b += bosque_madera[c, d]
							temp_precio_2 = recurso_precio[0] * b
							flag = (temp_precio_2 * (1 - impuesto_maderero) > 1000 + 2 * edificio_precio[index])
							temp_precio_2 *= impuesto_maderero
						}
						else if var_edificio_nombre = "Tejar"{
							var b = 0, max_c = mx + width, max_d = my + height
							for(c = mx; c < max_c; c++)
								for(d = my; d < max_d; d ++)
									b += (altura[# c, d] > 0.6)
							flag = (b / (width * height) > 0.8)
						}
						else if var_edificio_nombre = "Pozo petrolífero"{
							var b = 0, max_c = mx + width, max_d = my + height
							for(c = mx; c < max_c; c++)
								for(d = my; d < max_d; d ++)
									b += petroleo[# c, d]
							temp_precio_2 = recurso_precio[27] * b
							flag = (temp_precio_2 * (1 - impuesto_petrolifero) > 1000 + 2 * edificio_precio[index])
							temp_precio_2 *= impuesto_petrolifero
						}
						else if in(var_edificio_nombre, "Granja", "Rancho"){
							flag = false
							width = 0
							var flag_2 = false, temp_cultivos = [], temp_bool = var_edificio_nombre = "Granja"
							if temp_bool
								for(var b = 0; b < array_length(recurso_cultivo); b++)
									array_push(temp_cultivos, 0)
							for(var b = mx; b < mx + 10; b++){
								var prev_height = height
								height = 0
								for(c = my; c < my + 10; c++)
									if b >= mx + edificio_width[index] or c >= my + edificio_height[index]{
										if zona_empresa[# b, c] != empresa or construccion_reservada[# b, c] or (bool_edificio[# b, c] and id_edificio[# b, c].tipo != 32){
											if c = my{
												height = prev_height
												flag_2 = true
											}
											break
										}
										if temp_bool
											for(d = 0; d < array_length(recurso_cultivo); d++)
												temp_cultivos[d] += cultivo[d][# b, c]
										height++
									}
								if flag_2
									break
								width++
							}
							if width > edificio_width[index] or height > edificio_height[index]{
								flag = true
								if temp_bool{
									c = 0
									for(var b = 0; b < array_length(recurso_cultivo); b++)
										if floor(dia / 360) >= recurso_anno[recurso_cultivo[tipo]] and temp_cultivos[b] > c{
											c = temp_cultivos[b]
											tipo = b
										}
									if c / (width * height - edificio_width[index] * edificio_height[index]) < 0.3
										flag = false
									else
										temp_tiempo += 5 * (width * height - 9)
								}
								else{
									var b = 0, max_c = mx + width, max_d = my + height
									for(c = mx; c < max_c; c++)
										for(d = my; d < max_d; d ++)
											if c >= mx + edificio_width[index] or d >= my + edificio_height[index]
												b += (altura[# c, d] > 0.6)
									flag = (b / (width * height - edificio_width[index] * edificio_height[index]) > 0.8)
									tipo = irandom(array_length(ganado_nombre) - 1)
								}
							}
						}
						if flag and empresa.dinero > temp_precio + temp_precio_2 and edificio_valid_place(mx, my, index, true, empresa){
							empresa.dinero -= temp_precio + temp_precio_2
							dinero_privado -= temp_precio + temp_precio_2
							dinero += temp_precio_2
							mes_privatizacion[current_mes] += temp_precio_2
							for(var b = mx; b < mx + width; b++)
								for(c = my; c < my + height; c++)
									temp_altura += altura[# b, c]
							if var_edificio_nombre = "Aserradero"
								ds_grid_set_region(bosque_venta, mx - 5, my - 5, mx + width + 4, my + height + 4, true)
							array_push(empresa.construcciones, add_construccion(, mx, my, index, tipo, edificio_construccion_tiempo[index] + temp_tiempo, temp_altura / width / height, width, height, temp_precio, true, empresa, mx, my))
						}
					}
				}
			}
			//Impuestos
			var b = impuesto_empresa * array_length(empresa.edificios) + impuesto_empresa_fijo
			empresa.dinero -= b
			dinero += b
			mes_impuestos[current_mes] += b
			//Quiebra
			if empresa.dinero < 0{
				if empresa.quiebra{
					credibilidad_financiera = max(credibilidad_financiera - 1, 1)
					destroy_empresa(empresa)
					a--
					continue
				}
				else{
					empresa.quiebra = true
					//Vender edificios para salir de la quiebra
					if array_length(empresa.edificios) > 0{
						var dinero_acumulado = 0
						while empresa.dinero + dinero_acumulado < 0{
							var edificio = array_shift(empresa.edificios), complex_2 = valorizar_edificio(edificio), temp_precio = complex_2.int, venta = {
								edificio : edificio,
								precio : temp_precio,
								width : edificio.width,
								height : edificio.height,
								estatal : false,
								empresa : empresa
							}
							dinero_acumulado += temp_precio
							array_push(edificios_a_la_venta, venta)
							array_push(empresa.ventas, venta)
							edificio.empresa = null_empresa
							edificio.venta = true
							set_paro(true, edificio)
						}
					}
				}
			}
			else
				empresa.quiebra = false
		}
		//Ciclo de los edificios
		for(var a = 0; a < array_length(dia_trabajo[dia_de_mes]); a++){
			var edificio = dia_trabajo[dia_de_mes, a], index = edificio.tipo, width = edificio.width, height = edificio.height, var_edificio_nombre = edificio_nombre[index]
			if edificio.presupuesto > 3
				edificio_experiencia[index] = 2 - 0.99 * (2 - edificio_experiencia[index])
			if edificio = delincuente or edificio = prostituta
				continue
			mes_mantenimiento[current_mes] += pagar(-edificio.mantenimiento, edificio)
			if edificio.ladron != null_persona{
				edificio.ladron.ladron = null_edificio
				edificio.ladron = null_persona
			}
			if var_edificio_nombre != "Estación de Bomberos"
				edificio.seguro_fuego = max(0, edificio.seguro_fuego - (1 + 0.5 * edificio.agua))
			var b = 1
			//Edificios de trabajo
			if edificio_es_trabajo[index]{
				if edificio.huelga{
					edificio.huelga_tiempo--
					if edificio.huelga_tiempo = 0
						set_paro(false, edificio)
					if var_edificio_nombre = "Granja" and (current_mes = 5 or current_mes = 10)
						edificio.count = 0
				}
				else if not edificio.paro{
					b = floor(edificio.trabajo_sueldo * edificio.trabajo_mes / 30)
					if edificio.privado
						mes_impuestos[current_mes] += pagar(-b * (1 + impuesto_trabajador), edificio)
					mes_sueldos[current_mes] += pagar(-b, edificio)
					if ley_eneabled[25]
						mes_mantenimiento[current_mes] += pagar(-array_length(edificio.trabajadores) * 0.75, edificio)
					for(b = 0; b < array_length(edificio.trabajadores); b++)
						edificio.trabajadores[b].familia.riqueza += edificio.trabajo_sueldo
					b = max(0, edificio.trabajo_mes / 30 * (0.8 + 0.1 * edificio.presupuesto) * edificio.eficiencia * edificio_experiencia[index] * edificio_industria_velocidad[index] * (edificio.energia ? 0.75 + min(0.5, energia_input / energia_output) : 1) * (edificio.agua ? 0.75 + min(0.5, agua_input / agua_output) : 1))
					if array_length(edificio.input_num) > 0
						if edificio_industria_optativo[index]{
							var max_rss = 0
							for(c = 0; c < array_length(edificio.input_id); c++)
								if edificio.input_num[c] > 0
									max_rss = min(max_rss, edificio.almacen[edificio.input_id[c]] / edificio.input_num[c])
							b = min(b, max_rss)
						}
						else{
							var min_rss = infinity
							for(c = 0; c < array_length(edificio.input_id); c++)
								if edificio.input_num[c] > 0
									min_rss = min(min_rss, edificio.almacen[edificio.input_id[c]] / edificio.input_num[c])
							b = min(b, min_rss)
						}
					if var_edificio_nombre = "Granja"{
						c = recurso_cultivo[edificio.modo]
						b = floor(b * (1 - clamp(ds_grid_get_mean(contaminacion, edificio.x, edificio.y, edificio.x + width - 1, edificio.y + height - 1), 0, 100) / 200))
						if current_mes = 5 or current_mes = 10{
							edificio.almacen[recurso_cultivo[edificio.modo]] += min(edificio.count, b)
							edificio.count = 0
						}
						else
							edificio.count += b / 5
						if edificio.privado or recurso_exportado[c] or recurso_utilizado[c] > 0 or not edificio.es_almacen{
							d = 200 * array_contains(recurso_comida, c) * edificio.es_almacen
							if (current_mes mod 6) = (edificio.mes_creacion mod 6) and edificio.almacen[c] > d
								produccion_edificio(c, edificio, d)
						}
					}
					else if var_edificio_nombre = "Aserradero"{
						//Cortar árboles
						if array_length(edificio.array_complex) > 0{
							e = b
							var f = b, flag = false
							while f > 0 and array_length(edificio.array_complex) > 0{
								var complex = edificio.array_complex[0]
								if f < bosque_madera[complex.a, complex.b]{
									array_add(bosque_madera[complex.a], complex.b, -f)
									f = 0
								}
								else if edificio.modo = 1{
									if bosque_madera[complex.a, complex.b] > 1{
										f -= bosque_madera[complex.a, complex.b] - 1
										array_set(bosque_madera[complex.a], complex.b, 1)
										array_push(edificio.array_complex, array_shift(edificio.array_complex))
									}
									else{
										repeat(array_length(edificio.array_complex)){
											complex = edificio.array_complex[0]
											if bosque_madera[complex.a, complex.b] = 1{
												array_shift(edificio.array_complex)
												array_push(edificio.array_complex, complex)
											}
											else
												break
										}
										break
									}
								}
								else{
									f -= bosque_madera[complex.a, complex.b]
									array_set(bosque_madera[complex.a], complex.b, 0)
									ds_grid_set(bosque, complex.a, complex.b, false)
									array_shift(edificio.array_complex)
									if array_length(edificio.array_complex) = 0{
										edificio.almacen[1] += e - f
										produccion_edificio(1, edificio)
										set_paro(true, edificio)
										while array_length(edificio.trabajadores) > 0{
											var persona = edificio.trabajadores[0]
											cambiar_trabajo(persona, null_edificio)
											buscar_trabajo(persona)
										}
										if edificio.privado{
											destroy_edificio(edificio)
											flag = true
										}
										break
									}
								}
							}
							if flag{
								a--
								continue
							}
							edificio.almacen[1] += e - f
						}
						if (current_mes mod 6) = (edificio.mes_creacion mod 6) and edificio.almacen[1] > 0
							produccion_edificio(1, edificio)
					}
					else if var_edificio_nombre = "Pescadería"{
						var zona_pesca = edificio.zona_pesca
						if zona_pesca != null_zona_pesca{
							b = min(zona_pesca.cantidad, b * (1 - clamp(contaminacion[# zona_pesca.a, zona_pesca.b], 0, 100) / 200))
							edificio.almacen[8] += b
							zona_pesca.cantidad -= b
							if ley_eneabled[13] and zona_pesca.cantidad < 750
								buscar_zona_pesca(edificio)
							zona_pesca_agotada(zona_pesca)
							if edificio.privado and not array_contains(edificio_count[14], edificio)
								continue
							if edificio.privado or recurso_exportado[8] or recurso_utilizado[8] > 0 or not edificio.es_almacen{
								c = 200 * edificio.es_almacen
								if (current_mes mod 6) = (edificio.mes_creacion mod 6) and floor(edificio.almacen[8]) > c{
									if edificio.privado
										mes_impuestos += pagar(recurso_precio[8] * (edificio.almacen[8] - c) * -impuesto_pesquero, edificio)
									produccion_edificio(8, edificio, c)
								}
							}
						}
					}
					else if var_edificio_nombre = "Mina"{
						e = b
						var h = b, f = min(xsize - 1, edificio.x + width + 1), g = min(ysize - 1, edificio.y + height + 1), i = max(0, edificio.y - 1), temp_rss = recurso_mineral[edificio.modo]
						for(c = max(0, edificio.x - 1); c < f; c++){
							for(d = i; d < g; d++)
								if mineral[edificio.modo][c, d]{
									if floor(mineral_cantidad[edificio.modo][c, d] * edificio.ahorro) <= h{
										h -= floor(mineral_cantidad[edificio.modo][c, d] * edificio.ahorro)
										array_set(mineral[edificio.modo, c], d, false)
										if h = 0
											break
									}
									else{
										array_add(mineral_cantidad[edificio.modo, c], d, -floor(h / edificio.ahorro))
										h = 0
										break
									}
								}
							if h = 0
								break
						}
						edificio.almacen[temp_rss] += e - h
						if h > 0{
							var flag = false
							if edificio.privado{
								for(e = 0; e < array_length(recurso_mineral); e++){
									for(c = max(0, edificio.x - 1); c < f; c++){
										for(d = i; d < g; d++)
											if mineral[(edificio.modo + e) mod array_length(recurso_mineral)][c, d]{
												flag = true
												break
											}
										if flag
											break
									}
									if flag{
										edificio.modo = (edificio.modo + e) mod array_length(recurso_mineral)
										temp_rss = recurso_mineral[edificio.modo]
										edificio.nombre = $"Mina de {recurso_nombre[temp_rss]} {++edificio_number_mina[edificio.modo]}"
										break
									}
								}
							}
							if not flag{
								set_paro(true, edificio)
								produccion_edificio(temp_rss, edificio)
								while array_length(edificio.trabajadores) > 0{
									var persona = edificio.trabajadores[0]
									cambiar_trabajo(persona, null_edificio)
									buscar_trabajo(persona)
								}
								if edificio.privado{
									destroy_edificio(edificio)
									a--
									continue
								}
							}
						}
						if (current_mes mod 6) = (edificio.mes_creacion mod 6) and floor(edificio.almacen[temp_rss]) > 0
							produccion_edificio(temp_rss, edificio)
					}
					else if var_edificio_nombre = "Muelle"{
						if (current_mes mod 6) = (edificio.mes_creacion mod 6){
							var total_trabajo = floor(b)
							//Importacion por construccion
							for(c = 0; c < array_length(recurso_nombre) and total_trabajo > 0; c++)
								if recurso_construccion[c] > 0{
									var total = min(total_trabajo, recurso_construccion[c])
									total_trabajo -= total
									array_add(mes_importaciones_recurso_num[current_mes], c, total)
									recurso_construccion[c] -= total
									while total > 0{
										d = total
										var temp_factor = 1
										if array_length(recurso_tratados_compra[c]) > 0{
											var tratado = recurso_tratados_compra[c, 0]
											temp_factor = tratado.factor
											d = min(total, tratado.cantidad)
											tratado.cantidad -= d
											if tratado.cantidad = 0
												cumplir_tratado(tratado)
										}
										total -= d
										d = floor(d * recurso_precio[c] * 1.1 / temp_factor)
										dinero -= d
										mes_importaciones[current_mes] += d
										array_add(mes_importaciones_recurso[current_mes], c, d)
									}
								}
							//Exportaciones
							for(c = 0; c < array_length(recurso_nombre) and total_trabajo > 0; c++)
								if recurso_exportado[c]{
									var total = min(total_trabajo, edificio.almacen[c])
									total_trabajo -= total
									edificio.almacen[c] -= total
									while total > 0{
										d = total
										var temp_factor = 1
										if array_length(recurso_tratados_venta[c]) > 0{
											var tratado = recurso_tratados_venta[c, 0]
											temp_factor = tratado.factor
											d = min(total, tratado.cantidad)
											tratado.cantidad -= d
											if tratado.cantidad = 0
												cumplir_tratado(tratado)
										}
										total -= d
										array_add(mes_exportaciones_recurso_num[current_mes], c, d)
										d = floor(temp_factor * d * recurso_precio[c] * 0.9)
										mes_exportaciones[current_mes] += d
										array_add(mes_exportaciones_recurso[current_mes], c, d)
										dinero += d
									}
								}
							//Importacion privada
							for(c = 0; c < array_length(recurso_nombre) and total_trabajo > 0; c++)
								if recurso_importacion_privada[c] > 0{
									var total = min(total_trabajo, recurso_importacion_privada[c])
									total_trabajo -= total
									recurso_importacion_privada[c] -= total
									edificio.almacen[c] += total
									array_add(mes_importaciones_recurso_num[current_mes], c, total)
									while total > 0{
										d = total
										var temp_factor = 1
										if array_length(recurso_tratados_compra[c]) > 0{
											var tratado = recurso_tratados_compra[c, 0]
											temp_factor = tratado.factor
											d = min(total, tratado.cantidad)
											tratado.cantidad -= d
											if tratado.cantidad = 0
												cumplir_tratado(tratado)
										}
										total -= d
										d = floor(d * recurso_precio[c] * 1.1 / temp_factor)
										dinero -= d
										mes_importaciones[current_mes] += d
										array_add(mes_importaciones_recurso[current_mes], c, d)
									}
								}
							//Importaciones anuales
							for(c = 0; c < array_length(recurso_nombre) and total_trabajo > 0; c++){
								var total = min(total_trabajo, floor(recurso_importado[c] / 2 / array_length(edificio_count[13])))
								total_trabajo -= total
								edificio.almacen[c] += total
								array_add(mes_importaciones_recurso_num[current_mes], c, total)
								while total > 0{
									d = total
									var temp_factor = 1
									if array_length(recurso_tratados_compra[c]) > 0{
										var tratado = recurso_tratados_compra[c, 0]
										temp_factor = tratado.factor
										d = min(total, tratado.cantidad)
										tratado.cantidad -= d
										if tratado.cantidad = 0
											cumplir_tratado(tratado)
									}
									total -= d
									d = floor(d * recurso_precio[c] * 1.1 / temp_factor)
									dinero -= d
									mes_importaciones[current_mes] += d
									array_add(mes_importaciones_recurso[current_mes], c, d)
								}
							}
							//Importación fija
							for(c = 0; c < array_length(recurso_nombre) and total_trabajo > 0; c++)
								if recurso_importado_fijo[c] > 0{
									var total = min(total_trabajo, recurso_importado_fijo[c])
									total_trabajo -= total
									recurso_importado_fijo[c] -= total
									edificio.almacen[c] += total
									array_add(mes_importaciones_recurso_num[current_mes], c, total)
									while total > 0{
										d = total
										var temp_factor = 1
										if array_length(recurso_tratados_compra[c]) > 0{
											var tratado = recurso_tratados_compra[c, 0]
											temp_factor = tratado.factor
											d = min(total, tratado.cantidad)
											tratado.cantidad -= d
											if tratado.cantidad = 0
												cumplir_tratado(tratado)
										}
										total -= d
										d = floor(d * recurso_precio[c] * 1.1 / temp_factor)
										dinero -= d
										mes_importaciones[current_mes] += d
										array_add(mes_importaciones_recurso[current_mes], c, d)
									}
								}
						}
					}
					else if var_edificio_nombre = "Rancho"{
						b = floor(b * (1 - clamp(ds_grid_get_mean(contaminacion, edificio.x, edificio.y, edificio.x + width - 1, edificio.y + height - 1), 0, 100) / 200))
						for(c = 0; c < array_length(ganado_produccion[edificio.modo]); c++)
							edificio.almacen[ganado_produccion[edificio.modo, c]] += floor(10 * b / array_length(ganado_produccion[edificio.modo]))
						if (current_mes mod 6) = (edificio.mes_creacion mod 6)
							for(e = 0; e < array_length(ganado_produccion[edificio.modo]); e++){
								c = ganado_produccion[edificio.modo, e]
								if edificio.privado or recurso_exportado[c] or recurso_utilizado[c] > 0 or not edificio.es_almacen{
									d = 200 * array_contains(recurso_comida, c) * edificio.es_almacen
									if edificio.almacen[c] > d
										produccion_edificio(c, edificio, d)
								}
							}
					}
					else if in(var_edificio_nombre, "Comisaría", "Prisión"){
						if var_edificio_nombre = "Prisión" and edificio.modo != 0
							for(c = 0; c < array_length(edificio.clientes); c++){
								var persona = edificio.clientes[c]
								if edificio.modo = 1{
									if adoctrinamiento_prision
										adoctrinar(persona)
									else if persona.educacion < 1
										persona.educacion += random(0.05)
								}
								else if edificio.modo = 2{
									mes_tarifas[current_mes] += pagar(2, edificio)
									persona.felicidad_trabajo = max(0, persona.felicidad_trabajo - 2)
								}
							}
						for(c = 0; c < array_length(edificio.clientes); c++){
							edificio.array_complex[c].a--
							if edificio.array_complex[c].a = 0{
								array_delete(edificio.array_complex, c, 1)
								var persona = edificio.clientes[c]
								array_delete(edificio.clientes, c--, 1)
								persona.preso = false
								cambiar_trabajo(persona, null_edificio)
							}
						}
						if var_edificio_nombre = "Comisaría"
							repeat(irandom(b * (1 + ley_eneabled[11]))){
								var temp_edificio = array_pick(edificio.casas_cerca)
								if temp_edificio.ladron != null_persona and arrestar_persona(temp_edificio.ladron)
									for(c = 0; c < array_length(temp_edificio.familias); c++){
										var familia = temp_edificio.familias[c]
										for_familia(function(persona = null_persona){
											persona.felicidad_crimen = min(100, persona.felicidad_crimen + 4)
										}, familia)
									}
							}
					}
					else if var_edificio_nombre = "Mercado"{
						edificio.count = floor(b)
						for(d = 0; d < array_length(recurso_lujo); d++){
							c = recurso_lujo[d]
							if dia / 360 > recurso_anno[c] and edificio.almacen[c] < edificio.count and not (c = 22 and ley_eneabled[17]) and not (c = 7 and ley_eneabled[18]) and not (c = 4 and ley_eneabled[19]) and not (c = 28 and ley_eneabled[20]){
								e = edificio.almacen[c] + edificio.pedido[c] - edificio.count
								edificio.ganancia += recurso_precio[c] * e
								add_encargo(c, e, edificio)
								edificio.pedido[c] = edificio.count - edificio.almacen[c]
							}
						}
					}
					else if var_edificio_nombre = "Taberna"{
						c = edificio.almacen[22] + edificio.pedido[22] - 20
						edificio.ganancia += recurso_precio[22] * c
						add_encargo(22, c, edificio)
						edificio.pedido[22] = 20 - edificio.almacen[22]
					}
					else if var_edificio_nombre = "Tejar"{
						edificio.almacen[26] += b
						if (current_mes mod 6) = (edificio.mes_creacion mod 6) and edificio.almacen[26] > 0
							produccion_edificio(26, edificio)
					}
					else if var_edificio_nombre = "Pozo Petrolífero"{
						e = b
						var h = b, f = edificio.x + width, g = edificio.y + height
						for(c = edificio.x; c < f; c++){
							for(d = edificio.x; d < g; d++)
								if petroleo[# c, d] > 0{
									if petroleo[# c, d] * edificio.ahorro > h{
										ds_grid_add(petroleo, c, d, -floor(h / edificio.ahorro))
										h = 0
									}
									else{
										h -= floor(petroleo[# c, d] / edificio.ahorro)
										ds_grid_set(petroleo, c, d, 0)
									}
									if h = 0
										break
								}
							if h = 0
								break
						}
						edificio.almacen[27] += e - h
						if e > 0 and h > 0{
							produccion_edificio(27, edificio)
							set_paro(true, edificio)
							while array_length(edificio.trabajadores) > 0{
								var persona = edificio.trabajadores[0]
								cambiar_trabajo(persona, null_edificio)
								buscar_trabajo(persona)
							}
							if edificio.privado{
								destroy_edificio(edificio)
								a--
								continue
							}
						}
						if (current_mes mod 6) = (edificio.mes_creacion mod 6) and edificio.almacen[27] > 0
							produccion_edificio(27, edificio)
					}
					else if var_edificio_nombre = "Bomba de Agua"{
						c = 10
						var temp_inputs = [1, 9, 27], temp_inputs_2 = [12, 25, 40]
						e = -1
						for(d = 0; d < array_length(temp_inputs); d++)
							if edificio.almacen[temp_inputs[d]] * temp_inputs_2[d] > c{
								c = edificio.almacen[temp_inputs[d]] * temp_inputs_2[d]
								e = d
							}
						b = min(c, b)
						if e != -1
							edificio.almacen[temp_inputs[e]] -= ceil(b / temp_inputs_2[e])
						for(d = 0; d < array_length(temp_inputs); d++){
							c = temp_inputs[d]
							edificio.ganancia -= round(recurso_precio[c] * (edificio.almacen[c] + edificio.pedido[c] - 100))
							add_encargo(c, edificio.almacen[c] + edificio.pedido[c] - 100, edificio)
							edificio.pedido[c] = 100 - edificio.almacen[c]
						}
						edificio.count = b
						dia_agua[dia_de_mes] += b
						agua_input += b
					}
					else if var_edificio_nombre = "Planta Termoeléctrica"{
						c = 0
						var temp_inputs = [1, 9, 27], temp_inputs_2 = [12, 25, 40]
						e = -1
						for(d = 0; d < array_length(temp_inputs); d++)
							if edificio.almacen[temp_inputs[d]] * temp_inputs_2[d] > c{
								c = edificio.almacen[temp_inputs[d]] * temp_inputs_2[d]
								e = d
							}
						b = min(c, b)
						if e != -1
							edificio.almacen[temp_inputs[e]] -= ceil(b / temp_inputs_2[e])
						for(d = 0; d < array_length(temp_inputs); d++){
							c = temp_inputs[d]
							edificio.ganancia -= round(recurso_precio[c] * (edificio.almacen[c] + edificio.pedido[c] - 100))
							add_encargo(c, edificio.almacen[c] + edificio.pedido[c] - 100, edificio)
							edificio.pedido[c] = 100 - edificio.almacen[c]
						}
						edificio.count = b
						dia_energia[dia_de_mes] += b
						energia_input += b
					}
					else if var_edificio_nombre = "Oficina de Bomberos"{
						if b > 0{
							var flag = false
							e = b
							for(c = 20; c >= 0; c--){
								for(d = 0; d < array_length(edificios_por_mantenimiento[c]); d++){
									var temp_edificio = edificios_por_mantenimiento[c, d]
									if temp_edificio.seguro_fuego < 2{
										temp_edificio.seguro_fuego = 6
										if --e = 0{
											flag = true
											break
										}
									}
							}
							if flag
								break
							}
						}
					}
					else if var_edificio_nombre = "Banco"{
						if b > 0{
							var temp_precio = 0, familia_array = [null_familia]
							array_pop(familia_array)
							for(c = 0; c < array_length(familias); c++)
								if not familias[c].banco and familias[c].riqueza > 0
									array_push(familia_array, familias[c])
							array_sort(familia_array, function(a = null_familia, b = null_familia){return b.riqueza - a.riqueza})
							repeat(b){
								var familia = array_shift(familia_array)
								temp_precio += irandom(ceil(familia.riqueza * 0.03))
								familia.banco = true
								familia.riqueza += irandom(ceil(familia.riqueza * 0.01))
							}
							if temp_precio > 0
								mes_renta[current_mes] += pagar(temp_precio, edificio)
						}
					}
					else if in(var_edificio_nombre, "Periódico", "Antena de Radio", "Estudio de Televisión"){
						if edificio.modo = 0
							c = b
						else if edificio.modo = 1{
							c = floor(b / 2)
							campanna++
						}
						else if edificio.modo = 2{
							c = floor(b / 2)
							mes_tarifas[current_mes] += pagar(10 * floor(b / 2) / (floor(b / 2) + radioemisoras), edificio)
						}
						else if edificio.modo < 0{
							candidatos[-edificio.modo].candidato_popularidad *= 0.9
							edificio.ganancia -= 50
							dinero -= 50
							mes_mantenimiento[current_mes] += 50
							c = floor(b / 2)
						}
						if var_edificio_nombre = "Antena de Radio"{
							radioemisoras += c
							dia_radioemisoras[dia_de_mes] += c
						}
						else{
							television += c
							dia_television[dia_de_mes] += c
						}
					}
					else if var_edificio_nombre = "Paneles Solares"{
						c = round(100 * b)
						edificio.count = c
						dia_energia[dia_de_mes] += c
						energia_input += c
					}
					else if var_edificio_nombre = "Depósito de Taxis"{
						edificio.count = b
						e = floor(b / array_length(edificio.carreteras))
						for(c = 0; c < array_length(edificio.carreteras); c++){
							edificio.carreteras[c].dia_taxis[dia_de_mes] += e
							edificio.carreteras[c].taxis += e
						}
					}
					else if in(var_edificio_nombre, "Biblioteca", "Universidad"){
						if edificio.modo > 1{
							c = edificio_categoria[5, edificio.modo - 2]
							repeat(floor(b * (edificio.presupuesto + 3 * (var_edificio_nombre = "Universidad"))))
								edificio_experiencia[c] = 2 - 0.99 * (2 - edificio_experiencia[c])
						}
					}
					else if var_edificio_nombre = "Escuela Naval"{
						dia_naval[dia_de_mes] += b
						naval += b
					}
					for(c = 0; c < array_length(edificio.input_id); c++)
						if edificio.input_num[c] > 0
							edificio.almacen[edificio.input_id[c]] -= b * edificio.input_num[c]
					for(c = 0; c < array_length(edificio.output_id); c++)
						if edificio.output_num[c] > 0
							edificio.almacen[edificio.output_id[c]] += b * edificio.output_num[c]
					if (current_mes mod 6) = (edificio.mes_creacion mod 6) and var_edificio_nombre != "Muelle" and array_length(edificio.input_id) > 0{
						for(c = 0; c < array_length(edificio.input_id); c++)
							if edificio.input_num[c] > 0{
								d = edificio.input_id[c]
								e = floor(max(edificio.almacen[d] + edificio.pedido[d], edificio.input_num[c] * edificio.trabajo_mes / 5 * (0.8 + 0.1 * edificio.presupuesto) * edificio.eficiencia * edificio_experiencia[index] * edificio_industria_velocidad[index] * (edificio.energia ? 0.75 + min(0.5, energia_input / energia_output) : 1) * (edificio.agua ? 0.75 + min(0.5, agua_input / agua_output) : 1)))
								edificio.ganancia -= recurso_precio[d] * (edificio.almacen[d] + edificio.pedido[d] - e)
								add_encargo(d, floor(edificio.almacen[d] + edificio.pedido[d] - e), edificio)
								if edificio.privado and ley_eneabled[14]
									recurso_importacion_privada[d] += floor(e - edificio.almacen[d] - edificio.pedido[d])
								edificio.pedido[d] = floor(e - edificio.almacen[d])
							}
						for(c = 0; c < array_length(edificio.output_id); c++)
							if edificio.output_num[c] > 0{
								d = edificio.output_id[c]
								e = 200 * array_contains(recurso_comida, d) * edificio.es_almacen
								if edificio.almacen[d] > e and edificio.almacen[d] >= 1{
									edificio.ganancia += recurso_precio[d] * (floor(edificio.almacen[d]) - e)
									add_encargo(d, floor(edificio.almacen[d] - e), edificio)
									edificio.almacen[d] = e
								}
							}
					}
				}
			}
			//Casas
			if edificio_es_casa[index] and (array_length(edificio.familias) > 0 or var_edificio_nombre = "Toma"){
				if var_edificio_nombre = "Toma" and array_length(edificio.familias) = 0{
					destroy_edificio(edificio)
					a--
					continue
				}
				set_calidad_vivienda(edificio)
				mes_renta[current_mes] += pagar(edificio.vivienda_renta * array_length(edificio.familias), edificio)
				if var_edificio_nombre != "Toma" and ley_eneabled[8] and not edificio.agua
					add_tuberias(edificio)
				var poblacion = 0
				for(b = 0; b < array_length(edificio.familias); b++){
					var familia = edificio.familias[b]
					poblacion += familia.integrantes
					familia.banco = false
					if ley_eneabled[9] and (familia.padre.religion or familia.madre.religion or ley_eneabled[16]){
						c = array_length(familia.hijos)
						familia.riqueza += c
						dinero -= c
						mes_mantenimiento[current_mes] += c
					}
				}
				if poblacion > 0{
					var consumo = floor(poblacion * (1 + 1))
					//Conseguir alimento
					for(b = 0; b < array_length(edificio_almacen_index); b++)
						if array_length(almacenes[edificio_almacen_index[b]]) > 0{
							var tienda = array_pick(almacenes[edificio_almacen_index[b]])
							for(c = 0; c < array_length(recurso_comida); c++){
								d = recurso_comida[c]
								if edificio.almacen[d] < consumo and tienda.almacen[d] > 0{
									e = consumo - edificio.almacen[d]
									if tienda.almacen[d] >= e{
										edificio.almacen[d] += e
										tienda.almacen[d] -= e
									}
									else{
										edificio.almacen[d] += tienda.almacen[d]
										e = tienda.almacen[d]
										tienda.almacen[d] = 0
									}
									if tienda.privado{
										if recurso_banda[d]
											var temp_precio = round(e * clamp(recurso_precio[d], recurso_banda_min[d], recurso_banda_max[d]))
										else
											temp_precio = round(e * recurso_precio[d])
										dinero -= temp_precio
										dinero_privado += temp_precio
										mes_compra_interna[current_mes] += temp_precio
										array_add(mes_compra_recurso[current_mes], d, temp_precio)
										array_add(mes_compra_recurso_num[current_mes], d, e)
										edificio.empresa.dinero += temp_precio
									}
								}
							}
						}
					//Repartir comida
					var fel_comida = 0, comida_total = 0, comida_variedad = 0, flag = true, comida_proporcion = []
					for(b = 0; b < array_length(recurso_comida); b++){
						c = edificio.almacen[recurso_comida[b]]
						d = clamp(c / poblacion, 0, 1)
						comida_total += c
						array_push(comida_proporcion, d)
						comida_variedad += d
					}
					//Demanda satisfecha
					if comida_total >= poblacion{
						fel_comida = min(100, 20 + 15 * comida_variedad)
						d = 0
						for(b = 0; b < array_length(recurso_comida); b++){
							c = recurso_comida[b]
							edificio.almacen[c] -= floor(poblacion * comida_proporcion[b] / comida_variedad)
							d += recurso_precio[c] * comida_proporcion[b] / comida_variedad
						}
						
						for(b = 0; b < array_length(edificio.familias); b++){
							var familia = edificio.familias[b]
							if not ley_eneabled[4] or not (familia.padre.religion or familia.madre.religion or ley_eneabled[16]){
								c = min(familia.riqueza, floor(familia.integrantes * d))
								familia.riqueza -= c
								if edificio.privado{
									dinero_privado += c
									edificio.empresa.dinero += c
									mes_comida_privada[current_mes] += c
								}
								else{
									dinero += c
									mes_venta_comida[current_mes] += c
								}
							}
						}
					}
					//Demanda insatisfecha
					else{
						fel_comida = min(100, 20 + 15 * comida_variedad) * comida_total / poblacion
						d = 0
						for(b = 0; b < array_length(recurso_comida); b++){
							c = recurso_comida[b]
							d += recurso_precio[c] * edificio.almacen[c] / poblacion
							edificio.almacen[c] = 0
						}
						for(b = 0; b < array_length(edificio.familias); b++){
							var familia = edificio.familias[b]
							if not ley_eneabled[4] or not (familia.padre.religion or familia.madre.religion or ley_eneabled[16]){
								c = min(familia.riqueza, floor(familia.integrantes * d))
								familia.riqueza -= c
								if edificio.privado{
									dinero_privado += c
									edificio.empresa.dinero += c
									mes_comida_privada[current_mes] += c
								}
								else{
									dinero += c
									mes_venta_comida[current_mes] += c
								}
							}
						}
					}
					//Actualizar felicidad por alimentación y pagar renta
					for(b = 0; b < array_length(edificio.familias); b++){
						var familia = edificio.familias[b]
						familia.felicidad_alimento = floor((familia.felicidad_alimento * 2 + fel_comida) / 3)
						if irandom(15) > familia.felicidad_alimento{
							flag = false
							if familia.padre != null_persona{
								flag = destroy_persona(familia.padre,, "Padre muerto de inanicion")
								if exigencia_pedida[2]
									fallar_exigencia(2)
								mes_muertos_inanicion[current_mes] ++
							}
							if not flag and familia.madre != null_persona{
								flag = destroy_persona(familia.madre,, "Madre muerta de inanicion")
								if exigencia_pedida[2]
									fallar_exigencia(2)
								mes_muertos_inanicion[current_mes]++
							}
							if not flag
								for(c = 0; not flag and c < array_length(familia.hijos); c++)
									if brandom(){
										flag = destroy_persona(familia.hijos[c],, "Hijo muerto de inanicion")
										if exigencia_pedida[2]
											fallar_exigencia(2)
										mes_muertos_inanicion[current_mes]++
										c--
									}
							if flag{
								for(c = 0; c < array_length(personas); c++)
									personas[c].felicidad_temporal -= 2
								b--
								continue
							}
						}
					}
					if edificio != homeless
						for(b = 0; b < array_length(edificio.familias); b++){
							var familia = edificio.familias[b]
							familia.riqueza -= edificio.vivienda_renta
							if edificio.vivienda_renta > 0 and familia.riqueza <= -30{
								cambiar_casa(familia, homeless)
								b--
							}
						}
				}
			}
			//Edificios médicos
			if edificio_es_medico[index]{
				if edificio_nombre[index] = "Hospital" and edificio.modo = 2{
					edificio_experiencia[7] = 2 - 0.99 * (2 - edificio_experiencia[7])
					edificio_experiencia[64] = 2 - 0.99 * (2 - edificio_experiencia[64])
				}
				//Curar pacientes
				repeat(min(array_length(edificio.clientes), ceil(random(b)))){
					var persona = array_shift(edificio.clientes)
					persona.felicidad_salud = edificio_servicio_calidad[index]
					persona.medico = null_edificio
					traer_paciente_en_espera(edificio)
				}
				//Pacientes no curados
				for(b = 0; b < array_length(edificio.clientes); b++){
					var persona = edificio.clientes[b]
					persona.felicidad_salud = floor(persona.felicidad_salud * 0.6 - 0.2 * (persona.edad < 12))
					if irandom(5) > persona.felicidad_salud{
						var familia = persona.familia
						for_familia(function(persona = null_persona){
							persona.felicidad_salud = floor(persona.felicidad_salud * 0.75)
							persona.felicidad_temporal -= 50
						}, familia)
						if not in(persona.trabajo, null_edificio, jubilado, delincuente, prostituta)
							for(c = 0; c < array_length(persona.trabajo.trabajadores); c++)
								persona.trabajo.trabajadores[c].felicidad_salud = floor(persona.trabajo.trabajadores[c].felicidad_salud * 0.9)
						if persona.escuela != null_edificio{
							for(c = 0; c < array_length(persona.escuela.trabajadores); c++)
								persona.escuela.trabajadores[c].felicidad_salud = floor(persona.escuela.trabajadores[c].felicidad_salud * 0.95)
							for(c = 0; c < array_length(persona.escuela.clientes); c++)
								persona.escuela.clientes[c].felicidad_salud = floor(persona.escuela.clientes[c].felicidad_salud * 0.95)
						}
						destroy_persona(persona,, $"Paciente muerto ({edificio.nombre})")
						mes_muertos_enfermos[current_mes]++
						b--
						traer_paciente_en_espera(edificio)
					}
					else if brandom(){
						array_remove(edificio.clientes, persona, "paciente curado")
						persona.medico = null_edificio
						b--
						traer_paciente_en_espera(edificio)
					}
				}
			}
			//Edificios de ocio y religiosos
			if edificio_es_ocio[index] or edificio_es_iglesia[index]{
				set_calidad_servicio(edificio)
				if edificio.trabajadores_max = 0
					edificio.count = 0
				else
					edificio.count = max(0, floor(edificio.count * (1 - b / edificio.trabajadores_max)))
			}
			edificio.trabajo_mes = 30 * array_length(edificio.trabajadores)
		}
		#region Bancarrota
			//Entrar a bancarrota
			if not deuda and dinero < 0{
				deuda = true
				deuda_dia = dia
				show_message("Te has quedado sin dinero, tienes dos años para pagar tu deuda externa")
			}
			//Salid de bancarrota
			if deuda and dinero > 0
				deuda = false
			//Perder por bancarrota
			if deuda and dia = deuda_dia + 730{
				show_message("HAS PERDIDO\n\nNo has sido capaz de pagar tu deuda externa a tiempo")
				if show_question("¿Volver a jugar?")
					game_restart()
				else
					game_end()
			}
		#endregion
		for(var a = 0; a < array_length(edificio_almacen_index); a++)
			for(var b = 0; b < array_length(almacenes[edificio_almacen_index[a]]); b++){
				var temp_array = almacenes[edificio_almacen_index[a], b].almacen
				for(c = 0; c < array_length(recurso_comida); c++)
					var_total_comida += temp_array[recurso_comida[c]]
			}
		var_total_comida = floor(30 * var_total_comida / array_length(personas))
	}
}
#region Abreviatura
	//Añadir familia
	if keyboard_check(vk_lcontrol) and (keyboard_check_pressed(ord("F")) or (keyboard_check(ord("F")) and keyboard_check(vk_lshift)))
		add_familia()
	//Reiniciar
	if keyboard_check_pressed(ord("R")) and keyboard_check(vk_lcontrol)
		game_restart()
	//Salir
	if keyboard_check_pressed(vk_escape){
		menu = not menu
		close_show()
		build_sel = false
		build_terreno = false
		sel_build = false
		sel_info = false
		sel_comisaria = false
	}
	//Pantalla completa
	if keyboard_check_pressed(vk_f4){
		window_set_fullscreen(not window_get_fullscreen())
		ini_open(roaming + "config.txt")
		ini_write_real("MAIN", "fullscreen", window_get_fullscreen())
		ini_close()
	}
	//Dinero gratis
	if keyboard_check(vk_lshift) and keyboard_check(ord("4")){
		dinero += 1000
		mes_herencia[current_mes] += 1000
	}
	//Acelerar elección
	if keyboard_check_pressed(ord("E")) and keyboard_check(vk_lcontrol)
		dia = 6 * 360 * ceil(dia / (6 * 360)) - 1
	//Inmigrantes gratis
	if keyboard_check(ord("P")) and keyboard_check(vk_lcontrol){
		var familia = array_pick(familias)
		familia.riqueza += 100
	}
	//Activar grilla
	if keyboard_check_pressed(ord("Q"))
		show_grid = not show_grid
	if show_string != ""{
		show_string = string_trim(show_string)
		draw_set_alpha(0.5)
		draw_set_color(c_black)
		draw_rectangle(0, 0, string_width(show_string), string_height(show_string), false)
		draw_set_color(c_white)
		draw_text(0, 0, show_string)
		draw_set_alpha(1)
	}
	if mouse_string != ""{
		mouse_string = string_trim(mouse_string)
		var width = string_width(mouse_string), height = string_height(mouse_string)
		if mouse_x + width < room_width
			var xx1 = mouse_x, xx2 = mouse_x + width
		else{
			xx1 = room_width - width
			xx2 = room_width
		}
		if mouse_y + height - 20 < room_height
			var yy1 = mouse_y - 20, yy2 = mouse_y + height - 20
		else{
			yy1 = room_height - height
			yy2 = room_height
		}
		draw_set_color(c_ltgray)
		draw_rectangle(xx1, yy1, xx2, yy2, false)
		draw_set_color(c_black)
		draw_rectangle(xx1, yy1, xx2, yy2, true)
		draw_text(xx1, yy1, mouse_string)
	}
#endregion
//Tutorial
if tutorial_bool and not menu{
	draw_set_color(c_black)
	draw_set_alpha(0.5)
	draw_rectangle(0, 0, tutorial_xbox[tutorial], room_height, false)
	draw_rectangle(tutorial_xbox[tutorial] + 1, 0, room_width, tutorial_ybox[tutorial], false)
	draw_rectangle(tutorial_xbox[tutorial] + 1, tutorial_hbox[tutorial], room_width, room_height, false)
	draw_rectangle(tutorial_wbox[tutorial], tutorial_ybox[tutorial] + 1, room_width, tutorial_hbox[tutorial] - 1, false)
	draw_set_color(c_white)
	draw_set_alpha(1)
	draw_set_font(font_big)
	draw_text(tutorial_xtext[tutorial], tutorial_ytext[tutorial], tutorial_text[tutorial])
	draw_set_font(font_normal)
	if tutorial_complete or (tutorial_enter[tutorial] and keyboard_check_pressed(vk_enter)){
		tutorial_complete = false
		tutorial++
		if tutorial = 4{
			tile_width = 32
			tile_height = 16
			var a = edificios[0].x, b = edificios[0].y
			xpos = (a - b) * tile_width - room_width / 2
			ypos = (a + b) * tile_height - room_height / 2
			min_camx = max(0, floor((xpos / tile_width + ypos / tile_height) / 2))
			min_camy = max(0, floor((ypos / tile_height - (xpos + room_width) / tile_width) / 2))
			max_camx = min(xsize, ceil(((room_width + xpos) / tile_width + (room_height + ypos) / tile_height) / 2))
			max_camy = min(ysize, ceil(((room_height + ypos) / tile_height - xpos / tile_width) / 2))
		}
		else if tutorial = 9
			velocidad = 2.5
		else if tutorial = 10{
			velocidad = 1
			var edificio = edificio_count[8, array_length(edificio_count[8]) - 1], a = edificio.x, b = edificio.y
			xpos = (a - b) * tile_width - room_width / 2
			ypos = (a + b) * tile_height - room_height / 2
			min_camx = max(0, floor((xpos / tile_width + ypos / tile_height) / 2))
			min_camy = max(0, floor((ypos / tile_height - (xpos + room_width) / tile_width) / 2))
			max_camx = min(xsize, ceil(((room_width + xpos) / tile_width + (room_height + ypos) / tile_height) / 2))
			max_camy = min(ysize, ceil(((room_height + ypos) / tile_height - xpos / tile_width) / 2))
			tutorial_set(10,,,,, room_width / 2 - 64, room_height / 2, room_width / 2 + 64, room_height / 2 + 64)
		}
		if tutorial = 22
			sel_build = false
		if tutorial = array_length(tutorial_text)
			tutorial_bool = false
	}
}
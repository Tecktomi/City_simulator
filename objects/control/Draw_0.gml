if window_get_cursor() != cursor
	window_set_cursor(cursor)
cursor = cr_arrow
if menu_principal{
	pos = 100
	draw_set_font(font_big)
	if draw_boton(room_width / 2, pos, "Empezar partida", true){
		draw_set_font(Font1)
		draw_set_halign(fa_left)
		menu_principal = false
	}
	pos += 10
	if draw_boton(room_width / 2, pos, $"Fecha inicial: {1800  + floor(dia / 365)}", true,,,,false)
		if keyboard_check(vk_lshift)
			dia = max(0, dia - 365)
		else
			dia = min(dia + 365, 73000)
	pos += 20
	if draw_boton(room_width / 2, pos, "Tutorial", true){
		draw_set_font(Font1)
		draw_set_halign(fa_left)
		tutorial = 0
		tutorial_bool = true
		velocidad = 0
		menu_principal = false
	}
	pos += 20
	if keyboard_check_pressed(vk_escape) or draw_boton(room_width / 2, pos, "Salir", true)
		game_end()
}
else{
	#region Visual
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
		for(var a = 0; a < xsize / 16; a++)
			for(var b = 0; b < ysize / 16; b++)
				if chunk_update[a, b]{
					var surf = surface_create(tile_width * 32, tile_height * 32)
					surface_set_target(surf)
					draw_clear_alpha(c_black, 0)
					for(var c = 0; c < 16; c++)
						for(var d = 0; d < 16; d++)
							draw_sprite_ext(spr_tile, 0, tile_width * 16 + (c - d) * tile_width, (c + d) * tile_height, 1, 1, 0, altura_color[a * 16 + c, b * 16 + d], 1)
					var sprite = sprite_create_from_surface(surf, 0, 0, tile_width * 32, tile_height * 32, true, false, 0, 0)
					array_set(chunk[a], b, sprite)
					surface_reset_target()
					surface_free(surf)
					array_set(chunk_update[a], b, false)
				}
		world_update = false
		tile_width = prev_tile_width
		tile_height = prev_tile_width / 2
	}
	#region Dibujo de mundo
		for(var a = floor(min_camx / 16); a < ceil(max_camx / 16); a++)
			for(var b = floor(min_camy / 16); b < ceil(max_camy / 16); b++)
				draw_sprite_stretched(chunk[a, b], 0, (a - b - 1) * 16 * tile_width - xpos, (a + b) * 16 * tile_height - ypos, 32 * tile_width, 32 * tile_height)
		if show_grid{
			draw_set_color(c_ltgray)
			for(var a = 0; a < xsize; a++)
				draw_line(a * tile_width - xpos, a * tile_height - ypos, (a - ysize) * tile_width - xpos, (a + ysize) * tile_height - ypos)
			for(var a = 0; a < ysize; a++)
				draw_line(-a * tile_width - xpos, a * tile_height - ypos, (xsize - a) * tile_width - xpos, (xsize + a) * tile_height - ypos)
	}
	#endregion
	#region vistas
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
	#endregion
	//Dibujo de arboles y edificios
	for(var a = min_camx; a < max_camx; a++)
		for(var b = min_camy; b < max_camy; b++){
			if bosque[a, b]{
				draw_set_alpha(bosque_alpha[a, b])
				draw_sprite_stretched(spr_arbol, 0, (a - b - 1) * tile_width - xpos, (a + b - 2) * tile_height - ypos, tile_width * 2, tile_width * 2)
				draw_set_alpha(1)
			}
			if bool_draw_edificio[a, b]
				if edificio_sprite[id_edificio[a, b].tipo]
					draw_sprite_stretched(edificio_sprite_id[id_edificio[a, b].tipo], draw_edificio_flip[a, b], (a - b - 1) * tile_width - xpos, (a + b - 2) * tile_height - ypos, tile_width * 2, tile_width * 2)
				else{
					var edificio = draw_edificio[a, b], c = edificio.x, d = edificio.y, e = edificio.tipo, width = edificio.width, height = edificio.height, temp_rotado = edificio.rotado
					draw_set_color(make_color_hsv(edificio_color[e], 255, 255))
					draw_rombo((c - d) * tile_width - xpos, (c + d) * tile_height - ypos, (c - d - height) * tile_width - xpos, (c + d + height) * tile_height - ypos, (c - d - height + width) * tile_width - xpos, (c + d + height + width) * tile_height - ypos, (c - d + width) * tile_width - xpos, (c + d + width) * tile_height - ypos, false)
					draw_set_color(c_white)
					draw_rombo((c - d) * tile_width - xpos, (c + d) * tile_height - ypos, (c - d - height) * tile_width - xpos, (c + d + height) * tile_height - ypos, (c - d - height + width) * tile_width - xpos, (c + d + height + width) * tile_height - ypos, (c - d + width) * tile_width - xpos, (c + d + width) * tile_height - ypos, true)
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
			if bool_draw_construccion[a, b]{
				var next_build = draw_construccion[a, b], e = next_build.id, width = next_build.width, height = next_build.height, c = next_build.x, d = next_build.y, temp_rotado = next_build.rotado, var_edificio_nombre = edificio_nombre[next_build.id]
				draw_set_color(make_color_hsv(edificio_color[e], 255, 255))
				draw_set_alpha(0.5)
				draw_rombo((c - d) * tile_width - xpos, (c + d) * tile_height - ypos, (c - d - height) * tile_width - xpos, (c + d + height) * tile_height - ypos, (c - d + width - height) * tile_width - xpos, (c + d + width + height) * tile_height - ypos, (c - d + width) * tile_width - xpos, (c + d + width) * tile_height - ypos, false)
				draw_set_alpha(1)
				draw_rombo((c - d) * tile_width - xpos, (c + d) * tile_height - ypos, (c - d - height) * tile_width - xpos, (c + d + height) * tile_height - ypos, (c - d + width - height) * tile_width - xpos, (c + d + width + height) * tile_height - ypos, (c - d + width) * tile_width - xpos, (c + d + width) * tile_height - ypos, true)
				draw_set_color(c_white)
				draw_text((c - d) * tile_width - xpos, (c + d) * tile_height - ypos, $"{var_edificio_nombre}{var_edificio_nombre = "Mina" ? "\n" + recurso_nombre[recurso_mineral[next_build.tipo]] : ""}{var_edificio_nombre = "Granja" ? "\n" + recurso_nombre[recurso_cultivo[next_build.tipo]] : ""}{var_edificio_nombre = "Rancho" ? "\n" + ganado_nombre[next_build.tipo] : ""}")
			}	
		}
	#region vistas post-dibujo
		if keyboard_check(ord("V"))
			draw_gradiente(0, 4)
		if keyboard_check(ord("T"))
		draw_gradiente(0, 5)
	#endregion
	//Información general
	draw_set_alpha(0.5)
	draw_set_color(c_ltgray)
	var text = $"FPS: {fps}\n{fecha(dia)}\n{array_length(personas)} habitantes\n$ {floor(dinero)}"
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
		velocidad = 2.5
	pos -= 20
	for(var a = 0; a < array_length(exigencia_nombre); a++)
		if exigencia_pedida[a]
			draw_text_pos(0, pos, $"{exigencia_nombre[a]} {exigencia[a].expiracion - dia} días restantes")
	draw_set_valign(fa_top)
	draw_set_alpha(1)
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
		draw_set_font(Font1)
		pos += 40
		if draw_boton(room_width / 2, pos, "Salir"){
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
			if draw_boton(room_width / 2, pos, "1120 x 630", , , function f1(){draw_set_halign(fa_left);draw_text(mouse_x + 10, mouse_y, "1120 x 630");draw_set_halign(fa_center)}){
				window_set_size(1120, 630)
				window_center()
				ini_open(roaming + "config.txt")
				ini_write_real("MAIN", "view_width", 1120)
				ini_write_real("MAIN", "view_height", 630)
				ini_close()
			}
			if draw_boton(room_width / 2, pos, "1280 x 720", , , function f2(){draw_set_halign(fa_left);draw_text(mouse_x + 10, mouse_y, "1280 x 720");draw_set_halign(fa_center)}){
				window_set_size(1280, 720)
				window_center()
				ini_open(roaming + "config.txt")
				ini_write_real("MAIN", "view_width", 1280)
				ini_write_real("MAIN", "view_height", 720)
				ini_close()
			}
			if draw_boton(room_width / 2, pos, "1366 x 768", , , function f3(){draw_set_halign(fa_left);draw_text(mouse_x + 10, mouse_y, "1366 x 768");draw_set_halign(fa_center)}){
				window_set_size(1366, 768)
				window_center()
				ini_open(roaming + "config.txt")
				ini_write_real("MAIN", "view_width", 1366)
				ini_write_real("MAIN", "view_height", 768)
				ini_close()
			}
			if draw_boton(room_width / 2, pos, "1600 x 900", , , function f4(){draw_set_halign(fa_left);draw_text(mouse_x + 10, mouse_y, "1600 x 900");draw_set_halign(fa_center)}){
				window_set_size(1600, 900)
				window_center()
				ini_open(roaming + "config.txt")
				ini_write_real("MAIN", "view_width", 1600)
				ini_write_real("MAIN", "view_height", 900)
				ini_close()
			}
			if draw_boton(room_width / 2, pos, "1920 x 1080", , , function f5(){draw_set_halign(fa_left);draw_text(mouse_x + 10, mouse_y, "1920 x 1080");draw_set_halign(fa_center)}){
				window_set_size(1920, 1080)
				window_center()
				ini_open(roaming + "config.txt")
				ini_write_real("MAIN", "view_width", 1920)
				ini_write_real("MAIN", "view_height", 1080)
				ini_close()
			}
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
	if mouse_check_button_pressed(mb_right) and not build_sel{
		close_show()
		sel_build = not sel_build
		sel_info = false
		build_type = 0
		ministerio = -1
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
				build_categoria = a
			}
			b += last_width + 10
		}
		b = 100
		for(var a = 0; a < array_length(ministerio_nombre); a++){
			if draw_boton(b, room_height - 100, ministerio_nombre[a], true){
				close_show()
				ministerio = a
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
			for(var a = 0; a < array_length(edificio_categoria[build_categoria]); a++){
				b = edificio_categoria[build_categoria, a]
				if floor(dia / 365) >= edificio_anno[b] and draw_boton(110, pos, $"{edificio_nombre[b]} ${edificio_precio[b]}", , ,
					function(b){
						draw_set_valign(fa_bottom)
						var text = ""
						for(var a = 0; a < array_length(edificio_recursos_id[b]); a++)
							text += $"{recurso_nombre[edificio_recursos_id[b, a]]}: {edificio_recursos_num[b, a]}   "
						draw_text(100, room_height - 100, text + $"\n{edificio_es_casa[b] ? "Espacio para " + string(edificio_familias_max[b]) + " familias\n" : ""}{
							edificio_es_trabajo[b] ? "Necesita " + string(edificio_trabajadores_max[b]) + " trabajadores " + ((edificio_trabajo_educacion[b] = 0) ? "sin educación" : "con " + educacion_nombre[edificio_trabajo_educacion[b]]) + "\n" : ""}{
							edificio_es_escuela[b] ? "Enseña a " + string(edificio_clientes_max[b]) + " alumnos\n" : ""}{
							edificio_es_medico[b] ? "Atiende a " + string(edificio_clientes_max[b]) + " pacientes\n" : ""}{
							edificio_es_ocio[b] or edificio_es_iglesia[b] ? "Acepta " + string(edificio_clientes_max[b]) + " visitantes\n" : ""}{edificio_descripcion[b]}")
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
		//Ministerios
		else{
			draw_text_pos(100, pos, $"Ministerio de {ministerio_nombre[ministerio]}")
			pos += 20
			//Ministerio de Población
			if ministerio = 0{
				var temp_nacimientos = 0, temp_muertos = 0, temp_inmigrados = 0, temp_emigrados = 0, temp_inanicion = 0, temp_enfermos = 0
				for(var a = 0; a < 12; a++){
					temp_nacimientos += mes_nacimientos[a]
					temp_muertos += mes_muertos[a]
					temp_inmigrados += mes_inmigrantes[a]
					temp_emigrados += mes_emigrantes[a]
					temp_inanicion += mes_inanicion[a]
					temp_enfermos += mes_enfermos[a]
				}
				var temp_total = temp_nacimientos + temp_inmigrados - temp_muertos - temp_emigrados - temp_inanicion - temp_enfermos
				draw_text_pos(110, pos, $"Población: {array_length(personas)}")
				if temp_total >= 0
					var temp_text = "Crecimiento "
				else
					temp_text = "Disminución "
				if draw_menu(120, pos, $"{temp_text} {abs(temp_total)}", 1, , true){
					draw_set_color(c_green)
					draw_text_pos(130, pos, $"Nacimientos: {temp_nacimientos}")
					draw_text_pos(130, pos, $"Inmigración: {temp_inmigrados}")
					draw_set_color(c_red)
					if draw_menu(130, pos, $"Muertos: {temp_muertos + temp_inanicion + temp_enfermos}", 2){
						draw_text_pos(140, pos, $"Causas naturales: {temp_muertos}")
						draw_text_pos(140, pos, $"Inanición: {temp_inanicion}")
						if draw_boton(140, pos, $"Enfermedades: {temp_enfermos}")
							ministerio = 3
					}
					draw_text_pos(130, pos, $"Emigración: {temp_emigrados}")
					draw_set_color(c_black)
				}
				//Gráfico de edades
				if draw_menu(120, pos, "Edad", 0, , true){
					var temp_edad, maxi = 0
					for(var a = 0; a <= 16; a++){
						temp_edad[false, a] = 0
						temp_edad[true, a] = 0
					}
					for(var a = 0; a < array_length(personas); a++)
						temp_edad[personas[a].sexo, min(16, floor(personas[a].edad / 5))]++
					for(var a = 0; a <= 16; a++)
						maxi = max(temp_edad[false, a], max(temp_edad[true, a], maxi))
					draw_set_halign(fa_center)
					draw_set_font(font_small)
					for(var a = 0; a <= 16; a++){
						draw_set_color(c_fuchsia)
						draw_rectangle(800, 300 - a * 10, 800 - 100 * temp_edad[true, a] / maxi, 309 - a * 10, false)
						draw_set_color(c_aqua)
						draw_rectangle(840, 300 - a * 10, 840 + 100 * temp_edad[false, a] / maxi, 309 - a * 10, false)
						draw_set_color(c_black)
						draw_text(820, 300 - a * 10, string(a * 5) + "-" + string(a * 5 + 4))
					}
					draw_set_halign(fa_left)
					draw_set_font(Font1)
				}
				//Felicidad
				if draw_menu(120, pos, $"Felicidad: {floor(felicidad_total)}", 3, , true){
					draw_text_pos(130, pos, $"Mínimo esperado: {felicidad_minima}")
					var fel_tra = 0, fel_edu = 0, fel_viv = 0, fel_sal = 0, num_tra = 0, num_edu = 0, fel_oci = 0, fel_ali = 0, c = 0, fel_tran = 0, num_tran = 0, fel_rel = 0, num_rel = 0, fel_ley = 0, fel_cri = 0, fel_temp = 0, len = array_length(personas)
					b = 0
					for(var a = 0; a < array_length(personas); a++){
						var persona = personas[a]
						fel_sal += persona.felicidad_salud
						fel_viv += persona.familia.felicidad_vivienda
						fel_ali += persona.familia.felicidad_alimento
						fel_oci += persona.felicidad_ocio
						fel_ley += persona.felicidad_ley
						fel_cri += persona.felicidad_crimen
						fel_temp += persona.felicidad_temporal
						if persona.familia.casa != homeless and (personas[a].escuela != null_edificio or not in(persona.trabajo, null_edificio, jubilado, delincuente)){
							fel_tran += persona.felicidad_transporte
							num_tran++
						}
						if persona.es_hijo{
							fel_edu += persona.felicidad_educacion
							num_edu++
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
					draw_text_pos(130, pos, $"Legislación: {floor(fel_ley / len)}")
					draw_text_pos(130, pos, $"Delincuencia: {floor(fel_cri / len)}")
					draw_text_pos(130, pos, $"Eventos recientes: {floor(fel_temp / len)}")
				}
				pos = 120
				if mouse_wheel_up()
					show_scroll--
				if mouse_wheel_down()
					show_scroll++
				show_scroll = max(0, min(show_scroll, array_length(personas) - 20))
				var max_width = 0
				for(var a = 0; a < min(20, array_length(personas)); a++){
					if draw_boton(400, pos, name(personas[a + show_scroll])){
						sel_build = false
						sel_info = true
						sel_tipo = 2
						sel_persona = personas[a + show_scroll]
					}
					max_width = max(max_width, string_width(name(personas[a + show_scroll])))
				}
				pos = 120
				for(var a = 0; a < 20; a++)
					draw_text_pos(410 + max_width, pos, $"{personas[a + show_scroll].edad} años")
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
						if draw_menu(110, pos, $"{edificio_nombre[a]}: {temp_array[a]} habitantes ({floor(temp_array[a] * 100 / array_length(personas))}%)", a)
							for(b = 0; b < array_length(edificio_count[a]); b++)
								if draw_boton(120, pos, edificio_count[a, b].nombre){
									sel_build = false
									sel_info = true
									sel_tipo = 0
									sel_edificio = edificio_count[a, b]
								}
				if draw_menu(110, pos, $"Viviendas libres: {array_length(casas_libres)}", 0)
					for(var a = 0; a < array_length(casas_libres); a++)
						if draw_boton(120, pos, casas_libres[a].nombre){
							sel_build = false
							sel_info = true
							sel_tipo = 0
							sel_edificio = casas_libres[a]
						}
			}
			//Ministerio de Trabajo
			else if ministerio = 2{
				var fel_tra= 0, num_tra = 0, temp_array, num_des = 0, num_temp = 0, trab_esta = 0, num_nin = 0, num_del = 0
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
						num_del += persona.trabajo = delincuente
					}
					num_nin += (persona.es_hijo and persona.trabajo != null_edificio)
				}
				var vacantes = 0, vacantes_tipo
				for(var a = 0; a < array_length(edificio_nombre); a++)
					if edificio_es_trabajo[a]{
						vacantes_tipo[a] = edificio_trabajadores_max[a] * array_length(edificio_count[a])
						for(b = 0; b < array_length(edificio_count[a]); b++){
							vacantes_tipo[a] -= array_length(edificio_count[a, b].trabajadores)
							if ley_eneabled[6] and a = 20
								num_temp += array_length(edificio_count[a, b].trabajadores)
						}
						vacantes += vacantes_tipo[a]
					}
				draw_text_pos(110, pos, $"Felicidad laboral: {floor(fel_tra / num_tra)}")
				draw_text_pos(110, pos, $"Desempleo: {floor(100 * num_des / num_tra)}%")
				if draw_menu(110, pos, $"{vacantes} puestos de trabajo disponibles", 1)
					for(var a = 0; a < array_length(edificio_nombre); a++)
						if edificio_es_trabajo[a] and (edificio_nombre[a] = "Desempleado" or array_length(edificio_count[a]) > 0) and draw_menu(120, pos, $"{edificio_nombre[a]}: {temp_array[a]}/{vacantes_tipo[a] + temp_array[a]} trabajadores", a + 7)
							for(b = 0; b < array_length(edificio_count[a]); b++)
								if draw_boton(120, pos, $"{edificio_nombre[a]} {b + 1}"){
									sel_build = false
									sel_info = true
									sel_tipo = 0
									sel_edificio = edificio_count[a, b]
								}
				if draw_menu(110, pos, $"{array_length(cola_construccion)} edificios en construcción", 0)
					for(var a = 0; a < array_length(cola_construccion); a++){
						var next_build = cola_construccion[a]
						if draw_boton(120, pos, $"{edificio_nombre[next_build.id]}"){
							sel_build = false
							sel_info = true
							sel_tipo = 3
							sel_construccion = next_build
						}
					}
				draw_text_pos(110, pos, $"{num_temp} trabajadores temporales ({floor(100 * num_temp / num_tra)}%)")
				draw_text_pos(110, pos, $"{floor(100 * num_del / num_tra)}% de delincuencia")
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
				var fel_sal = 0, temp_enfermos = 0, num_sal = 0, temp_espera = 0, num_hambre = 0, num_almacenes = 0, temp_accidentes = 0
				for(var a = 0; a < array_length(personas); a++){
					fel_sal += personas[a].felicidad_salud
					if personas[a].medico != null_edificio{
						num_sal++
						if personas[a].medico != desausiado
							temp_espera++
					}
				}
				for(var a = 0; a < array_length(edificio_almacen_index); a++)
					num_almacenes += array_length(almacenes[edificio_almacen_index[a]])
				draw_text_pos(110, pos, $"Satisfación sanitaria: {floor(fel_sal / array_length(personas))}")
				for(var a = 0; a < 12; a++){
					temp_enfermos += mes_enfermos[a]
					temp_accidentes += mes_accidentes[a]
				}
				draw_text_pos(110, pos, $"{temp_enfermos} muertes por enfermedad el último año")
				draw_text_pos(110, pos, $"{num_sal} personas enfermas")
				draw_text_pos(120, pos, $"{array_length(desausiado.clientes)} personas sin atención médica")
				draw_text_pos(120, pos, $"{temp_espera} personas atendidas")
				draw_text_pos(120, pos, $"{temp_accidentes} accidentes laborales el último año")
				if draw_menu(110, pos, $"{array_length(medicos) - 1} edificios médicos", 0)
					for(var a = 0; a < array_length(edificio_nombre); a++)
						if edificio_es_medico[a]
							for(b = 0; b < array_length(edificio_count[a]); b++)
								if draw_boton(120, pos, $"{edificio_count[a, b].nombre} ({array_length(edificio_count[a, b].clientes)} clientes)"){
									sel_build = false
									sel_info = true
									sel_tipo = 0
									sel_edificio = edificio_count[a, b]
								}
				for(var a = 0; a < array_length(familias); a++)
					num_hambre += (familias[a].felicidad_alimento < 10) * (real(familias[a].padre != null_persona) + real(familias[a].madre != null_persona) + array_length(familias[a].hijos))
				draw_text_pos(110, pos, $"{num_hambre} personas hambrietas")
				if draw_menu(110, pos, $"{num_almacenes} edificios distribuyendo comida", 1)
					for(var a = 0; a < array_length(edificio_almacen_index); a++)
						for(b = 0; b < array_length(almacenes[edificio_almacen_index[a]]); b++){
							var edificio = almacenes[edificio_almacen_index[a], b]
							if draw_boton(120, pos, edificio.nombre){
								sel_build = false
								sel_info = true
								sel_tipo = 0
								sel_edificio = edificio
							}
							var d = 0
							for(var c = 0; c < array_length(recurso_comida); c++)
								d += edificio.almacen[recurso_comida[c]]
							draw_text_pos(130, pos, $"{d} comida almacenada")
						}
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
				if draw_menu(110, pos, $"{array_length(escuelas)} instituciones educativas", 0)
					for(var a = 0; a < array_length(edificio_nombre); a++)
						if edificio_es_escuela[a]
							for(b = 0; b < array_length(edificio_count[a]); b++)
								if draw_boton(120, pos, $"{edificio_count[a, b].nombre} ({array_length(edificio_count[a, b].clientes)} estudiantes)"){
									sel_build = false
									sel_info = true
									sel_tipo = 0
									sel_edificio = edificio_count[a, b]
								}
			}
			//Ministerio de Economía
			else if ministerio = 5{
				var temp_array, temp_grid, temp_text_array, count, maxi, temp_exportaciones, temp_importaciones, temp_compra, temp_venta
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
				#endregion
				for(var a = 0; a < 13; a++){
					count[a] = 0
					maxi[a] = 0
				}
				for(var a = 0; a < array_length(recurso_nombre); a++){
					temp_exportaciones[a] = 0
					temp_importaciones[a] = 0
					temp_compra[a] = 0
					temp_venta[a] = 0
				}
				for(var a = 0; a < 12; a++){
					for(b = 0; b < 13; b++){
						count[b] += temp_grid[b, (a + current_mes) mod 12]
						maxi[b] = max(maxi[b], temp_grid[b, a])
					}
					for(b = 0; b < array_length(recurso_nombre); b++){
						temp_exportaciones[b] += mes_exportaciones_recurso[a, b]
						temp_importaciones[b] += mes_importaciones_recurso[a, b]
						temp_compra[b] += mes_compra_recurso[a, b]
						temp_venta[b] += mes_venta_recurso[a, b]
					}
				}
				for(var a = 0; a < 13; a++){
					count[a] = round(count[a])
					maxi[a] = round(maxi[a])
				}
				#region Ingresos
				if draw_menu(110, pos, $"Ingresos: ${count[0] + count[1] + count[2] + count[3] + count[9] + count[10] + count[12]}", 0){
					draw_text_pos(120, pos, $"{temp_text_array[0]}: ${count[0]}")
					draw_text_pos(120, pos, $"{temp_text_array[1]}: ${count[1]}")
					draw_text_pos(120, pos, $"{temp_text_array[2]}: ${count[2]}")
					if draw_menu(120, pos, $"{temp_text_array[3]}: ${count[3]}", 1)
						for(var c = 0; c < array_length(recurso_nombre); c++)
							if temp_exportaciones[c] > 0
								draw_text_pos(130, pos, $"{recurso_nombre[c]}: ${temp_exportaciones[c]}")
					if draw_menu(120, pos, $"{temp_text_array[9]}: ${count[9]}", 6)
						for(var c = 0; c < array_length(recurso_nombre); c++)
							if temp_venta[c] > 0
								draw_text_pos(130, pos, $"{recurso_nombre[c]}: ${temp_venta[c]}")
					draw_text_pos(120, pos, $"{temp_text_array[10]}: ${count[10]}")
					draw_text_pos(120, pos, $"{temp_text_array[12]}: ${count[12]}")
				}
				if draw_menu(110, pos, $"Pérdidas: ${count[4] + count[5] + count[6] + count[7] + count[8] + count[11]}", 2){
					draw_text_pos(120, pos, $"{temp_text_array[4]}: ${count[4]}")
					draw_text_pos(120, pos, $"{temp_text_array[5]}: ${count[5]}")
					draw_text_pos(120, pos, $"{temp_text_array[6]}: ${count[6]}")
					if draw_menu(120, pos, $"{temp_text_array[7]}: ${count[7]}", 3)
						for(var c = 0; c < array_length(recurso_nombre); c++)
							if temp_importaciones[c] > 0
								draw_text_pos(130, pos, $"{recurso_nombre[c]}: ${temp_importaciones[c]}")
					if draw_menu(120, pos, $"{temp_text_array[8]}: ${count[8]}", 7)
						for(var c = 0; c < array_length(recurso_nombre); c++)
							if temp_compra[c] > 0
								draw_text_pos(130, pos, $"{recurso_nombre[c]}: ${temp_compra[c]}")
					draw_text_pos(120, pos, $"{temp_text_array[11]}: ${count[11]}")
				}
				draw_text_pos(110, pos, $"Balance: {count[0] + count[1] + count[2] + count[3] + count[9] + count[10] + count[12] - count[4] - count[5] - count[6] - count[7] - count[8] - count[11]}")
				if draw_menu(110, pos, $"{array_length(encargos)} encargos", 4)
					for(var a = 0; a < array_length(encargos); a++){
						var encargo = encargos[a]
						if encargo.cantidad > 0{
							if encargo.edificio != null_edificio{
								if draw_boton(120, pos, $"{encargo.cantidad} de {recurso_nombre[encargo.recurso]} de {encargo.edificio.nombre}"){
									sel_build = false
									sel_info = true
									sel_tipo = 0
									sel_edificio = encargo.edificio
								}
							}
							else
								draw_text_pos(120, pos, $"{encargo.cantidad} de {recurso_nombre[encargo.recurso]}")
						}
						else
							if draw_boton(120, pos, $"{-encargo.cantidad} de {recurso_nombre[encargo.recurso]} a {encargo.edificio.nombre}"){
								sel_build = false
								sel_info = true
								sel_tipo = 0
								sel_edificio = encargo.edificio
							}
					}
				pos = 100
				draw_set_color(c_black)
				draw_text_pos(500, pos, "Mercado internacional")
				var max_width = 0, last_pos = 160, max_width_2 = 0
				if mouse_wheel_up()
					show_scroll--
				if mouse_wheel_down()
					show_scroll++
				show_scroll = clamp(show_scroll, 0, array_length(recurso_nombre) - 20)
				for(var a = 0; a < 20; a++){
					draw_text_pos(420, last_pos + a * 20, recurso_nombre[a + show_scroll])
					max_width = max(max_width, last_width)
				}
				pos = 120
				draw_text_pos(420 + max_width, pos, "Exportar")
				pos += 20
				for(var a = 0; a < 20; a++)
					recurso_exportado[a + show_scroll] = draw_boton_rectangle(420 + max_width + last_width / 2 - 5, pos + a * 20, 420 + max_width + last_width / 2 + 13, pos + a * 20 + 18, recurso_exportado[a + show_scroll])
				max_width += last_width + 10
				pos = 120
				draw_text_pos(420 + max_width, pos, "Importar")
				pos = 140
				draw_text_pos(420 + max_width, pos, "Única")
				max_width_2 = max(max_width_2, last_width)
				last_pos = pos
				for(var a = 0; a < 20; a++){
					if draw_boton(420 + max_width, last_pos + a * 20, $"{recurso_importado[a + show_scroll]}", , , function() {draw_text(mouse_x + 20, mouse_y, "Shift para reducir")})
						if not keyboard_check(vk_lshift)
							recurso_importado[a + show_scroll] += 100
						else if recurso_importado[a + show_scroll] > 0
							recurso_importado[a + show_scroll] -= 100
					max_width_2  = max(max_width_2, last_width)
				}
				max_width += max_width_2 + 10
				pos = 140
				draw_text_pos(420 + max_width, pos, "Mensual")
				max_width_2 = last_width
				for(var a = 0; a < 20; a++){
					if draw_boton(420 + max_width, last_pos + a * 20, $"{recurso_importado_fijo[a + show_scroll]}", , , function() {draw_text(mouse_x + 20, mouse_y, "Importación fija mensual")})
						if not keyboard_check(vk_lshift)
							recurso_importado_fijo[a + show_scroll] += 50
						else if recurso_importado_fijo[a + show_scroll] > 0
							recurso_importado_fijo[a + show_scroll] -= 50
						max_width_2 = max(max_width_2, last_width)
				}
				max_width += max_width_2 + 10
				pos = 120
				draw_text_pos(420 + max_width, pos, "Balance")
				pos += 20
				for(var a = 0; a < 20; a++){
					if draw_sprite_boton(spr_icono, 4 + (recurso_historial[a + show_scroll, 23] < recurso_historial[a + show_scroll, 0]), 420 + max_width, pos + a * 20, 20, 20){
						var flag = show[a + show_scroll + 8]
						close_show()
						show[a + show_scroll + 8] = not flag
					}
					draw_line(420, pos + a * 20, 460 + max_width, pos + a * 20)
				}
				for(var a = 0; a < array_length(recurso_nombre); a++)
					if show[a + 8]{
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
			//Ministerio de Exterior
			else if ministerio = 6{
				draw_text_pos(100, pos, "Relaciones Exteriores")
				for(var a = 1; a < array_length(pais_current); a++){
					var e = pais_current[a]
					draw_text_pos(110, pos, $"{pais_nombre[e]} ({pais_relacion[e]})")
					var d = 0
					for(b = 0; b < array_length(recurso_nombre); b++)
						for(var c = 0; c < array_length(recurso_tratados[b]); c++)
							if recurso_tratados[b, c].pais = e
								d++
					if d > 0 and draw_menu(120, pos, $"{d} tratados comerciales", a)
						for(b = 0; b < array_length(recurso_nombre); b++)
							for(var c = 0; c < array_length(recurso_tratados[b]); c++){
								var tratado = recurso_tratados[b, c]
								if tratado.pais = e
									draw_text_pos(130, pos, $"{tratado.cantidad} de {recurso_nombre[tratado.recurso]}, {tratado.tiempo} meses restantes.  (+ {floor(tratado.factor * 100) - 100}%)")
							}
				}
				pos = 120
				draw_text_pos(480, pos, "Ofertas disponibles")
				for(var a = 0; a < array_length(tratados_ofertas); a++){
					var tratado = tratados_ofertas[a]
					var width = 500
					if draw_boton(width, pos, $"{tratado.cantidad} de "){
						add_tratado(tratado.pais, tratado.recurso, tratado.cantidad, tratado.factor, tratado.tiempo)
						array_delete(tratados_ofertas, a, 1)
					}
					pos -= last_height
					width += string_width($"{tratado.cantidad} de ")
					draw_set_color(c_blue)
					if draw_boton(width, pos, $"{recurso_nombre[tratado.recurso]}"){
						add_tratado(tratado.pais, tratado.recurso, tratado.cantidad, tratado.factor, tratado.tiempo)
						array_delete(tratados_ofertas, a, 1)
					}
					pos -= last_height
					width += string_width($"{recurso_nombre[tratado.recurso]}")
					draw_set_color(c_black)
					if draw_boton(width, pos, $" a  "){
						add_tratado(tratado.pais, tratado.recurso, tratado.cantidad, tratado.factor, tratado.tiempo)
						array_delete(tratados_ofertas, a, 1)
					}
					pos -= last_height
					width += string_width($" a  ")
					draw_set_color(c_red)
					if draw_boton(width, pos, $"{pais_nombre[tratado.pais]}"){
						add_tratado(tratado.pais, tratado.recurso, tratado.cantidad, tratado.factor, tratado.tiempo)
						array_delete(tratados_ofertas, a, 1)
					}
					pos -= last_height
					width += string_width($"{pais_nombre[tratado.pais]}")
					draw_set_color(c_black)
					if draw_boton(width, pos, $" +{floor(100 * (tratado.factor - 1))}%"){
						add_tratado(tratado.pais, tratado.recurso, tratado.cantidad, tratado.factor, tratado.tiempo)
						array_delete(tratados_ofertas, a, 1)
					}
				}
			}
			//Propiedad privada
			else if ministerio = 7{
				draw_text_pos(110, pos, $"Credibilidad financiera: {credibilidad_financiera}")
				if draw_boton(110, pos, $"Impuesto por edificio ${impuesto_empresa}")
					impuesto_empresa = (impuesto_empresa + 5) mod 30
				if draw_boton(110, pos, $"Impuesto fijo ${impuesto_empresa_fijo}")
					impuesto_empresa_fijo = (impuesto_empresa_fijo + 5) mod 30
				if draw_boton(110, pos, $"Impuesto  minero {round(100 * impuesto_minero)}%")
					impuesto_minero = ((10 * impuesto_minero + 1) mod 6) / 10
				if draw_boton(110, pos, $"Impuesto forestal {round(100 * impuesto_forestal)}%")
					impuesto_forestal = ((10 * impuesto_forestal + 1) mod 6) / 10
				if (dia / 365) >= 60 and draw_boton(110, pos, $"Impuesto petrolífero {round(100 * impuesto_petrolifero)}%")
					impuesto_petrolifero = ((10 * impuesto_petrolifero + 1) mod 6) / 10
				if draw_menu(110, pos, $"{array_length(edificios_a_la_venta)} edificios a la venta", 0)
					for(var a = 0; a < array_length(edificios_a_la_venta); a++){
						var edificio = edificios_a_la_venta[a].edificio
						if draw_boton(120, pos, edificio.nombre){
							sel_build = false
							sel_info = true
							sel_tipo = 0
							sel_edificio = edificio
						}
					}
				if draw_menu(110, pos, $"{array_length(empresas)} empresas en la isla", 1){
					for(var a = 0; a < array_length(empresas); a++){
						var empresa = empresas[a]
						if draw_menu(120, pos, $"{empresa.nombre}{empresa.nacional ? " (nacional)" : ""}", a + 2){
							draw_text_pos(140, pos, $"Dinero: ${floor(empresa.dinero)}")
							if empresa.nacional and draw_boton(140, pos, $"Dueño: {name(empresa.jefe)}"){
								sel_build = false
								sel_info = true
								sel_tipo = 2
								sel_persona = empresa.jefe
							}
							if array_length(empresa.terreno) > 0
								draw_text_pos(140, pos, $"Dueños de {array_length(empresa.terreno)} terrenos")
							if array_length(empresa.edificios) > 0{
								draw_text_pos(140, pos, $"Dueña de {array_length(empresa.edificios)} edificios")
								for(b = 0; b < array_length(empresa.edificios); b++)
									if draw_boton(160, pos, empresa.edificios[b].nombre){
										sel_build = false
										sel_info = true
										sel_tipo = 0
										sel_edificio = empresa.edificios[b]
									}
							}
						}
					}
				}
			}
			//Leyes
			else if ministerio = 8{
				for(var a = 0; a < array_length(ley_nombre); a++)
					if draw_boton(110, pos, $"{ley_nombre[a]}: {ley_eneabled[a] ? "Legal" : "Ilegal"}", , , function(a){draw_text(100, room_height - 120, $"{ley_descripcion[a]} ($250)")}, a){
						dinero -= 250
						ley_eneabled[a] = not ley_eneabled[a]
						//Permitir divorcios
						if a = 0 and ley_eneabled[0]
							for(b = 0; b < array_length(personas); b++)
								if personas[b].religion
									add_felicidad_ley(personas[b], -10)
						//Prohibir divorcios
						if a = 0 and not ley_eneabled[0]
							for(b = 0; b < array_length(personas); b++)
								if personas[b].religion
									add_felicidad_ley(personas[b], 10)
						//Prohibir trabajo infantil
						if a = 2 and not ley_eneabled[2]
							for(b = 0; b < array_length(familias); b++){
								var flag = false
								for(var c = 0; c < array_length(familias[b].hijos); c++)
									if familias[b].hijos[c].edad > 12{
										cambiar_trabajo(familias[b].hijos[c], null_edificio)
										flag = true
									}
								if flag{
									add_felicidad_ley(familias[b].padre, 10)
									add_felicidad_ley(familias[b].madre, 10)
								}
							}
						//Crear jubilaciones
						if a = 3 and ley_eneabled[3]
							for(b = 0; b < array_length(personas); b++)
								if personas[a].edad > 65{
									cambiar_trabajo(personas[a], jubilado)
									add_felicidad_ley(personas[a], 10)
								}
						//Prohibir jubilaciones
						if a = 3 and not ley_eneabled[3]
							for(b = 0; b < array_length(personas); b++)
								if personas[a].edad > 65{
									cambiar_trabajo(personas[a], null_edificio)
									add_felicidad_ley(personas[a], -10)
								}
						//Permitir emigración
						if a = 5 and ley_eneabled[5]
							for(b = 0; b < array_length(personas); b++)
								add_felicidad_ley(personas[b], 10)
						//Prohibir emigración
						if a = 5 and not ley_eneabled[5]
							for(b = 0; b < array_length(personas); b++)
								add_felicidad_ley(personas[b], -10)
						//Aprobar trabajo temporal
						if a = 6 and ley_eneabled[6] and array_length(cola_construccion) = 0
							for(b = 0; b < array_length(edificio_count[20]); b++){
								var edificio = edificio_count[20, b]
								set_paro(true, edificio)
								while array_length(edificio.trabajadores) > 0
									cambiar_trabajo(edificio.trabajadores[0], null_edificio)
							}
						//Prohibir trabajo temporal
						if a = 6 and not ley_eneabled[6] and array_length(cola_construccion) = 0
							for(b = 0; b < array_length(edificio_count[20]); b++)
								set_paro(false, edificio_count[20, b])
					}
				if draw_boton(110, pos, $"Sueldo mínimo: ${sueldo_minimo}"){
					credibilidad_financiera += floor(sueldo_minimo / 2)
					sueldo_minimo = (sueldo_minimo + 1) mod 6
					credibilidad_financiera = clamp(credibilidad_financiera - floor(sueldo_minimo / 2), 1, 10)
					for(var a = 0; a < array_length(edificios); a++)
						edificios[a].trabajo_sueldo = max(sueldo_minimo, edificio_trabajo_sueldo[edificios[a].tipo] + edificios[a].presupuesto - 2)
				}
			}
		}
	}
	//Colocar edificio
	if build_sel{
		var width = edificio_width[build_index], height = edificio_height[build_index], temp_altura = 0, temp_precio = edificio_precio[build_index], temp_tiempo = edificio_construccion_tiempo[build_index]
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
		draw_rombo((mx - my) * tile_width - xpos, (mx + my) * tile_height - ypos, (mx - my - height) * tile_width - xpos, (mx + my + height) * tile_height - ypos, (mx - my + width - height) * tile_width - xpos, (mx + my + width + height) * tile_height - ypos, (mx - my + width) * tile_width - xpos, (mx + my + width) * tile_height - ypos, false)
		draw_set_alpha(1)
		draw_set_color(c_white)
		//Calcular la eficiencia de las granjas
		if edificio_nombre[build_index] = "Granja"{
			var c = 0
			for(var a = 0; a < width; a++)
				for(var b = 0; b < height; b++)
					c += cultivo[build_type][# mx + a, my + b]
			text += $"Eficiencia: {floor(c * 100 / width / height)}%\n"
			if not keyboard_check(vk_lcontrol){
				if mouse_wheel_up()
					build_type = (build_type + 1) mod array_length(recurso_cultivo)
				if mouse_wheel_down()
					build_type = (build_type + array_length(recurso_cultivo) - 1) mod array_length(recurso_cultivo)
			}
		}
		//Minas
		var flag = true
		if edificio_nombre[build_index] = "Mina"{
			draw_rombo((mx - my) * tile_width - xpos, (mx + my - 2) * tile_height - ypos, (mx - my - height - 2) * tile_width - xpos, (mx + my + height) * tile_height - ypos, (mx - my + width - height) * tile_width - xpos, (mx + my + width + height + 2) * tile_height - ypos, (mx - my + width + 2) * tile_width - xpos, (mx + my + width) * tile_height - ypos, true)
			flag = false
			var c = 0, d = min(xsize - 1, mx + width + 1), e = min(ysize - 1, my + height + 1)
			for(var a = max(0, mx - 1); a < d; a++)
				for(var b = max(0, my - 1); b < e; b++)
					if mineral[build_type][a, b]{
						flag = true
						c += mineral_cantidad[build_type][a, b]
					}
			if not keyboard_check(vk_lcontrol){
				if mouse_wheel_up()
					build_type = (build_type + 1) mod array_length(recurso_mineral)
				if mouse_wheel_down()
					build_type = (build_type + array_length(recurso_mineral) - 1) mod array_length(recurso_mineral)
			}
			if flag
				text += $"Depósito: {c}\n"
			else
				text += $"Se necesita un depósito de {recurso_nombre[recurso_mineral[build_type]]}\n"
		}
		//Ranchos
		else if edificio_nombre[build_index] = "Rancho"{
			for(var a = 0; a < array_length(ganado_nombre); a++)
				draw_text(0, a * 20, (build_type = a ? ">" : "") + ganado_nombre[a])
			if not keyboard_check(vk_lcontrol){
				if mouse_wheel_up()
					build_type = (build_type + 1) mod array_length(ganado_nombre)
				if mouse_wheel_down()
					build_type = (build_type + array_length(ganado_nombre) - 1) mod array_length(ganado_nombre)
			}
		}
		//Capilla
		else if in(build_index, 16, 17, 18, 19){
			for(var a = 0; a < 4; a++)
				draw_text_pos(0, a * 20, (build_index = 16 + a ? ">" : "") + edificio_nombre[16 + a])
			if not keyboard_check(vk_lcontrol){
				if mouse_wheel_up(){
					build_index++
					if build_index = 20
						build_index = 16
				}
				if mouse_wheel_down(){
					build_index--
					if build_index = 15
						build_index = 19
				}
			}
		}
		//Tejar
		else if edificio_nombre[build_index] = "Tejar"{
			var c = 0, d = mx + width, e = my + height
			for(var a = mx; a < d; a++)
				for(var b = my; b < e; b++)
					c += (altura[# a, b] > 0.6)
			c /= width * height
			text += $"Eficiencia: {100 * c}%\n"
		}
		//Pozo Petrolífero
		else if edificio_nombre[build_index] = "Pozo Petrolífero"{
			var c = 0, d = mx + width, e = my + height
			for(var a = mx; a < d; a++)
				for(var b = my; b < e; b++)
					c += petroleo[a, b]
			if c = 0{
				flag = false
				text += "Se necesita petróleo cerca\n"
			}
			else
				text += $"Depósito: {c}\n"
		}
		draw_set_color(c_red)
		draw_set_alpha(0.5)
		var c = min(xsize - 1, mx + width + 5), d = min(ysize - 1, my + height + 5)
		for(var a = max(0, mx - 5); a < c; a++)
			for(var b = max(0, my - 5); b < d; b++)
				if zona_privada[a, b]
					draw_rombo((a - b) * tile_width - xpos, (a + b) * tile_height - ypos, (a - b - 1) * tile_width - xpos, (a + b + 1) * tile_height - ypos, (a - b) * tile_width - xpos, (a + b + 2) * tile_height - ypos, (a - b + 1) * tile_width - xpos, (a + b + 1) * tile_height - ypos, false)
		draw_set_color(c_white)
		draw_set_alpha(1)
		//Detectar terreno inválido
		if flag{
			flag = edificio_valid_place(mx, my, build_index, rotado)
			//Detectar árboles cerca
			if flag and edificio_nombre[build_index] = "Aserradero"{
				draw_rombo((mx - my) * tile_width - xpos, (mx + my - 10) * tile_height - ypos, (mx - my - height - 10) * tile_width - xpos, (mx + my + height) * tile_height - ypos, (mx - my + width - height) * tile_width - xpos, (mx + my + width + height + 10) * tile_height - ypos, (mx - my + width + 10) * tile_width - xpos, (mx + my + width) * tile_height - ypos, true)
				var flag_2 = false
				c = 0
				d = min(mx + width + 5, xsize)
				var e = min(my + height + 5, ysize)
				for(var a = max(0, mx - 5); a < d; a++)
					for(var b = max(0, my - 5); b < e; b++)
						if bosque[a, b] and not (a >= mx and a < mx + width and b >= my and b < my + height){
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
			if not edificio_es_costero[build_index] and edificio_nombre[build_index] != "Rancho"{
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
			var coste_terreno = 0, coste_deforestar = 0
			for(var a = mx; a < c; a++)
				for(var b = my; b < d; b++){
					coste_terreno += 10 * zona_privada[a, b]
					coste_deforestar += 10 * bosque[a, b]
				}
			if coste_terreno > 0{
				text += $"\Estatizar terreno: ${coste_terreno}"
				temp_precio += coste_terreno
			}
			if coste_deforestar > 0{
				text += $"\nDeforestar terreno: ${coste_deforestar}"
				temp_precio += coste_deforestar
			}
		}
		if text != ""
			draw_text((mx - my) * tile_width - xpos, (mx + my) * tile_height - ypos, text)
		//Construir
		if mouse_check_button_pressed(mb_left){
			mouse_clear(mb_left)
			if flag{
				var next_build = {
					x : mx,
					y : my,
					id : build_index,
					tipo : build_type,
					tiempo : temp_tiempo,
					altura : temp_altura,
					rotado : rotado,
					width : width,
					height : height
				}
				for(var a = mx; a < mx + width; a++)
					for(var b = my; b < my + height; b++){
						array_set(construccion_reservada[a], b, true)
						if zona_privada[a, b]{
							zona_empresa[a, b].dinero += 10
							array_set(zona_privada[a], b, false)
							array_set(zona_empresa[a], b, null_empresa)
						}
						if bool_edificio[a, b] and id_edificio[a, b].tipo = 32
							destroy_edificio(id_edificio[a, b])
						array_set(draw_construccion[a], b, next_build)
					}
				if array_length(cola_construccion) = 0 and ley_eneabled[6]
					for(var a = 0; a < array_length(edificio_count[20]); a++)
						set_paro(false, edificio_count[20, a])
				for(var a = 0; a < array_length(edificio_recursos_id[build_index]); a++)
					recurso_construccion[edificio_recursos_id[build_index, a]] += edificio_recursos_num[build_index, a]
				array_push(cola_construccion, next_build)
				array_set(bool_draw_construccion[mx], my, true)
				build_sel = keyboard_check(vk_lshift)
				dinero -= temp_precio
				mes_construccion[current_mes] += temp_precio
				if tutorial_bool and tutorial = 8
					tutorial_complete = true
			}
		}
		if mouse_check_button_pressed(mb_right){
			mouse_clear(mb_right)
			build_sel = false
		}
	}
	//Seleccionar edificio
	if mouse_check_button_pressed(mb_left){
		var mx = clamp(floor(((mouse_x + xpos) / tile_width + (mouse_y + ypos) / tile_height) / 2), 0, xsize - 1)
		var my = clamp(floor(((mouse_y + ypos) / tile_height - (mouse_x + xpos) / tile_width) / 2), 0, ysize - 1)
		if mx >= 0 and my >= 0 and mx < xsize and my < ysize and mouse_x < room_width - sel_info * 300 and not sel_build{
			mouse_clear(mb_left)
			sel_info = bool_edificio[mx, my] or construccion_reservada[mx, my]
			if sel_info{
				sel_familia = null_familia
				sel_persona = null_persona
				close_show()
				if construccion_reservada[mx, my]{
					sel_construccion = draw_construccion[mx, my]
					sel_edificio = null_edificio
					sel_tipo = 3
				}
				else{
					sel_edificio = id_edificio[mx, my]
					sel_construccion = null_construccion
					sel_tipo = 0
					if tutorial_bool and tutorial = 10
						tutorial_complete = true
				}
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
			draw_text_pos(room_width, pos, sel_edificio.nombre)
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
						sel_edificio.huelga = false
						set_paro(false, sel_edificio)
					}
					if draw_boton(room_width - 40, pos, exigencia_nombre[sel_edificio.huelga_motivo]) and show_question($"Aceptar exigencia?\n\n{exigencia_nombre[sel_edificio.huelga_motivo]}"){
						var array_edificio = [], b = sel_edificio.huelga_motivo
						for(a = 0; a < array_length(edificios); a++)
							if edificios[a].huelga
								if edificios[a].huelga_motivo = b{
									array_push(array_edificio, edificios[a])
									set_paro(false, edificios[a])
								}
						var temp_exigencia = add_exigencia(b, array_edificio)
						for(a = 0; a < array_length(temp_exigencia.edificios); a++)
							temp_exigencia.edificios[a].exigencia = temp_exigencia
					}
					if array_length(edificio_count[34]) > 0 and draw_boton(room_width - 40, pos, "Que la policía haga su trabajo"){
						sel_edificio.huelga = false
						set_paro(false, sel_edificio)
						for(a = 0; a < array_length(sel_edificio.trabajadores); a++){
							var persona = sel_edificio.trabajadores[a]
							if brandom()
								buscar_atencion_medica(persona)
							persona.felicidad_temporal -= 40
							if persona.pareja != null_persona
								persona.pareja.felicidad_temporal -= 25
						}
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
							for(var b = 0; b < array_length(edificio_count[index]); b++){
								var edificio = undefined
								if keyboard_check(vk_lshift){
									edificio = edificio_count[index, b]
									if edificio.privado
										continue
								}
								else{
									b = array_length(edificio_count[index])
									edificio = sel_edificio
								}
								set_presupuesto(a, edificio)
							}
				pos += 40
				draw_text_pos(room_width - 40, pos, $"{edificio_es_trabajo[index] ? "Calidad laboral: " + string(sel_edificio.trabajo_calidad) + "  Sueldo: $" + string(sel_edificio.trabajo_sueldo) + "\n" : ""}{
					edificio_es_casa[index] ? "Calidad de vivienda: " + string(sel_edificio.vivienda_calidad) + "\n" : ""}")
				#endregion
				//Prisiones
				if var_edificio_nombre = "Comisaría"
					if draw_menu(room_width - 20, pos, $"{array_length(sel_edificio.clientes)} presxs.", 2)
						for(var a = 0; a < array_length(sel_edificio.clientes); a++)
							if draw_boton(room_width - 40, pos, name(sel_edificio.clientes[a])){
								sel_persona = sel_edificio.clientes[a]
								sel_edificio = null_edificio
								sel_tipo = 2
								close_show()
							}
				//Información familias
				if edificio_es_casa[index]{
					if draw_menu(room_width - 20, pos, $"Familias: {array_length(sel_edificio.familias)}/{edificio_familias_max[index]}", 3)
						for(var a = 0; a < array_length(sel_edificio.familias); a++)
							if draw_boton(room_width - 40, pos, $"Familia {sel_edificio.familias[a].padre.apellido} {sel_edificio.familias[a].madre.apellido}"){
								sel_familia = sel_edificio.familias[a]
								sel_tipo = 1
							}
				}
				//Información trabajadores
				if edificio_es_trabajo[index]{
					if draw_menu(room_width - 20, pos, $"Trabajadores: {array_length(sel_edificio.trabajadores)}/{sel_edificio.trabajadores_max}", 4)
						for(var a = 0; a < array_length(sel_edificio.trabajadores); a++)
							if draw_boton(room_width - 40, pos, name(sel_edificio.trabajadores[a])){
								sel_persona = sel_edificio.trabajadores[a]
								sel_tipo = 2
							}
					if var_edificio_nombre = "Granja"{
						if current_mes = 5 or current_mes = 10
							draw_text_pos(room_width - 20, pos, "Consecha")
						else
							draw_text_pos(room_width - 20, pos, "Siembra")
						draw_text_pos(room_width - 40, pos, $"Eficiencia: {floor(sel_edificio.eficiencia * 100)}%")
						if contaminacion[sel_edificio.x, sel_edificio.y] > 0
							draw_text_pos(room_width - 60, pos, $"Contaminación: -{floor(clamp(contaminacion[sel_edificio.x, sel_edificio.y], 0, 100) / 2)}%")
						draw_text_pos(room_width - 40, pos, $"{sel_edificio.count} plantas")
						draw_text_pos(room_width - 20, pos, $"\nProduciendo {recurso_nombre[recurso_cultivo[sel_edificio.modo]]}")
						if not sel_edificio.privado and draw_boton(room_width - 40, pos, "Cambiar recurso", , not sel_edificio.huelga)
							sel_modo = not sel_modo
						if sel_modo
							for(var a = 0; a < array_length(recurso_cultivo); a++)
								if a != sel_edificio.modo{
									if draw_boton(room_width - 40, pos, recurso_nombre[recurso_cultivo[a]])
										sel_edificio.modo = a
									if mouse_x > room_width - 40 - last_width and mouse_y > pos - last_height and mouse_x < room_width - 40 and mouse_y < pos{
										draw_gradiente(a, 0)
										draw_set_color(c_black)
									}
								}
					}
					if var_edificio_nombre = "Pescadería"
						if contaminacion[sel_edificio.x, sel_edificio.y] > 0
							draw_text_pos(room_width - 40, pos, $"Contaminación: -{floor(clamp(contaminacion[sel_edificio.x, sel_edificio.y], 0, 100) / 2)}%")
					if var_edificio_nombre = "Mina"{
						draw_text_pos(room_width - 20, pos, $"Extrayendo {recurso_nombre[recurso_mineral[sel_edificio.modo]]}")
						var c = 0, d = min(xsize - 1, sel_edificio.x + width + 1), e = min(xsize - 1, sel_edificio.y + height + 1)
						for(var a = max(0, sel_edificio.x - 1); a < d; a++)
							for(var b = max(0, sel_edificio.y - 1); b < e; b++)
								if mineral[sel_edificio.modo][a, b]
									c += mineral_cantidad[sel_edificio.modo][a, b]
						draw_text_pos(room_width - 40, pos, $"Depósito: {c}")
						if not sel_edificio.privado and draw_menu(room_width - 20, pos, "Cambiar recurso", 3)
							for(var a = 0; a < array_length(recurso_mineral); a++)
								if a != sel_edificio.modo{
									if draw_boton(room_width - 40, pos, recurso_nombre[recurso_mineral[a]]){
										sel_edificio.modo = a
										show[3] = false
									}
									if mouse_x > room_width - 40 - last_width and mouse_y > pos - last_height and mouse_x < room_width - 40 and mouse_y < pos{
										draw_gradiente(a, 1)
										draw_set_color(c_black)
									}
								}
					}
					if var_edificio_nombre = "Rancho"{
						if contaminacion[sel_edificio.x, sel_edificio.y] > 0
							draw_text_pos(room_width - 40, pos, $"Contaminación: -{floor(clamp(contaminacion[sel_edificio.x, sel_edificio.y], 0, 100) / 2)}%")
						draw_text_pos(room_width - 20, pos, $"Produciendo {ganado_nombre[sel_edificio.modo]}")
						if not sel_edificio.privado and draw_menu(room_width - 20, pos, "Cambiar recurso", 3)
							for(var a = 0; a < array_length(ganado_nombre); a++)
								if a != sel_edificio.modo and draw_boton(room_width - 40, pos, ganado_nombre[a]){
									for(var b = 0; b < array_length(ganado_produccion[sel_edificio.modo]); b++)
										sel_edificio.almacen[ganado_produccion[sel_edificio.modo, b]] = 0
									sel_edificio.modo = a
									show[3] = false
								}
					}
					if var_edificio_nombre = "Aserradero"{
						if draw_boton(room_width - 20, pos, $"{(sel_edificio.modo = 0) ? "Despejar bosque" : "Reforestación"}")
							sel_edificio.modo = 1 - sel_edificio.modo
					}
					if var_edificio_nombre = "Pozo Petrolífero"{
						var c = 0, d = x + width, e = y + height
						for(var a = x; a < d; a++)
							for(var b = y; b < e; b++)
								c += petroleo[a, b]
						if c > 0
							draw_text_pos(room_width - 20, pos, $"Depósito: {c}")
						else
							draw_text_pos(room_width - 20, pos, "Depósito vacío")
					}
				}
				//Información escuelas / consultas
				if edificio_es_escuela[index] or edificio_es_medico[index]{
					if draw_menu(room_width - 20, pos, $"{edificio_es_escuela[index] ? "Estudientes" : "Clientes"}: {array_length(sel_edificio.clientes)}/{edificio_clientes_max[index]}", 2)
						for(var a = 0; a < array_length(sel_edificio.clientes); a++)
							if draw_boton(room_width - 40, pos, name(sel_edificio.clientes[a])){
								sel_persona = sel_edificio.clientes[a]
								sel_tipo = 2
							}
				}
				//Almacen / edificios cercanos
				if not sel_edificio.privado{
					if draw_menu(room_width - 20, pos, "Almacen", 1, , false){
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
							for(var a = x; a < x + width; a++)
								for(var b = y; b < y + height; b++){
									array_set(zona_privada[a], b, false)
									array_set(zona_empresa[a], b, null_empresa)
								}
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
			if sel_familia.casa = homeless
				draw_text_pos(room_width - 20, pos, "Sin hogar")
			else if draw_boton(room_width - 20, pos, "Vivienda: " + sel_familia.casa.nombre){
				sel_edificio = sel_familia.casa
				sel_tipo = 0
			}
			if sel_familia.padre != null_persona and draw_boton(room_width - 20, pos, $"Padre: {name(sel_familia.padre)}"){
				sel_persona = sel_familia.padre
				sel_tipo = 2
			}
			if sel_familia.madre != null_persona and draw_boton(room_width - 20, pos, $"Madre: {name(sel_familia.madre)}"){
				sel_persona = sel_familia.madre
				sel_tipo = 2
			}
			draw_text_pos(room_width - 20, pos, (array_length(sel_familia.hijos) > 0) ? "Hijos" : "Sin hijos")
			for(var a = 0; a < array_length(sel_familia.hijos); a++)
				if draw_boton(room_width - 40, pos, name(sel_familia.hijos[a])){
					sel_persona = sel_familia.hijos[a]
					sel_tipo = 2
				}
		}
		//Información personas
		else if sel_tipo = 2 and sel_persona != null_persona{
			draw_text_pos(room_width, pos, name(sel_persona))
			draw_text_pos(room_width - 20, pos, $"Nacionalidad: {pais_nombre[sel_persona.nacionalidad]}")
			if sel_persona.religion
				draw_text_pos(room_width - 20, pos, "Creyente")
			else
				draw_text_pos(room_width - 20, pos, $"Ate{ao(sel_persona)}")
			draw_text_pos(room_width - 20, pos, $"Edad: {sel_persona.edad} ({fecha(sel_persona.cumple, false)})")
			if draw_boton(room_width - 20, pos, name_familia(sel_persona.familia)){
				sel_familia = sel_persona.familia
				sel_tipo = 1
			}
			if sel_persona.familia.casa = homeless
				draw_text_pos(room_width - 20, pos, "Sin hogar")
			else if draw_boton(room_width - 20, pos, "Vive en: " + sel_persona.familia.casa.nombre){
				sel_edificio = sel_persona.familia.casa
				sel_tipo = 0
			}
			if sel_persona.trabajo = null_edificio
				draw_text_pos(room_width - 20, pos, "Sin trabajo")
			else if draw_boton(room_width - 20, pos, "Trabaja en: " + sel_persona.trabajo.nombre){
				sel_edificio = sel_persona.trabajo
				sel_tipo = 0
			}
			draw_text_pos(room_width - 20, pos, $"Educación: {educacion_nombre[floor(sel_persona.educacion)]}")
			if sel_persona.escuela != null_edificio and draw_boton(room_width - 40, pos, $"Estudiando en {sel_persona.escuela.nombre}"){
				sel_edificio = sel_persona.escuela
				sel_tipo = 0
			}
			else if sel_persona.es_hijo
				draw_text_pos(room_width - 40, pos, "Sin escolarizar")
			if sel_persona.medico != null_edificio{
				draw_text_pos(room_width - 20, pos, $"Enferm{ao(sel_persona)}")
				if sel_persona.medico = desausiado
					draw_text_pos(room_width - 40, pos, "Sin tratamiento")
				else if draw_boton(room_width - 40, pos, "Tratándose en " + sel_persona.medico.nombre){
					sel_edificio = sel_persona.medico
					sel_tipo = 0
				}
			}
			else
				draw_text_pos(room_width - 20, pos, $"San{ao(sel_persona)}")
			draw_text_pos(room_width, pos, $"Felicidad: {sel_persona.felicidad}")
			draw_text_pos(room_width - 20, pos, $"Legislación: {sel_persona.felicidad_ley}")
			draw_text_pos(room_width - 20, pos, $"Delincuencia: {sel_persona.felicidad_crimen}")
			draw_relacion(room_width - 150, room_height - 50, sel_persona.relacion)
		}
		//Información construcciones
		else if sel_tipo = 3 and sel_construccion != null_construccion{
			x = sel_construccion.x
			y = sel_construccion.y
			var index = sel_construccion.id, width = sel_construccion.width, height = sel_construccion.height
			draw_text_pos(room_width, pos, edificio_nombre[index])
			draw_text_pos(room_width - 20, pos, $"Progreso: {floor(100 * (edificio_construccion_tiempo[index] - sel_construccion.tiempo) / edificio_construccion_tiempo[index])}%")
			if draw_boton(room_width - 20, pos, $"Terminar edificio ${edificio_precio[index]}") and dinero >= edificio_precio[index]{
				dinero -= edificio_precio[index]
				mes_construccion[current_mes] += edificio_precio[index]
				sel_edificio = acelerar_edificio(sel_construccion)
				sel_construccion = null_construccion
				sel_tipo = 0
			}
			if draw_boton(room_width - 20, pos, "Cancelar construcción"){
				for(var a = x; a < x + width; a++)
					for(var b = y; b < y + height; b++){
						array_set(draw_construccion[a], b, null_construccion)
						array_set(construccion_reservada[a], b, false)
					}
				array_set(bool_draw_construccion[x], y, false)
				array_remove(cola_construccion, sel_construccion)
				if array_length(cola_construccion) = 0 and ley_eneabled[6]
					for(var a = 0; a < array_length(edificio_count[20]); a++){
						var edificio = edificio_count[20, a]
						set_paro(true, edificio)
						while array_length(edificio.trabajadores) > 0
							cambiar_trabajo(edificio.trabajadores[0], null_edificio)
					}
				sel_construccion = null_construccion
				sel_info = false
			}
		}
		draw_set_halign(fa_left)
	}
	#region Movimiento de la cámara
	if not tutorial_bool or tutorial_camara[tutorial]{
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
	#endregion
	//Pasar día
	step += velocidad * (not menu)
	if (keyboard_check(vk_space) or step >= 60){
		step = 0
		repeat(1 + 29 * (keyboard_check(vk_space) and keyboard_check(vk_lshift))){
			dia++
			current_mes = mes(dia)
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
				for(var a = 0; a < array_length(edificio_count[20]); a++)
					b += array_length(edificio_count[20, a].trabajadores) * (0.8 + 0.1 * edificio_count[20, a].presupuesto) * edificio_count[20, a].eficiencia * edificio_experiencia[20]
				var next_build = cola_construccion[0]
				next_build.tiempo -= b
				//Edificio_terminado
				if next_build.tiempo <= 0
					acelerar_edificio(next_build)
			}
			//Mover recursos
			if array_length(encargos) > 0{
				var c = 0, rss_in = [], rss_out = []
				for(var a = 0; a < array_length(edificio_count[22]); a++)
					c += 3 * array_length(edificio_count[22, a].trabajadores) * (0.8 + 0.1 * edificio_count[22, a].presupuesto) * edificio_count[22, a].eficiencia * edificio_experiencia[22]
				for(var a = 0; a < array_length(edificio_count[13]); a++)
					if not (current_mes = edificio_count[13, a].mes_creacion or current_mes = (edificio_count[13, a].mes_creacion + 6) mod 12)
						c += 2 * array_length(edificio_count[13, a].trabajadores) * (0.8 + 0.1 * edificio_count[13, a].presupuesto) * edificio_count[13, a].eficiencia * edificio_experiencia[22]
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
				var mx = irandom(xsize - 1), my = irandom(ysize - 1)
				if bosque[mx, my]{
					array_set(bosque_madera[mx], my, max(bosque_max[mx, my], min(200, bosque_madera[mx, my] + 20)))
					array_set(bosque_alpha[mx], my, 0.5 + bosque_madera[mx, my] / 400)
				}
			}
			//Eventos mensuales
			if dia_mes(dia) = 0{
				mes_enfermos[current_mes] = 0
				mes_emigrantes[current_mes] = 0
				mes_muertos[current_mes] = 0
				mes_inmigrantes[current_mes] =0
				mes_nacimientos[current_mes] = 0
				mes_inanicion[current_mes] = 0
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
				for(var a = 0; a < array_length(recurso_nombre); a++){
					array_set(mes_exportaciones_recurso[current_mes], a, 0)
					array_set(mes_importaciones_recurso[current_mes], a, 0)
					array_set(mes_compra_recurso[current_mes], a, 0)
					array_set(mes_venta_recurso[current_mes], a, 0)
				}
				//Actualizar precios de recursos y tratados comerciales
				for(var a = 0; a < array_length(recurso_nombre); a++){
					recurso_precio[a] *= power(random_range(1, 1.05), 2 * irandom(1) - 1)
					array_shift(recurso_historial[a])
					array_push(recurso_historial[a], recurso_precio[a])
					for(var b = 0; b < array_length(recurso_tratados[a]); b++){
						var tratado = recurso_tratados[a, b]
						tratado.tiempo--
						if tratado.tiempo = 0{
							show_debug_message($"No has podido cumplir el tratado de exportar {tratado.cantidad} de {recurso_nombre[tratado.recurso]} a {pais_nombre[tratado.pais]}")
							pais_relacion[tratado.pais]--
							array_delete(recurso_tratados[a], b--, 1)
							credibilidad_financiera = clamp(credibilidad_financiera - 1, 1, 10)
						}
					}
				}
				#region Nuevas ofertas de tratados
				add_tratado_oferta()
				if array_length(tratados_ofertas) > 15
					array_shift(tratados_ofertas)
				#endregion
				//Inmigración
				if ley_eneabled[1] and (irandom(felicidad_total) > felicidad_minima or irandom(credibilidad_financiera) > 7 or dia < 365){
					var familia = add_familia()
					if familia.padre != null_persona{
						buscar_trabajo(familia.padre)
						buscar_casa(familia.padre)
					}
					if familia.madre != null_persona{
						buscar_trabajo(familia.madre)
						buscar_casa(familia.madre)
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
			}
			//Eventos anuales
			if (dia mod 365) = 0{
				var anno = floor(dia / 365)
				felicidad_minima = floor(10 + 50 * (1 + anno) / (100 + anno))
				//Credibilidad financiera
				credibilidad_financiera = clamp(credibilidad_financiera + sign((dinero_privado + inversion_privada) - prev_beneficio_privado), 1, 10)
				prev_beneficio_privado = dinero_privado + inversion_privada
				if array_length(empresas) < irandom(credibilidad_financiera)
					add_empresa(irandom_range(1000, 2000))
				for(var a = 0; a < array_length(pais_nombre); a++){
					if anno = pais_inicio[a]
						array_push(pais_current, a)
					else if anno = pais_fin[a]{
						for(var b = 0; b < array_length(recurso_nombre); b++)
							for(var c = 0; c > array_length(recurso_tratados[b]); c++)
								if recurso_tratados[b, c].pais = pais_current[a]
									array_delete(recurso_tratados[b], c--, 1)
						array_delete(pais_current, a, 1)
					}
				}
			}
			#region Personas
				//Ciclo normal de las personas
				for(var a = 0; a < array_length(cumples[dia mod 365]); a++){
					var persona = cumples[dia mod 365, a]
					persona.edad++
					//Enfermar
					if random(1) < 0.2 and persona.medico = null_edificio
						buscar_atencion_medica(persona)
					//Estudiar
					if persona.edad > 4 and persona.edad < 18 and not persona.preso{
						if persona.escuela = null_edificio
							buscar_escuela(persona)
						else{
							persona.educacion += random_range(0.1, 0.2)
							if persona.educacion >= edificio_escuela_max[persona.escuela.tipo]{
								persona.educacion = edificio_escuela_max[persona.escuela.tipo]
								cambiar_escuela(persona, null_edificio)
							}
							else if ley_eneabled[2] and random(1) < 0.1 and buscar_trabajo(persona){
								cambiar_escuela(persona, null_edificio)
								buscar_escuela(persona)
							}
						}
						//Mudarse a un albergue
						if persona.familia.padre = null_persona and persona.familia.madre = null_persona and edificio_nombre[persona.familia.casa.tipo] != "Albergue" and array_length(edificio_count[18]) > 0{
							var edificio = edificio_count[18, irandom(array_length(edificio_count[18]) - 1)]
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
						if buscar_trabajo(persona){
							var flag = false
							for(var b = 0; b < array_length(persona.familia.hijos); b++)
								if persona != persona.familia.hijos[b] and persona.familia.hijos[b].trabajo != null_edificio{
									flag = true
									break
								}
							if not flag{
								add_felicidad_ley(persona.familia.padre, -10)
								add_felicidad_ley(persona.familia.madre, -10)
							}
						}
					}
					//Independizarse
					if persona.edad > 18 and (irandom_range(persona.edad, 24) = 24 or persona.edad > 24) and persona.es_hijo and not persona.preso{
						if buscar_trabajo(persona) or persona.edad > 24{
							var prev_familia = persona.familia, herencia = 0, b = prev_familia.felicidad_vivienda, c = prev_familia.felicidad_alimento
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
						if persona.religion and ley_eneabled[0]
							add_felicidad_ley(persona, -10)
						if ley_eneabled[5]
							add_felicidad_ley(persona, -10)
					}
					//Adultez
					else if persona.edad > 24 and persona.edad < 60 and not persona.preso{
						//Casarse
						if persona.pareja = null_persona{
							var persona_2 = personas[irandom(array_length(personas) - 1)]
							if persona.sexo != persona_2.sexo and persona_2.edad > 18 and abs(persona.edad - persona_2.edad) < 8 and persona_2.pareja = null_persona and (persona_2.familia.padre = persona_2 or persona_2.familia.madre = persona_2) and persona.familia != persona_2.familia{
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
						else if irandom(3 + 2 * array_length(persona.familia.hijos)) = 0 and persona.familia.madre != null_persona and persona.familia.madre.edad < 40 and persona.familia.madre.embarazo = -1{
							persona.familia.madre.embarazo = (dia + irandom_range(240, 280)) mod 365
							array_push(embarazo[persona.familia.madre.embarazo], persona.familia.madre)
						}
						//Buscar trabajo
						if not buscar_trabajo(persona) and persona.trabajo = null_edificio and irandom(persona.educacion) = 0 and irandom(persona.edad) < 10
							cambiar_trabajo(persona, delincuente)
						//Delinquir
						if persona.trabajo = delincuente{
							var familia = familias[irandom(array_length(familias) - 1)]
							if familia != persona.familia and (familia.casa = homeless or familia.casa.ladron = null_persona){
								if familia.casa != homeless{
									familia.casa.ladron = persona
									persona.ladron = familia.casa
								}
								var b = clamp(irandom(familia.riqueza), 0, 24)
								if b > 0{
									familia.riqueza -= b
									persona.familia.riqueza += b
									if familia.padre != null_persona
										familia.padre.felicidad_crimen = max(0, familia.padre.felicidad_crimen - 2 * b - 5)
									if familia.madre != null_persona
										familia.madre.felicidad_crimen = max(0, familia.madre.felicidad_crimen - 2 * b - 5)
									for(var c = 0; c < array_length(familia.hijos); c++)
										familia.hijos[c].felicidad_crimen = max(0, familia.hijos[c].felicidad_crimen - b - 5)
								}
							}
						}
						//Crear empresa nacional
						else if persona.empresa = null_empresa and irandom(persona.familia.riqueza) > 750{
							var empresa = add_empresa(500, true, persona)
							persona.empresa = empresa
							show_debug_message($"Se ha creado una empresa nacional: {empresa.nombre}")
							persona.familia.riqueza -= 500
						}
						//Mudarse
						if not buscar_casa(persona) and persona.familia.casa = homeless and ley_eneabled[7] and not in(persona.trabajo, null_edificio, jubilado, delincuente){
							var temp_array_coord = [], edificio = persona.trabajo, index = edificio.tipo, width = edificio.width, height = edificio.height, d = edificio.x + width + 2, e = edificio.y + height + 2
							for(var b = edificio.x - 2; b < d; b++)
								for(var c = edificio.y - 2; c < e; c++)
									if not bool_edificio[b, c] and not construccion_reservada[b, c] and not mar[b, c] and not bosque[b, c]
										array_push(temp_array_coord, {x : b, y : c})
							temp_array_coord = array_shuffle(temp_array_coord)
							edificio = spawn_build(temp_array_coord, 32)
							if edificio != null_edificio
								cambiar_casa(persona.familia, edificio)
						}
					}
					//Vejez
					else if persona.edad > 60{
						//Jubilarse
						if not persona.preso
							if ley_eneabled[3] and persona.edad >= 65 - 5 * persona.sexo{
								cambiar_trabajo(persona, jubilado)
								add_felicidad_ley(persona, 10)
							}
							else{
								buscar_trabajo(persona)
								buscar_casa(persona)
							}
						//Morir
						if irandom(persona.edad) > 60{
							persona.muerte = irandom(364)
							array_push(muerte[persona.muerte], persona)
						}
					}
					//Acciones no para niños
					if not persona.es_hijo{
						//Accidentes laborales
						if persona.trabajo != null_edificio and random(1) < persona.trabajo.trabajo_riesgo{
							mes_accidentes[current_mes]++
							buscar_atencion_medica(persona)
						}
						//Comprar productos de lujo
						for(var b = 0; b < array_length(recurso_lujo); b++){
							var c = recurso_lujo[b], temp_precio = recurso_precio[c]
							if persona.familia.sueldo > 0 and persona.familia.riqueza > temp_precio and random(1) < recurso_lujo_prbabilidad[b] and array_length(edificio_count[35]) > 0{
								var tienda = edificio_count[35, irandom(array_length(edificio_count[35]) - 1)]
								if tienda.almacen[c] >= 1{
									tienda.almacen[c]--
									persona.felicidad_ocio += 10
									tienda.ganancia += temp_precio
									persona.familia.riqueza -= temp_precio
									if tienda.privado{
										dinero_privado += temp_precio
										tienda.empresa.dinero += temp_precio
									}
									else{
										dinero += temp_precio
										mes_tarifas[current_mes] += temp_precio
									}
								}
							}
						}
					}
					//Acudir a edificios de ocio
					if not persona.preso{
						var temp_array = array_shuffle(edificios_ocio_index)
						persona.felicidad_ocio = 0
						for(var b = 0; b < array_length(temp_array); b++)
							if array_length(edificio_count[temp_array[b]]) > 0 and (persona.edad > 12 or (edificio_nombre[temp_array[b]] != "Taberna")) and (array_length(persona.familia.hijos) > 0 or (edificio_nombre[temp_array[b]] != "Circo")) and ((not persona.sexo and persona.edad > 15) or (edificio_nombre[temp_array[b]] != "Cabaret")){
								var ocio = edificio_count[temp_array[b], irandom(array_length(edificio_count[temp_array[b]]) - 1)]
								if ocio.count < edificio_clientes_max[temp_array[b]] and persona.familia.riqueza >= edificio_clientes_tarifa[temp_array[b]]{
									var c = edificio_clientes_tarifa[temp_array[b]]
									persona.familia.riqueza -= edificio_clientes_tarifa[temp_array[b]]
									ocio.ganancia += c
									if ocio.privado{
										dinero_privado += c
										ocio.empresa.dinero += c
									}
									else{
										dinero += c
										mes_tarifas[current_mes] += c
									}
									ocio.count++
									persona.ocios[b] = edificio_clientes_calidad[temp_array[b]]
									persona.felicidad_ocio += persona.ocios[b]
								}
								else{
									persona.ocios[b] = floor(persona.ocios[b] / 2)
									persona.felicidad_ocio += persona.ocios[b]
								}
							}
							else{
								persona.ocios[b] = floor(persona.ocios[b] / 2)
								persona.felicidad_ocio += persona.ocios[b]
							}
						if persona.felicidad_ocio > 100
							persona.felicidad_ocio = 100
					}
					//Ir a la iglesia
					if array_length(iglesias) > 0 and (persona.religion or (persona.edad < 12 and random(1) < 0.1)) and not persona.preso{
						persona.religion = true
						var iglesia= null_edificio
						if persona.familia.casa != homeless{
							if array_length(persona.familia.casa.iglesias_cerca) > 0
								iglesia = persona.familia.casa.iglesias_cerca[irandom(array_length(persona.familia.casa.iglesias_cerca) - 1)]
						}
						else
							iglesia = iglesias[irandom(array_length(iglesias) - 1)]
						if iglesia.count < edificio_clientes_max[iglesia.tipo]{
							iglesia.count++
							persona.felicidad_religion = min(110, persona.felicidad_religion + edificio_clientes_calidad[iglesia.tipo])
						}
					}
					#region Calculo de felicidad
						felicidad_total = felicidad_total * array_length(personas) - persona.felicidad
						if array_length(medicos) = 1
							persona.felicidad_salud = floor(persona.felicidad_salud / 2)
						else{
							var temp_contaminacion = 0.25;
							if persona.familia.casa != homeless
								temp_contaminacion = (1 - clamp(contaminacion[persona.familia.casa.x, persona.familia.casa.y], 0, 100) / 100)
							if not in(persona.trabajo, null_edificio, jubilado, delincuente)
								temp_contaminacion *= (1 - clamp(contaminacion[persona.trabajo.x, persona.trabajo.y], 0, 100) / 100)
							if persona.escuela != null_edificio
								temp_contaminacion *= (1 - clamp(contaminacion[persona.escuela.x, persona.escuela.y], 0, 100) / 100)
							temp_contaminacion = 100 * temp_contaminacion
							persona.felicidad_salud = floor((persona.felicidad_salud + 3 * temp_contaminacion) / 4)
						}
						persona.familia.felicidad_vivienda = floor((persona.familia.felicidad_vivienda + 3 * persona.familia.casa.vivienda_calidad) / 4)
						var temp_array = [persona.felicidad_salud, persona.familia.felicidad_vivienda, persona.felicidad_ocio, persona.familia.felicidad_alimento, persona.felicidad_ley, persona.felicidad_crimen]
						persona.felicidad_crimen = min(persona.felicidad_crimen + 5, 100)
						if persona.es_hijo{
							persona.felicidad_educacion = floor((persona.felicidad_educacion + 3 * edificio_clientes_calidad[persona.escuela.tipo]) / 4)
							array_push(temp_array, persona.felicidad_educacion)
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
						if persona.familia.casa != homeless and (persona.escuela != null_edificio or not in(persona.trabajo, null_edificio, jubilado, delincuente))
							array_push(temp_array, persona.felicidad_transporte)
						persona.felicidad = calcular_felicidad(temp_array) + persona.felicidad_temporal / array_length(temp_array)
						felicidad_total = (felicidad_total + persona.felicidad) / array_length(personas)
						if abs(persona.felicidad_temporal) <= 10
							persona.felicidad_temporal = 0
						else
							persona.felicidad_temporal /= 2
					#endregion
					//Descontento
					if persona.edad > 18 and persona.edad < 60 and irandom(felicidad_minima) >= persona.felicidad + 5 * (persona.nacionalidad = 0) and dia > 365{
						//Emigrar
						if ley_eneabled[5] and persona.familia.riqueza >= 10 * real(persona.familia.integrantes) and brandom() and not persona.preso{
							var familia = persona.familia
							if familia.padre.felicidad < 15 and familia.madre.felicidad < 15{
								if familia.padre != null_persona{
									destroy_persona(familia.padre, false, "Padre emigrado")
									mes_emigrantes[current_mes]++
								}
								if array_contains(familias, familia) and familia.madre != null_persona{
									destroy_persona(familia.madre, false, "Madre emigrada")
									mes_emigrantes[current_mes]++
								}
								if array_contains(familias, familia)
									for(var b = 0; b < array_length(familia.hijos); b++){
										destroy_persona(familia.hijos[b], false, "Hijo emigrado")
										mes_emigrantes[current_mes]++
									}
							}
						}
						//Protestas
						else if not in(persona.trabajo, null_edificio, jubilado, delincuente) and not persona.trabajo.paro and persona.trabajo.exigencia = null_exigencia and not persona.trabajo.privado and not persona.preso{
							var edificio = persona.trabajo, fel_ali = 0, fel_sal = 0, fel_edu = 0, num_edu = 0, fel_div = 0, fel_rel = 0
							for(var b = 0; b < array_length(edificio.trabajadores); b++){
								var trabajador = edificio.trabajadores[b]
								fel_ali += trabajador.familia.felicidad_alimento
								fel_sal += trabajador.felicidad_salud
								num_edu += array_length(trabajador.familia.hijos)
								for(var c = 0; c < array_length(trabajador.familia.hijos); c++)
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
				while array_length(embarazo[dia mod 365]) > 0{
					var persona = array_pop(embarazo[dia mod 365])
					persona.embarazo = -1
					var hijo = add_persona()
					hijo.familia = persona.familia
					if persona.familia.padre != null_persona
						hijo.apellido = persona.familia.padre.apellido
					else
						hijo.apellido = persona.familia.madre.apellido
					hijo.edad = 0
					array_pop(cumples[hijo.cumple])
					hijo.cumple = (dia mod 365)
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
				while array_length(muerte[dia mod 365]) > 0{
				var persona = array_shift(muerte[dia mod 365])
				destroy_persona(persona,, "Muerte de causa natural")
				mes_muertos[current_mes]++
			}
			#endregion
			//Ciclo de las empresas
			for(var a = 0; a < array_length(dia_empresas[dia mod 28]); a++){
				var empresa = dia_empresas[dia mod 28, a]
				//Compra de edificios
				if array_length(edificios_a_la_venta) > 0{
					var temp = edificios_a_la_venta[0], edificio = temp.edificio, temp_precio = temp.precio, width = temp.width, height = temp.height
					if not empresa.quiebra and irandom(10) < credibilidad_financiera and empresa.dinero > 2 * temp_precio{
						empresa_comprado = null_empresa
						array_shift(edificios_a_la_venta)
						x = edificio.x
						y = edificio.y
						if temp.estatal{
							mes_privatizacion[current_mes] += temp_precio
							dinero += temp_precio
							dinero_privado -= temp_precio
							inversion_privada += temp_precio
						}
						else if temp.empresa != null_empresa{
							array_remove(temp.empresa.ventas, temp, "edificio eliminado de los edificios a la venta de una empresa")
							temp.empresa.dinero += temp_precio
							for(var b = 0; b < array_length(temp.empresa.terreno); b++){
								var complex = temp.empresa.terreno[b]
								if complex.a >= x and complex.a < x + width and complex.b >= y and complex.b < y + height
									array_delete(temp.empresa.terreno, b--, 1)
							}
						}
						empresa.dinero -= temp_precio
						edificio.privado = true
						if edificio_nombre[edificio.tipo] = "Aserradero"
							edificio.modo = 0
						edificio.empresa = empresa
						array_push(empresa.edificios, edificio)
						set_presupuesto(0, edificio)
						for(var b = x; b < x + width; b++)
							for(var c = y; c < y + height; c++){
								array_set(zona_privada[b], c, true)
								array_set(zona_empresa[b], c, empresa)
								array_push(empresa.terreno, {a : b, b : c})
							}
						edificio.venta = false
						set_paro(false, edificio)
					}
					else{
						if empresa_comprado = null_empresa
							empresa_comprado = empresa
						else if empresa_comprado = empresa and array_length(edificios_a_la_venta) > 1{
							array_shift(edificios_a_la_venta)
							array_push(edificios_a_la_venta, temp)
						}
					}
				}
				//Impuestos
				var b = impuesto_empresa * array_length(empresa.edificios) + impuesto_empresa_fijo
				empresa.dinero -= b
				dinero += b
				mes_impuestos[current_mes] += b
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
			for(var a = 0; a < array_length(dia_trabajo[dia mod 28]); a++){
				var edificio = dia_trabajo[dia mod 28, a], index = edificio.tipo, width = edificio.width, height = edificio.height, var_edificio_nombre = edificio_nombre[index]
				if edificio.presupuesto > 3
					edificio_experiencia[index] = 2 - 0.99 * (2 - edificio_experiencia[index])
				if edificio = delincuente
					continue
				edificio.ganancia -= edificio.mantenimiento
				if edificio.privado{
					dinero_privado -= edificio.mantenimiento
					edificio.empresa.dinero -= edificio.mantenimiento
				}
				else{
					dinero -= edificio.mantenimiento
					mes_mantenimiento[current_mes] += edificio.mantenimiento
				}
				if edificio.ladron != null_persona{
					edificio.ladron.ladron = null_edificio
					edificio.ladron = null_persona
				}
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
						var b = floor(edificio.trabajo_sueldo * edificio.trabajo_mes / 28)
						edificio.ganancia -= b
						if edificio.privado{
							dinero_privado -= b
							edificio.empresa.dinero -= b
						}
						else{
							dinero -= b
							mes_sueldos[current_mes] += b
						}
						for(b = 0; b < array_length(edificio.trabajadores); b++)
							edificio.trabajadores[b].familia.riqueza += edificio.trabajo_sueldo
						//Granjas
						if var_edificio_nombre = "Granja"{
							if current_mes = 5 or current_mes = 10{
								edificio.almacen[recurso_cultivo[edificio.modo]] += round(15 * min(edificio.count, edificio.trabajo_mes / 5) * edificio.eficiencia * (0.8 + 0.1 * edificio.presupuesto) * (1 - clamp(contaminacion[edificio.x, edificio.y], 0, 100) / 200) * edificio_experiencia[index])
								edificio.count = 0
							}
							else
								edificio.count += array_length(edificio.trabajadores)
							b = 200 * array_contains(recurso_comida, recurso_cultivo[edificio.modo]) * edificio.es_almacen
							if (current_mes = edificio.mes_creacion or current_mes = (edificio.mes_creacion + 6) mod 12) and edificio.almacen[recurso_cultivo[edificio.modo]] > b{
								edificio.ganancia += recurso_precio[recurso_cultivo[edificio.modo]] * (edificio.almacen[recurso_cultivo[edificio.modo]] - b)
								add_encargo(recurso_cultivo[edificio.modo], edificio.almacen[recurso_cultivo[edificio.modo]] - b, edificio)
								edificio.almacen[recurso_cultivo[edificio.modo]] = b
							}
					
						}
						//Aserradero
						else if var_edificio_nombre = "Aserradero"{
							//Cortar árboles
							if array_length(edificio.array_complex) > 0{
								b = round(edificio.trabajo_mes / 5 * (0.8 + 0.1 * edificio.presupuesto) * edificio.eficiencia * edificio_experiencia[index])
								var e = b, flag = false
								while b > 0 and array_length(edificio.array_complex) > 0{
									var complex = edificio.array_complex[0]
									if b < bosque_madera[complex.a, complex.b]{
										array_set(bosque_madera[complex.a], complex.b, bosque_madera[complex.a, complex.b] - b)
										array_set(bosque_alpha[complex.a], complex.b, 0.5 + bosque_madera[complex.a, complex.b] / 400)
										b = 0
									}
									else if edificio.modo = 1{
										if bosque_madera[complex.a, complex.b] > 1{
											b -= bosque_madera[complex.a, complex.b] - 1
											array_set(bosque_madera[complex.a], complex.b, 1)
											array_set(bosque_alpha[complex.a], complex.b, 0.5)
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
										b -= bosque_madera[complex.a, complex.b]
										array_set(bosque_madera[complex.a], complex.b, 0)
										array_set(bosque[complex.a], complex.b, false)
										array_shift(edificio.array_complex)
										if array_length(edificio.array_complex) = 0{
											edificio.almacen[1] += e - b
											add_encargo(1, edificio.almacen[1], edificio)
											edificio.almacen[1] = 0
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
								edificio.almacen[1] += e - b
							}
							if (current_mes = edificio.mes_creacion or current_mes = (edificio.mes_creacion + 6) mod 12) and edificio.almacen[1] > 0{
								edificio.ganancia += recurso_precio[1] * edificio.almacen[1]
								add_encargo(1, edificio.almacen[1], edificio)
								edificio.almacen[1] = 0
							}
						}
						//Pescadería
						else if var_edificio_nombre = "Pescadería"{
							edificio.almacen[8] += round(edificio.trabajo_mes / 3 * (0.8 + 0.1 * edificio.presupuesto) * (1 - clamp(contaminacion[edificio.x, edificio.y], 0, 100) / 200) * edificio.eficiencia * edificio_experiencia[index])
							b = 200 * edificio.es_almacen
							if (current_mes = edificio.mes_creacion or current_mes = (edificio.mes_creacion + 6) mod 12) and edificio.almacen[8] > b{
								edificio.ganancia += recurso_precio[8] * (edificio.almacen[8] - b)
								add_encargo(8, edificio.almacen[8] - b, edificio)
								edificio.almacen[8] = b
							}
						}
						//Minas
						else if var_edificio_nombre = "Mina"{
							b = round(edificio.trabajo_mes / 2 * (0.8 + 0.1 * edificio.presupuesto) * edificio.eficiencia * edificio_experiencia[index])
							var e = b, f = min(xsize - 1, edificio.x + width + 1), g = min(ysize - 1, edificio.y + height + 1)
							for(var c = max(0, edificio.x - 1); c < f; c++){
								for(var d = max(0, edificio.y - 1); d < g; d++)
									if mineral[edificio.modo][c, d]{
										if mineral_cantidad[edificio.modo][c, d] <= b{
											b -= mineral_cantidad[edificio.modo][c, d]
											array_set(mineral[edificio.modo, c], d, false)
											if b = 0
												break
										}
										else{
											array_set(mineral_cantidad[edificio.modo, c], d, mineral_cantidad[edificio.modo][c, d] - b)
											b = 0
											break
										}
									}
								if b = 0
									break
							}
							edificio.almacen[recurso_mineral[edificio.modo]] += e - b
							if b > 0{
								var flag = false
								if edificio.privado{
									for(b = 0; b < array_length(recurso_mineral); b++){
										for(var c = max(0, edificio.x - 1); c < f; c++){
											for(var d = max(0, edificio.y - 1); d < g; d++)
												if mineral[(edificio.modo + b) mod array_length(recurso_mineral)][c, d]{
													flag = true
													break
												}
											if flag
												break
										}
										if flag{
											edificio.modo = (edificio.modo + b) mod array_length(recurso_mineral)
											break
										}
									}
								}
								if not flag{
									set_paro(true, edificio)
									add_encargo(recurso_mineral[edificio.modo], edificio.almacen[recurso_mineral[edificio.modo]], edificio)
									edificio.almacen[recurso_mineral[edificio.modo]] = 0
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
							if (current_mes = edificio.mes_creacion or current_mes = (edificio.mes_creacion + 6) mod 12) and edificio.almacen[recurso_mineral[edificio.modo]] > 0{
								edificio.ganancia += edificio.almacen[recurso_mineral[edificio.modo]] * recurso_precio[recurso_mineral[edificio.modo]]
								add_encargo(recurso_mineral[edificio.modo], edificio.almacen[recurso_mineral[edificio.modo]], edificio)
								edificio.almacen[recurso_mineral[edificio.modo]] = 0
							}
						}
						//Muelle
						else if var_edificio_nombre = "Muelle"{
							if current_mes = edificio.mes_creacion or current_mes = (edificio.mes_creacion + 6) mod 12{
								var c = round(edificio.trabajo_mes * 5 * (0.8 + 0.1 * edificio.presupuesto))
								for(b = 0; b < array_length(recurso_nombre) and c > 0; b++){
									//Importacion por construccion
									if recurso_construccion[b] > 0{
										var total = min(c, recurso_construccion[b]), d = floor(total * recurso_precio[b] * 1.2)
										dinero -= d
										mes_importaciones[current_mes] += d
										array_set(mes_importaciones_recurso[current_mes], b, d)
										recurso_construccion[b] -= total
									}
									//Exportaciones
									if recurso_exportado[b]{
										var total = min(c, edificio.almacen[b])
										edificio.almacen[b] -= total
										while total > 0{
											var d = total, temp_factor = 1
											if array_length(recurso_tratados[b]) > 0{
												var tratado = recurso_tratados[b, 0]
												temp_factor = tratado.factor
												d = min(total, tratado.cantidad)
												tratado.cantidad -= d
												if tratado.cantidad = 0{
													show_debug_message($"Has cumplido el tratado comercial de {recurso_nombre[b]} con {pais_nombre[tratado.pais]}")
													pais_relacion[tratado.pais]++
													array_shift(recurso_tratados[b])
													credibilidad_financiera = clamp(credibilidad_financiera + 1, 1, 10)
												}
											}
											total -= d
											d = floor(temp_factor * d * recurso_precio[b])
											mes_exportaciones[current_mes] += d
											array_set(mes_exportaciones_recurso[current_mes], b, mes_exportaciones_recurso[current_mes, b] + d)
											dinero += d
										}
										c -= total
									}
									#region Importaciones
									var total = min(c, recurso_importado[b])
									edificio.almacen[b] += total
									var d = floor(total * recurso_precio[b] * 1.2)
									dinero -= d
									mes_importaciones[current_mes] += d
									array_set(mes_importaciones_recurso[current_mes], b, mes_importaciones_recurso[current_mes, b] + d)
									recurso_importado[b] -= total
									c -= total
									total = min(c, recurso_importado_fijo[b])
									edificio.almacen[b] += total
									d = floor(total * recurso_precio[b] * 1.2)
									dinero -= d
									mes_importaciones[current_mes] += d
									array_set(mes_importaciones_recurso[current_mes], b, mes_importaciones_recurso[current_mes, b] + d)
									c -= total
									#endregion
								}
							}
						}
						//Rancho
						else if var_edificio_nombre = "Rancho"{
							b = round(edificio.trabajo_mes / 25 * (0.8 + 0.1 * edificio.presupuesto) * (1 - clamp(contaminacion[edificio.x, edificio.y], 0, 100) / 200) * edificio.eficiencia * edificio_experiencia[index])
							for(var c = 0; c < array_length(ganado_produccion[edificio.modo]); c++)
								edificio.almacen[ganado_produccion[edificio.modo, c]] += floor(10 * b / array_length(ganado_produccion[edificio.modo]))
							if current_mes = edificio.mes_creacion or current_mes = (edificio.mes_creacion + 6) mod 12
								for(b = 0; b < array_length(ganado_produccion[edificio.modo]); b++){
									var c = ganado_produccion[edificio.modo, b], d = 200 * array_contains(recurso_comida, c) * edificio.es_almacen
									if edificio.almacen[c] > d{
										edificio.ganancia += recurso_precio[c] * (edificio.almacen[c] - d)
										add_encargo(c, edificio.almacen[c] - d, edificio)
										edificio.almacen[c] = d
									}
								}
						
						}
						//Comisaría
						else if var_edificio_nombre = "Comisaría"{
							while array_length(edificio.clientes) > 0{
								var persona = array_shift(edificio.clientes)
								persona.preso = false
								cambiar_trabajo(persona, null_edificio)
							}
							for(b = irandom(edificio.trabajo_mes / 14 * (0.8 + 0.1 * edificio.presupuesto) * edificio.eficiencia * edificio_experiencia[index]); b > 0 and array_length(edificio.clientes) < edificio_clientes_max[index]; b--){
								var temp_edificio = edificio.casas_cerca[irandom(array_length(edificio.casas_cerca) - 1)]
								if temp_edificio.ladron != null_persona{
									var persona = temp_edificio.ladron
									array_push(edificio.clientes, persona)
									persona.preso = true
									temp_edificio.ladron = null_persona
									persona.ladron = null_edificio
									persona.felicidad_temporal -= 40
									if persona.pareja != null_persona
										persona.pareja.felicidad_temporal -= 25
									for(var c = 0; c < array_length(persona.familia.hijos); c++)
										persona.familia.hijos[c].felicidad_temporal -= 15
								}
								for(var c = 0; c < array_length(temp_edificio.familias); c++){
									var familia = temp_edificio.familias[c]
									if familia.padre != null_persona
										familia.padre.felicidad_crimen = min(100, familia.padre.felicidad_crimen + 4)
									if familia.madre != null_persona
										familia.madre.felicidad_crimen = min(100, familia.madre.felicidad_crimen + 4)
									for(var d = 0; d < array_length(familia.hijos); d++)
										familia.hijos[d].felicidad_crimen = min(100, familia.hijos[d].felicidad_crimen + 4)
								}
							}
						}
						//Industria genérica
						else if edificio_es_industria[index]{
							//Industria de inputs optativos
							if edificio_industria_optativo[index]{
								var max_rss = 0, max_c = 0
								for(var c = 0; c < array_length(edificio_industria_input_id[index]); c++){
									var d = floor(edificio.almacen[edificio_industria_input_id[index, c]] / edificio_industria_input_num[index, c])
									if d > max_rss{
										max_rss = d
										max_c = c
									}
								}
								if max_rss > 0{
									b = max(0, min(max_rss, round(edificio.trabajo_mes / 28 * (0.8 + 0.1 * edificio.presupuesto) * edificio_industria_velocidad[index] * edificio.eficiencia * edificio_experiencia[index])))
									if edificio_industria_vapor[index] and edificio.almacen[9] = 0
										b = 0
									if b > 0{
										edificio.almacen[edificio_industria_input_id[index, max_c]] -= b * edificio_industria_input_num[index, max_c]
										for(var c = 0; c < array_length(edificio_industria_output_id[index]); c++)
											edificio.almacen[edificio_industria_output_id[index, c]] += b * edificio_industria_output_num[index, c]
										if edificio_industria_vapor[index]
											edificio.almacen[9]--
									}
								}
							}
							//Industria de inputs rígidos
							else{
								var temp_array = []
								for(var c = 0; c < array_length(edificio_industria_input_id[index]); c++)
									array_push(temp_array, edificio.almacen[edificio_industria_input_id[index, c]] / edificio_industria_input_num[index, c])
								b = max(0, min(min_array(temp_array), round(edificio.trabajo_mes / 28 * (0.8 + 0.1 * edificio.presupuesto) * edificio_industria_velocidad[index] * edificio.eficiencia)))
								if edificio_industria_vapor[index] and edificio.almacen[9] = 0
									b = 0
								if b > 0{
									for(var c = 0; c < array_length(edificio_industria_input_id[index]); c++)
										edificio.almacen[edificio_industria_input_id[index, c]] -= b * edificio_industria_input_num[index, c]
									for(var c = 0; c < array_length(edificio_industria_output_id[index]); c++)
										edificio.almacen[edificio_industria_output_id[index, c]] += b * edificio_industria_output_num[index, c]
									if edificio_industria_vapor[index]
										edificio.almacen[9]--
								}
							}
							if current_mes = edificio.mes_creacion or current_mes = (edificio.mes_creacion + 6) mod 12{
								for(var c = 0; c < array_length(edificio_industria_input_id[index]); c++){
									var d = edificio_industria_input_id[index, c]
									edificio.ganancia -= recurso_precio[d] * (edificio.almacen[d] + edificio.pedido[d] - 120)
									add_encargo(d, edificio.almacen[d] + edificio.pedido[d] - 120, edificio)
									edificio.pedido[d] = 120 - edificio.almacen[d]
								}
								if edificio_industria_vapor[index]{
									edificio.ganancia -= recurso_precio[9] * (edificio.almacen[9] + edificio.pedido[9] - 120)
									add_encargo(9, edificio.almacen[9] + edificio.pedido[9] - 120, edificio)
									edificio.pedido[9] = 120 - edificio.almacen[9]
								}
								for(var c = 0; c < array_length(edificio_industria_output_id[index]); c++){
									var d = edificio_industria_output_id[index, c], e = 200 * array_contains(recurso_comida, d) * edificio.es_almacen
									if edificio.almacen[d] > e{
										edificio.ganancia += recurso_precio[d] * (floor(edificio.almacen[d]) - e)
										add_encargo(d, edificio.almacen[d] - e, edificio)
										edificio.almacen[d] = e
									}
								}
							}
						}
						//Mercado
						else if var_edificio_nombre = "Mercado"{
							for(b = 0; b < array_length(recurso_nombre); b++){
								var c = edificio.almacen[b] + edificio.pedido[b] - 100
								if array_contains(recurso_comida, b) or array_contains(recurso_lujo, b) and c < 0{
									edificio.ganancia -= recurso_precio[b] * c
									add_encargo(b, c, edificio)
									edificio.pedido[b] = 100 - edificio.almacen[b]
								}
							}
						}
						//Tejar
						else if var_edificio_nombre = "Tejar"{
							b = round(edificio.trabajo_mes / 7 * (0.8 + 0.1 * edificio.presupuesto) * edificio.eficiencia * edificio_experiencia[index])
							edificio.almacen[26] += b
							if (current_mes = edificio.mes_creacion or current_mes = (edificio.mes_creacion + 6) mod 12) and edificio.almacen[26] > 0{
								edificio.ganancia += recurso_precio[26] * edificio.almacen[26]
								add_encargo(26, edificio.almacen[26], edificio)
								edificio.almacen[26] = 0
							}
						}
						//Pozo Petrolífero
						else if var_edificio_nombre = "Pozo Petrolífero"{
							b = round(edificio.trabajo_mes / 7 * (0.8 + 0.1 * edificio.presupuesto) * edificio.eficiencia * edificio_experiencia[index])
							var e = b, f = edificio.x + width, g = edificio.y + height
							for(var c = edificio.x; c < f; c++){
								for(var d = edificio.x; d < g; d++)
									if petroleo[c, d] > 0{
										if petroleo[c, d] > b{
											array_set(petroleo[c], d, petroleo[c, d] - b)
											b = 0
										}
										else{
											b -= petroleo[c, d]
											array_set(petroleo[c], d, 0)
										}
										if b = 0
											break
									}
								if b = 0
									break
							}
							edificio.almacen[27] += e - b
							if e > 0 and b > 0{
								edificio.ganancia += recurso_precio[27] * edificio.almacen[27]
								add_encargo(27, edificio.almacen[27], edificio)
								edificio.almacen[27] = 0
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
							if (current_mes = edificio.mes_creacion or current_mes = (edificio.mes_creacion + 6) mod 12) and edificio.almacen[27] > 0{
								edificio.ganancia += recurso_precio[27] * edificio.almacen[27]
								add_encargo(27, edificio.almacen[27], edificio)
								edificio.almacen[27] = 0
							}
						}
					}
				}
				//Casas
				if edificio_es_casa[index] and (array_length(edificio.familias) > 0 or var_edificio_nombre = "Toma"){
					if var_edificio_nombre = "Toma" and array_length(edificio.familias) = 0{
						destroy_edificio(edificio)
						continue
					}
					var b = edificio_familias_renta[index] * array_length(edificio.familias)
					edificio.ganancia += b
					if edificio.privado{
						dinero_privado += b
						edificio.empresa.dinero +=b
					}
					else{
						dinero += b
						mes_renta[current_mes] += b
					}
					var poblacion = 0
					for(b = 0; b < array_length(edificio.familias); b++)
						poblacion += edificio.familias[b].integrantes
					//Conseguir alimento
					for(b = 0; b < array_length(edificio_almacen_index); b++)
						if array_length(almacenes[edificio_almacen_index[b]]) > 0{
							var tienda = almacenes[edificio_almacen_index[b]][irandom(array_length(almacenes[edificio_almacen_index[b]]) - 1)]
							for(var c = 0; c < array_length(recurso_comida); c++){
								var d = recurso_comida[c]
								if edificio.almacen[d] < poblacion and tienda.almacen[d] > 0{
									var e = poblacion - edificio.almacen[d]
									if tienda.almacen[d] >= e{
										tienda.almacen[d] -= e
										edificio.almacen[d] += e
										if tienda.privado{
											var temp_precio = round(e * recurso_precio[d])
											dinero -= temp_precio
											dinero_privado += temp_precio
											mes_compra_interna[current_mes] += temp_precio
											array_set(mes_compra_recurso[current_mes], d, mes_compra_recurso[current_mes, d] + temp_precio)
											edificio.empresa.dinero += temp_precio
										}
									}
									else{
										edificio.almacen[d] += tienda.almacen[d]
										if tienda.privado{
											var temp_precio = round(tienda.almacen[d] * recurso_precio[d])
											dinero -= temp_precio
											dinero_privado += temp_precio
											mes_compra_interna[current_mes] += temp_precio
											array_set(mes_compra_recurso[current_mes], d, mes_compra_recurso[current_mes, d] + temp_precio)
										}
										tienda.almacen[d] = 0
									}
								}
							}
						}
					//Repartir comida
					var fel_comida = 0, comida_total = 0, comida_variedad = 0, flag = true
					for(b = 0; b < array_length(recurso_comida); b++){
						comida_total += edificio.almacen[recurso_comida[b]]
						if edificio.almacen[recurso_comida[b]] > poblacion / 2
							comida_variedad++
					}
					//Demanda satisfecha
					if comida_total >= poblacion{
						fel_comida = min(100, 20 + 15 * comida_variedad)
						for(b = 0; b < array_length(recurso_comida); b++)
							edificio.almacen[recurso_comida[b]] = floor(edificio.almacen[recurso_comida[b]] * (comida_total - poblacion) / comida_total)
						if not ley_eneabled[4]
							for(b = 0; b < array_length(edificio.familias); b++){
								var familia = edificio.familias[b], c = min(familia.riqueza, familia.integrantes)
								familia.riqueza -= c
								if edificio.privado{
									dinero_privado += c
									edificio.empresa.dinero += c
								}
								else{
									dinero += c
									mes_tarifas[current_mes] += c
								}
							}
					}
					//Demanda insatisfecha
					else{
						fel_comida = min(100, 20 + 15 * comida_variedad) * comida_total / poblacion
						for(b = 0; b < array_length(recurso_comida); b++)
							edificio.almacen[recurso_comida[b]] = 0
						if not ley_eneabled[4]
							for(b = 0; b < array_length(edificio.familias); b++){
								var familia = edificio.familias[b], c = min(familia.riqueza, floor(familia.integrantes * comida_total / poblacion))
								familia.riqueza -= c
								if edificio.privado{
									dinero_privado += c
									edificio.empresa.dinero += c
								}
								else{
									dinero += c
									mes_tarifas[current_mes] += c
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
								mes_inanicion[current_mes] ++
							}
							if not flag and familia.madre != null_persona{
								flag = destroy_persona(familia.madre,, "Madre muerta de inanicion")
								if exigencia_pedida[2]
									fallar_exigencia(2)
								mes_inanicion[current_mes]++
							}
							if not flag
								for(var c = 0; not flag and c < array_length(familia.hijos); c++)
									if brandom(){
										flag = destroy_persona(familia.hijos[c],, "Hijo muerto de inanicion")
										if exigencia_pedida[2]
											fallar_exigencia(2)
										mes_inanicion[current_mes]++
										c--
									}
							if flag{
								for(var c = 0; c < array_length(personas); c++)
									personas[c].felicidad_temporal -= 2
								b--
								continue
							}
						}
					}
					if edificio != homeless
						for(b = 0; b < array_length(edificio.familias); b++){
							var familia = edificio.familias[b]
							familia.riqueza -= edificio_familias_renta[index]
							if familia.riqueza <= -30{
								cambiar_casa(familia, homeless)
								b--
							}
						}
				}
				//Edificios médicos
				if edificio_es_medico[index]{
					//Curar pacientes
					repeat(min(array_length(edificio.clientes), round(edificio_clientes_calidad[index] * edificio.trabajo_mes / 1400 * (0.8 + 0.1 * edificio.presupuesto) * edificio.eficiencia * edificio_experiencia[index]))){
						var persona = array_shift(edificio.clientes)
						persona.felicidad_salud = edificio_clientes_calidad[index]
						persona.medico = null_edificio
						if array_length(desausiado.clientes) > 0{
							var temp_persona = array_shift(desausiado.clientes)
							array_push(edificio.clientes, temp_persona)
							temp_persona.medico = edificio
						}
					}
					//Pacientes no curados
					for(var b = 0; b < array_length(edificio.clientes); b++){
						var persona = edificio.clientes[b]
						persona.felicidad_salud = floor(persona.felicidad_salud) / 2
						if irandom(10) > persona.felicidad_salud{
							var familia = persona.familia
							if familia.padre != null_persona{
								familia.padre.felicidad_salud = floor(familia.padre.felicidad_salud / 2)
								familia.padre.felicidad_temporal -= 50
							}
							if familia.madre != null_persona{
								familia.madre.felicidad_salud= floor(familia.madre.felicidad_salud / 2)
								familia.madre.felicidad_temporal -= 50
							}
							for(var c = 0; c < array_length(persona.familia.hijos); c++){
								familia.hijos[c].felicidad_salud = floor(familia.hijos[c].felicidad_salud / 2)
								familia.hijos[c].felicidad_temporal -= 25
							}
							if not in(persona.trabajo, null_edificio, jubilado, delincuente)
								for(var c = 0; c < array_length(persona.trabajo.trabajadores); c++)
									persona.trabajo.trabajadores[c].felicidad_salud = floor(persona.trabajo.trabajadores[c].felicidad_salud * 0.75)
							if persona.escuela != null_edificio{
								for(var c = 0; c < array_length(persona.escuela.trabajadores); c++)
									persona.escuela.trabajadores[c].felicidad_salud = floor(persona.escuela.trabajadores[c].felicidad_salud * 0.9)
								for(var c = 0; c < array_length(persona.escuela.clientes); c++)
									persona.escuela.clientes[c].felicidad_salud = floor(persona.escuela.clientes[c].felicidad_salud * 0.9)
							}
							destroy_persona(persona,, $"Paciente muerto ({persona.medico.nombre})")
							mes_enfermos[current_mes]++
							b--
						}
						else if brandom(){
							array_remove(edificio.clientes, persona, "paciente curado")
							persona.medico = null_edificio
							b--
						}
					}
				}
				//Edificios de ocio y religiosos
				if edificio_es_ocio[index] or edificio_es_iglesia[index]{
					if edificio.trabajadores_max = 0
						edificio.count = 0
					else
						edificio.count = max(0, floor(edificio.count * (1 - edificio.trabajo_mes / 28 / edificio.trabajadores_max * edificio.eficiencia * edificio_experiencia[index])))
				}
				edificio.trabajo_mes = 28 * array_length(edificio.trabajadores)
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
		}
	}
	#region abreviatura
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
			sel_build = false
			sel_info = false
		}
		//Pantalla completa
		if keyboard_check_pressed(vk_f4){
			window_set_fullscreen(not window_get_fullscreen())
			ini_open(roaming + "config.txt")
			ini_write_real("MAIN", "fullscreen", window_get_fullscreen())
			ini_close()
		}
		//Claves
		if keyboard_check(vk_lshift) and keyboard_check(ord("4")){
			dinero += 1000
			mes_herencia[current_mes] += 1000
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
		draw_set_font(Font1)
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
}
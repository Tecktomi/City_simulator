if keyboard_check_pressed(vk_f4)
	window_set_fullscreen(not window_get_fullscreen())
window_set_cursor(cr_default)
//Dibujar mundo
if not d3{
	for(var a = 0; a <= xsize; a++)
		draw_line(a * 16 - xpos, -ypos, a * 16 - xpos, ysize * 16 - ypos)
	for(var a = 0; a <= ysize; a++)
		draw_line(-xpos, a * 16 - ypos, xsize * 16 - xpos, a * 16 - ypos)
	for(var a = floor(xpos / 16); a < ceil((xpos + room_width) / 16); a++)
		for(var b = floor(ypos / 16); b < ceil((ypos + room_height) / 16); b++)
			if mar[a, b]{
				draw_set_color(make_color_rgb(0, 0, 255 * altura[# a, b]))
				draw_rectangle(a * 16 - xpos, b * 16 - ypos, a * 16 + 15 - xpos, b * 16 + 15 - ypos, false)
			}
			else{
				if altura[# a, b] < 0.6
					draw_set_color(make_color_rgb(255 / 0.6 * (1.1 - altura[# a, b]), 255 / 0.6 * (1.1 - altura[# a, b]), 127))
				else
					draw_set_color(make_color_rgb(31 + 96 * altura[# a, b], 127, 31 + 96 * altura[# a, b]))
				draw_rectangle(a * 16 - xpos, b * 16 - ypos, a * 16 + 15 - xpos, b * 16 + 15 - ypos, false)
			}
}
else{
	if background[0, 0] = spr_arbol{
		var s = 72, r = 480, temp_text = ""
		var surf = surface_create(room_width, room_height)
		surface_set_target(surf)
		for(var c = 0; c < xsize / 40; c++)
			for(var d = 0; d < ysize / 40; d++){
				draw_set_color(c_black)
				draw_rectangle(0, 0, room_width, room_height, false)
				for(var a = 0; a < 40 - ((c + 1) * 40 = xsize); a++)
				 for(var b = 0; b < 40 - ((d + 1) * 40 = ysize); b++){
						var e = 40 * c + a
						var f = 40 * d + b
						//Cálculo de arístas
						vern_x[e, f] = r + 12 * (b - a);		vern_y[e, f] = s + 8 * (a + b) - 6 * max(0, altura[# e, f])
			            vere_x[e, f] = r + 12 * (b - a - 1);	vere_y[e, f] = s + 8 * (a + b + 1) - 6 * max(0, altura[# e + 1, f])
			            vero_x[e, f] = r + 12 * (b - a + 1);	vero_y[e, f] = s + 8 * (a + b + 1) - 6 * max(0, altura[# e, f + 1])
			            vers_x[e, f] = r + 12 * (b - a);		vers_y[e, f] = s + 8 * (a + b + 2) - 6 * max(0, altura[# e + 1, f + 1])
						temp_text += "(" + string(e) + ", " + string(f) + ": " + string(vern_x[e, f]) + ", " + string(vern_y[e, f]) + ") "
						//Dibujo de relleno
						draw_set_color(scr_color(altura[# e, f], altura[# e + 1, f]))
		                draw_triangle(vern_x[e, f], vern_y[e, f], vere_x[e, f], vere_y[e, f], vers_x[e, f], vers_y[e, f], false)
		                draw_set_color(scr_color(altura[# e, f], altura[# e, f + 1]))
		                draw_triangle(vern_x[e, f], vern_y[e, f], vero_x[e, f], vero_y[e, f], vers_x[e, f], vers_y[e, f], false)
						//División casillas no planas
		                if altura[# e + 1, f + 1] != altura[# e, f]{
		                    draw_set_color(scr_color(altura[# e, f], altura[# e + 1, f + 1]))
		                    draw_triangle(vere_x[e, f], vere_y[e, f], vero_x[e, f], vero_y[e, f], vers_x[e, f], vers_y[e, f], false)
						}
						//Bordes del mundo
		                if a = xsize - 2{
		                    draw_set_color(make_color_rgb(95, 63, 31))
		                    draw_triangle(vere_x[e, f], vere_y[e, f], vers_x[e, f], vers_y[e, f], vere_x[e, f], s + 8 * (40 + b), false)
		                    draw_triangle(vere_x[e, f], s + 8 * (40 + b), vers_x[e, f], vers_y[e, f], vers_x[e, f], s + 8 * (40 + b + 1), false)
						}
		                if b = ysize - 2{
		                    draw_set_color(make_color_rgb(95, 63, 31))
		                    draw_triangle(vero_x[e, f], vero_y[e, f], vers_x[e, f], vers_y[e, f], vero_x[e, f], s + 8 * (40 + a), false)
		                    draw_triangle(vero_x[e, f], s + 8 * (40 + a), vers_x[e, f], vers_y[e, f], vers_x[e, f], s + 8 * (40 + a + 1), false)
						}
						//Borde
		                draw_set_color(c_dkgray)
		                draw_line(vern_x[e, f], vern_y[e, f], vere_x[e, f], vere_y[e, f])
		                draw_line(vern_x[e, f], vern_y[e, f], vero_x[e, f], vero_y[e, f])
		                draw_line(vers_x[e, f], vers_y[e, f], vere_x[e, f], vere_y[e, f])
		                draw_line(vers_x[e, f], vers_y[e, f], vero_x[e, f], vero_y[e, f])
					}
				array_set(background[c], d, sprite_create_from_surface(surf, 0, 0, room_width, room_height, true, false, 0, 0))
			}
		surface_reset_target()
		surface_free(surf)
		show_debug_message(temp_text)
	}
	else
		for(var c = 0; c < array_length(background); c++)
			for(var d = 0; d < array_length(background[0]); d++)
				draw_sprite_stretched(background[c, d], 0, -xpos + 480 * (d - c) * zoom, -ypos + 320 * (c + d) * zoom, room_width * zoom, room_height * zoom)
}
if keyboard_check(ord("G")){
	if mouse_wheel_up()
		build_type = (build_type + 1) mod array_length(recurso_cultivo)
	if mouse_wheel_down()
		build_type = (build_type + array_length(recurso_cultivo) - 1) mod array_length(recurso_cultivo)
}
if keyboard_check(ord("G")) or (build_sel and edificio_nombre[build_index] = "Granja")
	dibujo_gradiente(build_type, true)
if keyboard_check(ord("M")){
	if mouse_wheel_up()
		build_type = (build_type + 1) mod array_length(recurso_mineral)
	if mouse_wheel_down()
		build_type = (build_type + array_length(recurso_mineral) - 1) mod array_length(recurso_mineral)
}
if keyboard_check(ord("M")) or (build_sel and edificio_nombre[build_index] = "Mina")
	dibujo_gradiente(build_type, false)
//Dibujo de arboles
if d3{
	for(var a = 0; a < xsize; a++)
		for(var b = 0; b < ysize; b++)
			if bosque[a, b]
				draw_sprite(spr_arbol, 0, vern_x[a, b] - xpos + 480 * (floor(b / 40) - floor(a / 40)), vern_y[a, b] - ypos+ 320 * (floor(a / 40) + floor(b / 40)))
}
else{
	for(var a = floor(xpos / 16); a < min(xsize - 1, ceil((xpos + room_width) / 16)); a++)
		for(var b = floor(ypos / 16); b < min(ysize - 1, ceil((ypos + room_height) / 16)); b++)
			if bosque[a, b]
				draw_sprite(spr_arbol, 0, a * 16 - xpos, b * 16 - ypos)
	}
draw_set_alpha(0.5)
draw_set_color(c_ltgray)
draw_rectangle(0, room_height, string_width("FPS: " + string(fps) + "\n" + fecha(dia) + "\n" + string(array_length(personas)) + " habitantes\n$" + string(dinero)), room_height - string_height("FPS: " + string(fps) + "\n" + fecha(dia) + "\n" + string(array_length(personas)) + " habitantes\n$" + string(dinero)), false)
draw_set_color(c_black)
draw_set_valign(fa_bottom)
draw_text(0, room_height, "FPS: " + string(fps) + "\n" + fecha(dia) + "\n" + string(array_length(personas)) + " habitantes\n$" + string(dinero))
draw_set_valign(fa_top)
draw_set_alpha(1)
//Dibujar contornos de edificios
for(var a = 0; a < array_length(edificios); a++){
	var edificio = edificios[a], b = edificio.x, c = edificio.y
	draw_set_color(make_color_hsv(edificio_color[edificio.tipo], 255, 255))
	draw_rectangle(b * 16 - xpos, c * 16 - ypos, (b + edificio_width[edificio.tipo]) * 16 - 1 - xpos, (c + edificio_height[edificio.tipo]) * 16 - 1 - ypos, false)
	draw_set_color(c_white)
	draw_rectangle(b * 16 - xpos, c * 16 - ypos, (b + edificio_width[edificio.tipo]) * 16 - 1 - xpos, (c + edificio_height[edificio.tipo]) * 16 - 1 - ypos, true)
}
//Abrir menú de construcción
if mouse_check_button_pressed(mb_right) and not build_sel{
	sel_build = not sel_build
	sel_info = false
	build_type = 0
}
//Menú de construcción
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
		if draw_boton(b, 80, edificio_categoria_nombre[a], true)
			build_categoria = a
		b += last_width
	}
	pos = 110
	for(var a = 0; a < array_length(edificio_categoria[build_categoria]); a++)
		if draw_boton(110, pos, edificio_nombre[edificio_categoria[build_categoria, a]] + " $" + string(edificio_precio[edificio_categoria[build_categoria, a]])) and dinero >= edificio_precio[edificio_categoria[build_categoria, a]]{
			build_index = edificio_categoria[build_categoria, a]
			build_sel = true
			sel_build = false
		} 
}
//Colocar edificio
if build_sel{
	var mx = min(xsize - edificio_width[build_index], max(0, floor((mouse_x + xpos) / 16)))
	var my = min(ysize - edificio_height[build_index], max(0, floor((mouse_y + ypos) / 16)))
	draw_set_color(make_color_hsv(edificio_color[build_index], 255, 255))
	draw_set_alpha(0.5)
	draw_rectangle(mx * 16 - xpos, my * 16 - ypos, (mx + edificio_width[build_index]) * 16 - 1 - xpos, (my + edificio_height[build_index]) * 16 - 1 - ypos, false)
	draw_set_alpha(1)
	draw_set_color(c_white)
	//Calcular la eficiencia de las granjas
	if edificio_nombre[build_index] = "Granja"{
		var c = 0
		for(var a = 0; a < edificio_width[build_index]; a++)
			for(var b = 0; b < edificio_height[build_index]; b++)
				c += cultivo[build_type][# mx + a, my + b]
		draw_text(mx * 16 - xpos, (my - 1) * 16 - ypos, "Eficiencia: " + string(floor(c * 100 / edificio_width[build_index] / edificio_height[build_index])) + "%")
		if mouse_wheel_up()
			build_type = (build_type + 1) mod array_length(recurso_cultivo)
		if mouse_wheel_down()
			build_type = (build_type + array_length(recurso_cultivo) - 1) mod array_length(recurso_cultivo)
	}
	//Minas
	var flag = true
	if edificio_nombre[build_index] = "Mina"{
		draw_rectangle((mx - 1) * 16 - xpos, (my - 1) * 16 - ypos, (mx + edificio_width[build_index] + 1) * 16 - 1 - xpos, (my + edificio_height[build_index] + 1) * 16 - 1 - ypos, true)
		flag = false
		var c = 0
		for(var a = max(0, mx - 1); a < min(xsize - 1, mx + edificio_width[build_index] + 1); a++)
			for(var b = max(0, my - 1); b < min(ysize - 1, my + edificio_height[build_index] + 1); b++)
				if mineral[build_type][a, b]{
					flag = true
					c += mineral_cantidad[build_type][a, b]
				}
		if mouse_wheel_up()
			build_type = (build_type + 1) mod array_length(recurso_mineral)
		if mouse_wheel_down()
			build_type = (build_type + array_length(recurso_mineral) - 1) mod array_length(recurso_mineral)
		if flag
			draw_text(mx * 16 - xpos, (my - 1) * 16 - ypos, "Depósito: " + string(c))
	}
	//Detectar terreno inválido
	if flag
		if not edificio_es_costero[build_index]{
			for(var a = 0; a < edificio_width[build_index]; a++){
				for(var b = 0; b < edificio_height[build_index]; b++)
					if bool_edificio[mx + a, my + b] or bosque[mx + a, my + b] or mar[mx + a, my + b]{
						flag = false
						break
					}
				if not flag
					break
			}
			//Detectar árboles cerca
			if flag and edificio_nombre[build_index] = "Aserradero"{
				draw_rectangle(max(0, mx - 4) * 16 - xpos, max(0, my - 4) * 16 - ypos, min(mx + edificio_width[build_index] + 4, xsize) * 16 - 1 - xpos, min(my + edificio_height[build_index] + 4, ysize) * 16 - 1 - ypos, true)
				var flag_2 = false, c = 0
				for(var a = max(0, mx - 4); a < min(mx + edificio_width[build_index] + 4, xsize); a++)
					for(var b = max(0, my - 4); b < min(my + edificio_height[build_index] + 4, ysize); b++)
						if bosque[a, b]{
							flag_2 = true
							c += bosque_madera[a, b]
						}
				if not flag_2{
					flag = false
					draw_text(mx * 16 - xpos, (my - 2) * 16 - ypos, "Se necesitan árboles cerca")
				}
				else
					draw_text(mx * 16 - xpos, (my - 2) * 16 - ypos, string(c) + " madera disponible")
			}
		}
		//Construcción del muelle
		else
			flag = edificio_valid_place(mx, my, build_index)
	if not flag
		draw_text(mx * 16 - xpos, (my - 2) * 16 - ypos, "Construcción bloqueada")
	if mouse_check_button_pressed(mb_left){
		mouse_clear(mb_left)
		if flag{
			build_sel = keyboard_check(vk_lshift)
			dinero -= edificio_precio[build_index]
			mes_construccion[current_mes] += edificio_precio[build_index]
			var edificio = add_edificio(mx, my, build_index)
			if edificio_nombre[build_index] = "Granja"{
				var c = 0
				for(var a = 0; a < edificio_width[build_index]; a++)
					for(var b = 0; b < edificio_height[build_index]; b++)
						c += cultivo[build_type][# mx + a, my + b]
				edificio.eficiencia = c / edificio_width[build_index] / edificio_height[build_index]
				edificio.modo = build_type
			}
			else if edificio_nombre[build_index] = "Mina"
				edificio.modo = build_type
		}
	}
	if mouse_check_button_pressed(mb_right){
		mouse_clear(mb_right)
		build_sel = false
	}
}
//Seleccionar edificio
if mouse_check_button_pressed(mb_left){
	var mx = floor((mouse_x + xpos) / 16)
	var my = floor((mouse_y + ypos) / 16)
	if mx >= 0 and my >= 0 and mx < xsize and my < ysize and mouse_x < room_width - sel_info * 300{
		mouse_clear(mb_left)
		sel_info = bool_edificio[mx, my]
		if sel_info{
			sel_edificio = id_edificio[mx, my]
			sel_familia = null_familia
			sel_persona = null_persona
			sel_tipo = 0
		}
	}
}
//Informacion edificio
if sel_info{
	draw_set_color(c_ltgray)
	draw_rectangle(room_width, 0, room_width - 300, room_height, false)
	draw_set_color(c_black)
	draw_set_halign(fa_right)
	var temp_text = ""
	pos = 0
	if sel_tipo = 0 and sel_edificio != null_edificio{
		draw_text_pos(room_width, pos, edificio_nombre[sel_edificio.tipo])
		//Información familias
		if edificio_es_casa[sel_edificio.tipo]{
			draw_text_pos(room_width - 20, pos, "Familias: " + string(array_length(sel_edificio.familias)) + "/" + string(edificio_familias_max[sel_edificio.tipo]))
			for(var a = 0; a < array_length(sel_edificio.familias); a++)
				if draw_boton(room_width - 40, pos, "Familia " + sel_edificio.familias[a].padre.apellido + " " + sel_edificio.familias[a].madre.apellido){
					sel_familia = sel_edificio.familias[a]
					sel_tipo = 1
				}
		}
		//Información trabajadores
		if edificio_es_trabajo[sel_edificio.tipo]{
			draw_text_pos(room_width - 20, pos, "Trabajadores: " + string(array_length(sel_edificio.trabajadores)) + "/" + string(edificio_trabajadores_max[sel_edificio.tipo]))
			for(var a = 0; a < array_length(sel_edificio.trabajadores); a++)
				if draw_boton(room_width - 40, pos, name(sel_edificio.trabajadores[a])){
					sel_persona = sel_edificio.trabajadores[a]
					sel_tipo = 2
				}
			if edificio_nombre[sel_edificio.tipo] = "Granja"{
				if current_mes = 5 or current_mes = 10
					draw_text_pos(room_width - 20, pos, "Consecha")
				else
					draw_text_pos(room_width - 20, pos, "Siembra")
				draw_text_pos(room_width - 40, pos, "Eficiencia: " + string(floor(sel_edificio.eficiencia * 100)) + "%")
				draw_text_pos(room_width - 40, pos, string(sel_edificio.count) + " plantas")
				draw_text_pos(room_width - 20, pos, "\nProduciendo " + recurso_nombre[recurso_cultivo[sel_edificio.modo]])
				if draw_boton(room_width - 20, pos, "Cambiar recurso")
					sel_modo = not sel_modo
				if sel_modo
					for(var a = 0; a < array_length(recurso_cultivo); a++)
						if a != sel_edificio.modo{
							if draw_boton(room_width - 40, pos, recurso_nombre[recurso_cultivo[a]])
								sel_edificio.modo = a
							if mouse_x > room_width - 40 - last_width and mouse_y > pos - last_height and mouse_x < room_width - 40 and mouse_y < pos{
								dibujo_gradiente(a, true)
								draw_set_color(c_black)
							}
						}
			}
			if edificio_nombre[sel_edificio.tipo] = "Mina"{
				draw_text_pos(room_width - 20, pos, "Extrayendo " + recurso_nombre[recurso_mineral[sel_edificio.modo]])
				var c = 0
				for(var a = max(0, sel_edificio.x - 1); a < min(xsize - 1, sel_edificio.x + edificio_width[sel_edificio.tipo] + 1); a++)
					for(var b = max(0, sel_edificio.y - 1); b < min(xsize - 1, sel_edificio.y + edificio_height[sel_edificio.tipo] + 1); b++)
						if mineral[sel_edificio.modo][a, b]
							c += mineral_cantidad[sel_edificio.modo][a, b]
				draw_text_pos(room_width - 40, pos, "Depósito: " + string(c))
				if draw_boton(room_width - 20, pos, "Cambiar recurso")
					sel_modo = not sel_modo
				if sel_modo
					for(var a = 0; a < array_length(recurso_mineral); a++)
						if a != sel_edificio.modo{
							if draw_boton(room_width - 40, pos, recurso_nombre[recurso_mineral[a]])
								sel_edificio.modo = a
							if mouse_x > room_width - 40 - last_width and mouse_y > pos - last_height and mouse_x < room_width - 40 and mouse_y < pos{
								dibujo_gradiente(a, false)
								draw_set_color(c_black)
							}
						}
			}
		}
		//Información escuelas / consultas
		if edificio_es_escuela[sel_edificio.tipo] or edificio_es_medico[sel_edificio.tipo]{
			if edificio_es_escuela[sel_edificio.tipo]
				draw_text_pos(room_width - 20, pos, "Estudiantes: " + string(array_length(sel_edificio.clientes)) + "/" + string(edificio_clientes_max[sel_edificio.tipo]))
			else
				draw_text_pos(room_width - 20, pos, "Pacientes: " + string(array_length(sel_edificio.clientes)) + "/" + string(edificio_clientes_max[sel_edificio.tipo]))
			for(var a = 0; a < array_length(sel_edificio.clientes); a++)
				if draw_boton(room_width - 40, pos, name(sel_edificio.clientes[a])){
					sel_persona = sel_edificio.clientes[a]
					sel_tipo = 2
				}
		}
		//Almacen
		for(var a = 0; a < array_length(recurso_nombre); a++)
			if sel_edificio.almacen[a] > 0
				draw_text_pos(room_width - 40, pos, recurso_nombre[a] + ": " + string(sel_edificio.almacen[a]))
		//Edificios cercanos
		draw_text_pos(room_width - 20, pos, string(array_length(sel_edificio.edificios_cerca)) + " edificios cerca")
		for(var a = 0; a < array_length(sel_edificio.edificios_cerca); a++){
			var temp_edificio = sel_edificio.edificios_cerca[a]
			if draw_boton(room_width - 40, pos, edificio_nombre[temp_edificio.tipo]){
				sel_edificio = temp_edificio
				break
			}
		}
		//Destruir edificio
		if draw_boton(room_width, pos, "\n\nDestruir Edificio") and (sel_edificio.tipo != 13 or array_length(edificio_count[13]) > 0){
			destroy_edificio(sel_edificio)
			sel_info = false
		}
	}
	//Información de una familia
	else if sel_tipo = 1 and sel_familia != null_familia{
		draw_text_pos(room_width, pos, "Familia " + sel_familia.padre.apellido + " " + sel_familia.madre.apellido)
		if sel_familia.casa = homeless
			draw_text_pos(room_width - 20, pos, "Sin hogar")
		else if draw_boton(room_width - 20, pos, "Vivienda : " + edificio_nombre[sel_familia.casa.tipo]){
			sel_edificio = sel_familia.casa
			sel_tipo = 0
		}
		if sel_familia.padre != null_persona and draw_boton(room_width - 20, pos, "Padre: " + name(sel_familia.padre)){
			sel_persona = sel_familia.padre
			sel_tipo = 2
		}
		if sel_familia.madre != null_persona and draw_boton(room_width - 20, pos, "Madre: " + name(sel_familia.madre)){
			sel_persona = sel_familia.madre
			sel_tipo = 2
		}
		if array_length(sel_familia.hijos) > 0
			draw_text_pos(room_width - 20, pos, "Hijos")
		for(var a = 0; a < array_length(sel_familia.hijos); a++)
			if draw_boton(room_width - 40, pos, name(sel_familia.hijos[a])){
				sel_persona = sel_familia.hijos[a]
				sel_tipo = 2
			}
	}
	//Información de personas
	else if sel_tipo = 2 and sel_persona != null_persona{
		draw_text_pos(room_width, pos, name(sel_persona))
		draw_text_pos(room_width - 20, pos, "Nacionalidad: " + pais_nombre[sel_persona.nacionalidad])
		if sel_persona.religion
			draw_text_pos(room_width - 20, pos, "Creyente")
		else
			draw_text_pos(room_width - 20, pos, "Ate" + ao(sel_persona))
		draw_text_pos(room_width - 20, pos, "Edad: " + string(sel_persona.edad) + "  (" + fecha(sel_persona.cumple, false) + ")")
		if draw_boton(room_width - 20, pos, "Familia " + sel_persona.familia.padre.apellido + " " + sel_persona.familia.madre.apellido){
			sel_familia = sel_persona.familia
			sel_tipo = 1
		}
		if sel_persona.familia.casa = homeless
			draw_text_pos(room_width - 20, pos, "Sin hogar")
		else if draw_boton(room_width - 20, pos, "Vive en: " + edificio_nombre[sel_persona.familia.casa.tipo]){
			sel_edificio = sel_persona.familia.casa
			sel_tipo = 0
		}
		if sel_persona.trabajo = null_edificio
			draw_text_pos(room_width - 20, pos, "Sin trabajo")
		else if draw_boton(room_width - 20, pos, "Trabaja en: " + edificio_nombre[sel_persona.trabajo.tipo]){
			sel_edificio = sel_persona.trabajo
			sel_tipo = 0
		}
		draw_text_pos(room_width - 20, pos, "Educación: " + educacion_nombre[floor(sel_persona.educacion)])
		if sel_persona.escuela != null_edificio and draw_boton(room_width - 40, pos, "Estudiando en " + edificio_nombre[sel_persona.escuela.tipo]){
			sel_edificio = sel_persona.escuela
			sel_tipo = 0
		}
		else if sel_persona.es_hijo
			draw_text_pos(room_width - 40, pos, "Sin escolarizar")
		if sel_persona.medico != null_edificio{
			draw_text_pos(room_width - 20, pos, "Enferm" + ao(sel_persona))
			if sel_persona.medico = desausiado
				draw_text_pos(room_width - 40, pos, "Sin tratamiento")
			else if draw_boton(room_width - 40, pos, "Tratándose en " + edificio_nombre[sel_persona.medico.tipo]){
				sel_edificio = sel_persona.medico
				sel_tipo = 0
			}
		}
		else
			draw_text_pos(room_width - 20, pos, "San" + ao(sel_persona))
	}
	draw_text(room_width, 0, temp_text)
	draw_set_halign(fa_left)
}
if d3{
	if mouse_x < 20
		xpos = max(-xsize * 16 + room_width - 240, xpos - (1 + 7 * keyboard_check(vk_lshift)))
	if mouse_y < 20
		ypos = max(72, ypos - (1 + 7 * keyboard_check(vk_lshift)))
	if mouse_x > room_width - 20
		xpos = min(xsize * 16 - room_width + 240, xpos + (1 + 7 * keyboard_check(vk_lshift)))
	if mouse_y > room_height - 20
		ypos = min(ysize * 16 - room_height + 72, ypos + (1 + 7 * keyboard_check(vk_lshift)))
}
else{
	if mouse_x < 20
		xpos = max(0, xpos - (1 + 7 * keyboard_check(vk_lshift)))
	if mouse_y < 20
		ypos = max(0, ypos - (1 + 7 * keyboard_check(vk_lshift)))
	if mouse_x > room_width - 20
		xpos = min(xsize * 16 - room_width, xpos + (1 + 7 * keyboard_check(vk_lshift)))
	if mouse_y > room_height - 20
		ypos = min(ysize * 16 - room_height, ypos + (1 + 7 * keyboard_check(vk_lshift)))
}
if keyboard_check(vk_lcontrol) and (keyboard_check_pressed(ord("F")) or (keyboard_check(ord("F")) and keyboard_check(vk_lshift)))
	add_familia()
if keyboard_check(vk_space)
	repeat(1 + 29 * keyboard_check(vk_lshift)){
		dia++
		current_mes = mes(dia)
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
			for(var a = 0; a < array_length(recurso_nombre); a++)
				recurso_precio[a] *= random_range(0.95, 1.05)
			for(var a = 0; a < array_length(edificio_nombre); a++){
				dinero -= edificio_mantenimiento[a] * array_length(edificio_count[a])
				mes_mantenimiento[current_mes] += edificio_mantenimiento[a] * array_length(edificio_count[a])
			}
			if irandom(felicidad_total) > 25 or dia < 365
				add_familia()
		}
		//Ciclo normal de las personas
		for(var a = 0; a < array_length(cumples[dia mod 365]); a++){
			var persona = cumples[dia mod 365, a]
			persona.edad++
			//Enfermar
			if random(1) < 0.2 and persona.medico = null_edificio
				buscar_atencion_medica(persona)
			//Estudiar
			if persona.edad > 4 and persona.edad < 18{
				if persona.escuela = null_edificio
					buscar_escuela(persona)
				else{
					persona.educacion += random(0.3 * array_length(persona.escuela.trabajadores) / edificio_trabajadores_max[persona.escuela.tipo])
					if persona.educacion >= 2{
						persona.educacion = 2
						array_remove(persona.escuela.clientes, persona)
						persona.escuela = null_edificio
					}
					else if random(1) < 0.1{
						array_remove(persona.escuela.clientes, persona)
						buscar_escuela(persona)
					}
				}
			}
			if persona.edad = 18 and persona.escuela != null_edificio{
				array_remove(persona.escuela.clientes, persona)
				persona.escuela = null_edificio
			}
			//Independizarse
			if persona.edad > 18 and (irandom_range(persona.edad, 24) = 24 or persona.edad > 24) and persona.es_hijo{
				if buscar_trabajo(persona) or persona.edad > 24{
					var prev_familia = persona.familia, herencia = 0, b = prev_familia.felicidad_vivienda, c = prev_familia.felicidad_alimento
					array_remove(prev_familia.hijos, persona)
					if prev_familia.padre = null_persona and prev_familia.madre = null_persona and array_length(prev_familia.hijos) = 0{
						if prev_familia.riqueza > 0
							herencia = prev_familia.riqueza
						destroy_familia(prev_familia, true)
					}
					var familia = {
						padre : null_persona,
						madre : null_persona,
						hijos : [null_persona],
						casa : homeless,
						sueldo : 0,
						felicidad_vivienda : b,
						felicidad_alimento : c,
						riqueza : herencia
					}
					array_pop(familia.hijos)
					if persona.sexo
						familia.madre = persona
					else
						familia.padre = persona
					persona.familia = familia
					array_push(familias, familia)
					array_push(homeless.familias, familia)
					persona.es_hijo = false
				}
			}
			else if persona.edad > 24 and persona.edad < 60{
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
						destroy_familia(persona_2.familia)
						persona_2.familia = persona.familia
						if persona.sexo
							persona.familia.padre = persona_2
						else
							persona.familia.madre = persona_2
					}
				}
				//Tener hijos
				else if irandom(3 + 2 * array_length(persona.familia.hijos)) = 0 and persona.familia.madre != null_persona and persona.familia.madre.edad < 40 and persona.familia.madre.embarazo = -1{
					persona.familia.madre.embarazo = (dia + irandom_range(240, 280)) mod 365
					array_push(embarazo[persona.familia.madre.embarazo], persona.familia.madre)
				}
				//Cambiar de trabajo
				if array_length(trabajos) > 0
					buscar_trabajo(persona)
				//Mudarse
				if array_length(casas) > 0
					buscar_casa(persona)
			}
			else if persona.edad > 60{
				//Jubilarse
				if persona.edad >= 65 - 5 * persona.sexo
					cambiar_trabajo(persona, jubilado)
				//Morir
				if irandom(persona.edad) > 60{
					persona.muerte = irandom(364)
					array_push(muerte[persona.muerte], persona)
				}
			}
			//Acudir a edificios de ocio
			var temp_array = array_shuffle(edificios_ocio_index)
			persona.felicidad_ocio = 0
			for(var b = 0; b < array_length(temp_array); b++)
				if array_length(edificio_count[temp_array[b]]) > 0 and (persona.edad > 12 or edificio_nombre[temp_array[b]] != "Taberna") and (array_length(persona.familia.hijos) > 0 or edificio_nombre[temp_array[b]] != "Circo"){
					var ocio = edificio_count[temp_array[b], irandom(array_length(edificio_count[temp_array[b]]) - 1)]
					if ocio.count < edificio_clientes_max[temp_array[b]] and persona.familia.riqueza >= edificio_clientes_tarifa[temp_array[b]]{
						persona.familia.riqueza -= edificio_clientes_tarifa[temp_array[b]]
						dinero += edificio_clientes_tarifa[temp_array[b]]
						mes_tarifas[current_mes] += edificio_clientes_tarifa[temp_array[b]]
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
			//Ir a la iglesia
			if array_length(iglesias) > 0 and (persona.religion or (persona.edad < 12 and random(1) < 0.1)){
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
			//Calculo de felicidad
			felicidad_total = felicidad_total * array_length(personas) - persona.felicidad
			if array_length(medicos) = 1
				persona.felicidad_salud = floor(persona.felicidad_salud / 2)
			else
				persona.felicidad_salud = floor((persona.felicidad_salud + 50) / 2)
			persona.familia.felicidad_vivienda = floor((persona.familia.felicidad_vivienda + edificio_familias_calidad[persona.familia.casa.tipo]) / 2)
			var b = 0
			if persona.es_hijo{
				persona.felicidad_educacion = floor((persona.felicidad_educacion + edificio_clientes_calidad[persona.escuela.tipo]) / 2)
				b = persona.felicidad_educacion
			}
			else{
				persona.felicidad_trabajo = floor((persona.felicidad_trabajo + edificio_trabajo_calidad[persona.trabajo.tipo]) / 2)
				b = persona.felicidad_trabajo
			}
			if persona.religion{
				persona.felicidad_religion = floor(persona.felicidad_religion * 0.9)
				if persona.familia.casa != homeless and (persona.trabajo != null_edificio or persona.escuela != null_edificio)
					persona.felicidad = calcular_felicidad(b, persona.familia.felicidad_vivienda, persona.felicidad_salud, persona.felicidad_ocio, persona.familia.felicidad_alimento, persona.felicidad_transporte, persona.felicidad_religion)
				else
					persona.felicidad = calcular_felicidad(b, persona.familia.felicidad_vivienda, persona.felicidad_salud, persona.felicidad_ocio, persona.familia.felicidad_alimento, persona.felicidad_religion)
			}
			else{
				if persona.familia.casa != homeless and (persona.trabajo != null_edificio or persona.escuela != null_edificio)
					persona.felicidad = calcular_felicidad(b, persona.familia.felicidad_vivienda, persona.felicidad_salud, persona.felicidad_ocio, persona.familia.felicidad_alimento, persona.felicidad_transporte)
				else
					persona.felicidad = calcular_felicidad(b, persona.familia.felicidad_vivienda, persona.felicidad_salud, persona.felicidad_ocio, persona.familia.felicidad_alimento)
			}
			felicidad_total = (felicidad_total + persona.felicidad) / array_length(personas)
			//Emigrar
			if persona.edad > 18 and persona.edad < 60 and irandom(15) > persona.felicidad and persona.familia.riqueza >= 10 * (real(persona.familia.padre != null_persona) + real(persona.familia.madre != null_persona) + array_length(persona.familia.hijos)) and dia > 365{
				var familia = persona.familia
				if familia.padre.felicidad < 15 and familia.madre.felicidad < 15{
					if familia.padre != null_persona{
						destroy_persona(familia.padre, false)
						mes_emigrantes[current_mes]++
					}
					if array_contains(familias, familia) and familia.madre != null_persona{
						destroy_persona(familia.madre, false)
						mes_emigrantes[current_mes]++
					}
					if array_contains(familias, familia)
						for(b = 0; b < array_length(familia.hijos); b++){
							destroy_persona(familia.hijos[b], false)
							mes_emigrantes[current_mes]++
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
		}
		//Muertes
		while array_length(muerte[dia mod 365]) > 0{
			var persona = array_shift(muerte[dia mod 365])
			destroy_persona(persona)
			mes_muertos[current_mes]++
		}
		//Ciclo de los edificio
		for(var a = 0; a < array_length(dia_trabajo[dia mod 28]); a++){
			var edificio = dia_trabajo[dia mod 28, a]
			//Pagar sueldos
			if edificio_es_trabajo[edificio.tipo]{
				dinero -= edificio_trabajo_sueldo[edificio.tipo] * array_length(edificio.trabajadores)
				mes_sueldos[current_mes] += edificio_trabajo_sueldo[edificio.tipo] * array_length(edificio.trabajadores)
				for(var b = 0; b < array_length(edificio.trabajadores); b++)
					edificio.trabajadores[b].familia.riqueza += edificio_trabajo_sueldo[edificio.tipo]
				//Granjas
				if edificio_nombre[edificio.tipo] = "Granja"{
					if current_mes = 5 or current_mes = 10{
						edificio.almacen[recurso_cultivo[edificio.modo]] += round(15 * min(edificio.count, 5 * array_length(edificio.trabajadores)) * edificio.eficiencia)
						edificio.count -= min(edificio.count, 5 * array_length(edificio.trabajadores))
					}
					else
						edificio.count += array_length(edificio.trabajadores)
					if current_mes = 0 or current_mes = 6 and edificio.almacen[recurso_cultivo[edificio.modo]] > 200{
						dinero += floor(recurso_precio[recurso_cultivo[edificio.modo]] * (edificio.almacen[recurso_cultivo[edificio.modo]] - 200))
						mes_exportaciones[current_mes] += floor(recurso_precio[recurso_cultivo[edificio.modo]] * (edificio.almacen[recurso_cultivo[edificio.modo]] - 200))
						edificio.almacen[recurso_cultivo[edificio.modo]] = 200
					}
					
				}
				//Aserradero
				else if edificio_nombre[edificio.tipo] = "Aserradero"{
					//Cortar árboles
					if array_length(edificio.array_real_1) > 0{
						var b = 10 * array_length(edificio.trabajadores)
						while b > 0 and array_length(edificio.array_real_1) > 0{
							if b < bosque_madera[edificio.array_real_1[0], edificio.array_real_2[0]]{
								array_set(bosque_madera[edificio.array_real_1[0]], edificio.array_real_2[0], bosque_madera[edificio.array_real_1[0], edificio.array_real_2[0]] - b)
								b = 0
							}
							else{
								b -= bosque_madera[edificio.array_real_1[0], edificio.array_real_2[0]]
								array_set(bosque_madera[edificio.array_real_1[0]], edificio.array_real_2[0], 0)
								array_set(bosque[edificio.array_real_1[0]], edificio.array_real_2[0], false)
								array_shift(edificio.array_real_1)
								array_shift(edificio.array_real_2)
							}
						}
						edificio.almacen[1] += 10 * array_length(edificio.trabajadores) - b
					}
					if current_mes = 0 or current_mes = 6{
						dinero += floor(recurso_precio[1] * edificio.almacen[1])
						mes_exportaciones[current_mes] += floor(recurso_precio[1] * edificio.almacen[1])
						edificio.almacen[1] = 0
					}
				}
				//Pescadería
				else if edificio_nombre[edificio.tipo] = "Pescadería"{
					edificio.almacen[8] += 10 * array_length(edificio.trabajadores)
					if current_mes = 0 or current_mes = 6{
						dinero += floor(recurso_precio[8] * edificio.almacen[8])
						mes_exportaciones[current_mes] += floor(recurso_precio[8] * edificio.almacen[8])
						edificio.almacen[8] = 0
					}
				}
				//Minas
				else if edificio_nombre[edificio.tipo] = "Mina"{
					var b = 12 * array_length(edificio.trabajadores), e = b
					for(var c = max(0, edificio.x - 1); c < min(xsize - 1, edificio.x + edificio_width[edificio.tipo] + 1); c++){
						for(var d = max(0, edificio.y - 1); d < min(ysize - 1, edificio.y + edificio_height[edificio.tipo] + 1); d++)
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
					if b > 0
						show_debug_message("Mina agotada en " + string(edificio.x) + ", " + string(edificio.y))
					edificio.almacen[recurso_mineral[edificio.modo]] += e - b
					if current_mes = 0 or current_mes = 6{
						dinero += floor(recurso_precio[recurso_mineral[edificio.modo]] * edificio.almacen[recurso_mineral[edificio.modo]])
						mes_exportaciones[current_mes] += floor(recurso_precio[recurso_mineral[edificio.modo]] * edificio.almacen[recurso_mineral[edificio.modo]])
						edificio.almacen[recurso_mineral[edificio.modo]] = 0
					}
				}
			}
			//Casas
			if edificio_es_casa[edificio.tipo]{
				dinero += edificio_familias_renta[edificio.tipo] * array_length(edificio.familias)
				mes_renta[current_mes] += edificio_familias_renta[edificio.tipo] * array_length(edificio.familias)
				//Conseguir alimento
				var flag = false
				if edificio = homeless{
					for(var b = 0; b < array_length(edificio_almacen_index); b++)
						if array_length(edificio_count[edificio_almacen_index[b]]) > 0{
							var tienda = edificio_count[edificio_almacen_index[b]][irandom(array_length(edificio_count[edificio_almacen_index[b]]) - 1)]
							for(var c = 0; c < array_length(recurso_comida); c++){
								var d = recurso_comida[c]
								if edificio != homeless{
									if tienda.almacen[d] >= 10 * edificio_familias_max[edificio.tipo] - edificio.almacen[d]{
										tienda.almacen[d] -= 10 * edificio_familias_max[edificio.tipo] - edificio.almacen[d]
										edificio.almacen[d] = 10 * edificio_familias_max[edificio.tipo]
										flag = true
									}
									else{
										edificio.almacen[d] += tienda.almacen[d]
										tienda.almacen[d] = 0
									}
								}
								else{
									tienda.almacen[d] -= min(tienda.almacen[d], 5 * array_length(edificio.familias) - edificio.almacen[d])
									edificio.almacen[d] += min(tienda.almacen[d], 5 * array_length(edificio.familias) - edificio.almacen[d])
								}
							}
						if flag
							break
						}
				}
				else if array_length(edificio.almacen_cerca) > 0
					for(var b = 0; b < array_length(edificio.almacen_cerca); b++){
						var tienda = edificio.almacen_cerca[b]
						for(var c = 0; c < array_length(recurso_comida); c++){
								var d = recurso_comida[c]
								if edificio != homeless{
									if tienda.almacen[d] >= 10 * edificio_familias_max[edificio.tipo] - edificio.almacen[d]{
										tienda.almacen[d] -= 10 * edificio_familias_max[edificio.tipo] - edificio.almacen[d]
										edificio.almacen[d] = 10 * edificio_familias_max[edificio.tipo]
										flag = true
									}
									else{
										edificio.almacen[d] += tienda.almacen[d]
										tienda.almacen[d] = 0
									}
								}
								else{
									tienda.almacen[d] -= min(tienda.almacen[d], 5 * array_length(edificio.familias) - edificio.almacen[d])
									edificio.almacen[d] += min(tienda.almacen[d], 5 * array_length(edificio.familias) - edificio.almacen[d])
								}
							}
						if flag
							break
				}
				//Contar consumidores
				var c = 0
				for(var b = 0; b < array_length(edificio.familias); b++){
					edificio.familias[b].riqueza -= edificio_familias_renta[edificio.tipo]
					if edificio.familias[b].riqueza <= -30
						cambiar_casa(edificio.familias[b], homeless)
					c += edificio.familias[b].padre != null_persona
					c += edificio.familias[b].madre != null_persona
					c += array_length(edificio.familias[b].hijos)
				}
				//Repartir comida
				var e = 0, temp_total = c
				for(var d = 0; d < array_length(recurso_comida); d++){
					var g = recurso_cultivo[d]
					if edificio.almacen[g] > c{
						edificio.almacen[g] -= c
						e = 100
						break
					}
					else{
						c -= edificio.almacen[g]
						edificio.almacen[g] = 0
						e = 100 * (temp_total - c) / temp_total
					}
				}
				//Actualizar felicidad por alimentación
				for(var b = 0; b < array_length(edificio.familias); b++){
					edificio.familias[b].felicidad_alimento = floor((edificio.familias[b].felicidad_alimento + e) / 2)
					if irandom(10) > edificio.familias[b].felicidad_alimento{
						flag = false
						if edificio.familias[b].padre != null_persona{
							flag = destroy_persona(edificio.familias[b].padre)
							mes_inanicion[current_mes] ++
						}
						if not flag and edificio.familias[b].madre != null_persona{
							flag = destroy_persona(edificio.familias[b].madre)
							mes_inanicion[current_mes]++
						}
						if not flag
							for(c = 0; not flag and c < array_length(edificio.familias[b].hijos); c++)
								if brandom(){
									flag = destroy_persona(edificio.familias[b].hijos[c])
									mes_inanicion[current_mes]++
								}
						if flag
							b--
					}
				}
			}
			//Edificios médicos
			if edificio_es_medico[edificio.tipo]{
				//Curar pacientes
				repeat(min(array_length(edificio.clientes), 2 * array_length(edificio.trabajadores))){
					var persona = array_shift(edificio.clientes)
					persona.felicidad_salud = edificio_clientes_calidad[edificio.tipo]
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
						if persona.familia.padre != null_persona
							persona.familia.padre.felicidad_salud = floor(persona.familia.padre.felicidad_salud / 2)
						if persona.familia.madre != null_persona
							persona.familia.madre.felicidad_salud= floor(persona.familia.madre.felicidad_salud / 2)
						for(var c = 0; c < array_length(persona.familia.hijos); c++)
							persona.familia.hijos[c].felicidad_salud = floor(persona.familia.hijos[c].felicidad_salud / 2)
						if persona.trabajo != null_edificio and persona.trabajo != jubilado
							for(var c = 0; c < array_length(persona.trabajo.trabajadores); c++)
								persona.trabajo.trabajadores[c].felicidad_salud = floor(persona.trabajo.trabajadores[c].felicidad_salud * 0.75)
						if persona.escuela != null_edificio{
							for(var c = 0; c < array_length(persona.escuela.trabajadores); c++)
								persona.escuela.trabajadores[c].felicidad_salud = floor(persona.escuela.trabajadores[c].felicidad_salud * 0.9)
							for(var c = 0; c < array_length(persona.escuela.clientes); c++)
								persona.escuela.clientes[c].felicidad_salud = floor(persona.escuela.clientes[c].felicidad_salud * 0.9)
						}
						destroy_persona(persona)
						mes_enfermos[current_mes]++
						b--
					}
					else if brandom(){
						array_remove(edificio.clientes, persona)
						persona.medico = null_edificio
						b--
					}
				}
			}
			//Edificios de ocio y religiosos
			if edificio_es_ocio[edificio.tipo] or edificio_es_iglesia[edificio.tipo]
				edificio.count = max(0, floor(edificio.count * (1 - array_length(edificio.trabajadores) / edificio_trabajadores_max[edificio.tipo])))
		}
		if not deuda and dinero < 0{
			deuda = true
			deuda_dia = dia
			show_message("Te has quedado sin dinero, tienes un año para pagar tu deuda externa")
		}
		if deuda and dinero > 0
			deuda = false
		if deuda and dia = deuda_dia + 365{
			show_message("HAS PERDIDO\n\nNo has sido capaz de pagar tu deuda externa a tiempo")
			if show_question("¿Volver a jugar?")
				game_restart()
			else
				game_end()
		}
	}
if keyboard_check_pressed(ord("R")) and keyboard_check(vk_lcontrol)
	game_restart()
if keyboard_check_pressed(vk_escape)
	game_end()
if string_ends_with(keyboard_string, "felicidad"){
	keyboard_string = ""
	var temp_text = "Felicidad " + string(floor(felicidad_total)) + " día " + fecha(dia) + "\n"
	var fel_tra = 0, fel_edu = 0, fel_viv = 0, fel_sal = 0, num_tra = 0, num_edu = 0, b = 0, fel_oci = 0, fel_ali = 0, c = 0, fel_tran = 0, num_tran = 0, fel_rel = 0, num_rel = 0
	for(var a = 0; a < array_length(personas); a++){
		fel_sal += personas[a].felicidad_salud
		fel_viv += personas[a].familia.felicidad_vivienda
		fel_ali += personas[a].familia.felicidad_alimento
		fel_oci += personas[a].felicidad_ocio
		if personas[a].familia.casa != homeless and (personas[a].trabajo != null_edificio or personas[a].escuela != null_edificio){
			fel_tran += personas[a].felicidad_transporte
			num_tran++
		}
		if personas[a].es_hijo{
			fel_edu += personas[a].felicidad_educacion
			num_edu++
		}
		else{
			fel_tra += personas[a].felicidad_trabajo
			num_tra++
		}
		if personas[a].religion{
			fel_rel += personas[a].felicidad_religion
			num_rel++
		}
	}
	for(var a = 0; a < 12; a++){
		b += mes_emigrantes[a]
		c += mes_inmigrantes[a]
	}
	show_debug_message(temp_text + "  Trabajo: " + string(floor(fel_tra / num_tra)) +
		"\n  Educación: " + string(floor(fel_edu / num_edu)) +
		"\n  Vivienda: " + string(floor(fel_viv / array_length(personas))) +
		"\n  Salud: " + string(floor(fel_sal / array_length(personas))) +
		"\n  Entretenimiento: " + string(floor(fel_oci / array_length(personas))) +
		"\n  Alimentación: " + string(floor(fel_ali / array_length(personas))) +
		"\n  Transporte: " + string(floor(fel_tran / num_tran)) +
		"\n  Religión: " + string(floor(fel_rel / num_rel)) +
		"\n  " + string(b) + " personas han emigrado el último año" +
		"\n  " + string(c) + " personas han inmigrado el último año")
}
if string_ends_with(keyboard_string, "educacion"){
	keyboard_string = ""
	var temp_educacion = [0, 0, 0, 0, 0]
	for(var a = 0; a < array_length(personas); a++)
		temp_educacion[floor(personas[a].educacion)]++
	var temp_text = "Educación día " + fecha(dia) + "\n"
	for(var a = 0; a < 5; a++)
		temp_text += educacion_nombre[a] + ": " + string(temp_educacion[a]) + " (" + string(temp_educacion[a] * 100 / array_length(personas)) + "%)\n"
	show_debug_message(temp_text)
}
if string_ends_with(keyboard_string, "salud"){
	keyboard_string = ""
	var temp_espera = 0, temp_enfermos = 0, b = 0, c = 0
	for(var a = 0; a < array_length(personas); a++)
		if personas[a].medico != null_edificio{
			temp_enfermos++
			if personas[a].medico != desausiado
				temp_espera++
		}
	for(var a = 0; a < 12; a++){
		b += mes_enfermos[a]
		c += mes_nacimientos[a]
	}
	show_debug_message("Salud día " + fecha(dia) +
		"\n  Enfermos: " + string(temp_enfermos) +
		"\n  En lista de espera: " + string(temp_espera) +
		"\n  Sin atención médica: " + string(array_length(desausiado.clientes)) +
		"\n  " + string(b) + " personas han muerto el último año" +
		"\n  " + string(c) + " personas han nacido el último año")
}
if string_ends_with(keyboard_string, "vivienda"){
	keyboard_string = ""
	var temp_array, temp_text = "Vivienda día " + fecha(dia) + "\n"
	for(var a = 0; a < array_length(edificio_nombre); a++)
		temp_array[a] = 0
	for(var a = 0; a < array_length(personas); a++)
		temp_array[personas[a].familia.casa.tipo]++
	for(var a = 0; a < array_length(edificio_nombre); a++)
		if edificio_es_casa[a]
			temp_text += "  " + edificio_nombre[a] + ": " + string(temp_array[a]) + " (" + string(floor(temp_array[a] * 100 / array_length(personas))) + "%)\n"
	show_debug_message(temp_text)
}
if string_ends_with(keyboard_string, "poblacion"){
	keyboard_string = ""
	var temp_array= [0, 0, 0, 0], b = 0, c = 0, desempleados = 0, empleados = 0, d = 0, e = 0
	for(var a = 0; a < array_length(personas); a++){
		if personas[a].edad < 18
			temp_array[0]++
		else if personas[a].edad < 40
			temp_array[1]++
		else if personas[a].edad < 60
			temp_array[2]++
		else
			temp_array[3]++
		if not personas[a].es_hijo{
			empleados++
			if personas[a].trabajo = null_edificio
				desempleados++
		}
	}
	for(var a = 0; a < array_length(familias); a++){
		b += familias[a].riqueza
		c += edificio_trabajo_sueldo[familias[a].padre.trabajo.tipo] + edificio_trabajo_sueldo[familias[a].madre.trabajo.tipo] + edificio_familias_renta[familias[a].casa.tipo]
	}
	for(var a = 0; a < 12; a++){
		d += mes_muertos[a]
		e += mes_inanicion[a]
	}
	show_debug_message("Población día " + fecha(dia) +
		"\n  0 - 17: " + string(temp_array[0]) + " (" + string(floor(temp_array[0] * 100 / array_length(personas))) + "%)" +
		"\n  18 - 39: " + string(temp_array[1]) + " (" + string(floor(temp_array[1] * 100 / array_length(personas))) + "%)" +
		"\n  40 - 59: " + string(temp_array[2]) + " (" + string(floor(temp_array[2] * 100 / array_length(personas))) + "%)" +
		"\n  60 - ..: " + string(temp_array[3]) + " (" + string(floor(temp_array[3] * 100 / array_length(personas))) + "%)" +
		"\n  Renta promedio: $" + string(c / array_length(familias)) +
		"\n  Riqueza promedio: $" + string(b / array_length(familias)) +
		"\n  Desempleo : " + string(floor(desempleados * 100 /  empleados)) + "%" +
		"\n  " + string(d) + " personas han muerto de causas naturales este año" + 
		"\n  " + string(e) + " personas han muerto de hambre este año")
}
//Economía
if string_ends_with(keyboard_string, "economia"){
	keyboard_string = ""
	var b = 0, c = 0, d = 0, e = 0, f = 0, g = 0, h = 0
	for(var a = 0; a < 12; a++){
		b += mes_renta[a]
		c += mes_tarifas[a]
		d += mes_exportaciones[a]
		e += mes_herencia[a]
		f += mes_sueldos[a]
		g += mes_mantenimiento[a]
		h += mes_construccion[a]
	}
	show_debug_message("Economía día " + fecha(dia) +
		"\nIngresos: $" + string(b + c + d + e) +
		(b != 0) * ("\n  Renta: $" + string(b)) +
		(c != 0) * ("\n  Tarifa servicios: $" + string(c)) +
		(d != 0) * ("\n  Exportaciones: $" + string(d)) +
		(e != 0) * ("\n  Herencia: $" + string(e)) +
		"\nGastos: $" + string(f + g + h) +
		(f != 0) * ("\n  Sueldos: $" + string(f)) +
		(g != 0) * ("\n  Mantenimiento: $" + string(g)) +
		(h != 0) * ("\n  Construcción: $" + string(h)))
}
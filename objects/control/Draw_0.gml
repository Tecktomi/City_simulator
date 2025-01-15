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
//Información general
draw_set_alpha(0.5)
draw_set_color(c_ltgray)
draw_rectangle(0, room_height, string_width("FPS: " + string(fps) + "\n" + fecha(dia) + "\n" + string(array_length(personas)) + " habitantes\n$" + string(dinero)), room_height - string_height("FPS: " + string(fps) + "\n" + fecha(dia) + "\n" + string(array_length(personas)) + " habitantes\n$" + string(dinero)), false)
draw_set_color(c_black)
draw_set_valign(fa_bottom)
pos = room_height
draw_text_pos(0, pos, "FPS: " + string(fps) + "\n" + fecha(dia) + "\n" + string(array_length(personas)) + " habitantes\n$" + string(dinero))
for(var a = 0; a < array_length(exigencia_nombre); a++)
	if exigencia_pedida[a]
		draw_text_pos(0, pos, exigencia_nombre[a] + " " + string(exigencia[a].expiracion - dia) + " días restantes")
draw_set_valign(fa_top)
draw_set_alpha(1)
//Dibujar contornos de edificios
for(var a = 0; a < array_length(edificios); a++){
	var edificio = edificios[a], b = edificio.x, c = edificio.y
	draw_set_color(make_color_hsv(edificio_color[edificio.tipo], 255, 255))
	draw_rectangle(b * 16 - xpos, c * 16 - ypos, (b + edificio_width[edificio.tipo]) * 16 - 1 - xpos, (c + edificio_height[edificio.tipo]) * 16 - 1 - ypos, false)
	draw_set_color(c_white)
	draw_rectangle(b * 16 - xpos, c * 16 - ypos, (b + edificio_width[edificio.tipo]) * 16 - 1 - xpos, (c + edificio_height[edificio.tipo]) * 16 - 1 - ypos, true)
	if edificio.paro{
		draw_set_color(c_white)
		draw_rectangle(b * 16 - xpos, c * 16 - ypos, b * 16 - xpos + string_width("PARO"), c * 16 - ypos + string_height("PARO"), false)
		draw_set_color(c_red)
		draw_text(b * 16 - xpos, c * 16 - ypos, "PARO")
	}
}
//Abrir menú de construcción
if mouse_check_button_pressed(mb_right) and not build_sel{
	sel_build = not sel_build
	sel_info = false
	build_type = 0
	ministerio = -1
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
		}
		b += last_width + 10
	}
	pos = 100
	//Menú de construcción
	if ministerio = -1{
		for(var a = 0; a < array_length(edificio_categoria[build_categoria]); a++)
			if draw_boton(110, pos, edificio_nombre[edificio_categoria[build_categoria, a]] + " $" + string(edificio_precio[edificio_categoria[build_categoria, a]])) and dinero + 2500 >= edificio_precio[edificio_categoria[build_categoria, a]]{
				build_index = edificio_categoria[build_categoria, a]
				build_sel = true
				sel_build = false
			} 
	}
	//Ministerios
	else{
		draw_text_pos(100, pos, "Ministerio de " + ministerio_nombre[ministerio])
		pos += 20
		//Ministerio de población
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
			draw_text_pos(110, pos, "Población: " + string(array_length(personas)))
			if temp_total >= 0
				var temp_text = "Crecimiento "
			else
				temp_text = "Disminución "
			if draw_menu(120, pos, temp_text + string(abs(temp_total)), 1){
				draw_set_color(c_green)
				draw_text_pos(130, pos, "Nacimientos: " + string(temp_nacimientos))
				draw_text_pos(130, pos, "Inmigración: " + string(temp_inmigrados))
				draw_set_color(c_red)
				if draw_menu(130, pos, "Muertos: " + string(temp_muertos + temp_inanicion + temp_enfermos), 2,,false){
					draw_text_pos(140, pos, "Causas naturales: " + string(temp_muertos))
					draw_text_pos(140, pos, "Inanición: " + string(temp_inanicion))
					if draw_boton(140, pos, "Enfermedades: " + string(temp_enfermos))
						ministerio = 3
				}
				draw_text_pos(130, pos, "Emigración: " + string(temp_emigrados))
				draw_set_color(c_black)
			}
			//Gráfico de edades
			if draw_menu(120, pos, "Edad", 0){
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
					draw_rectangle(400, 300 - a * 10, 400 - 100 * temp_edad[true, a] / maxi, 309 - a * 10, false)
					draw_set_color(c_aqua)
					draw_rectangle(440, 300 - a * 10, 440 + 100 * temp_edad[false, a] / maxi, 309 - a * 10, false)
					draw_set_color(c_black)
					draw_text(420, 300 - a * 10, string(a * 5) + "-" + string(a * 5 + 4))
				}
				draw_set_halign(fa_left)
				draw_set_font(Font1)
			}
			//Felicidad
			if draw_menu(120, pos, "Felicidad: " + string(floor(felicidad_total)), 3){
				var fel_tra = 0, fel_edu = 0, fel_viv = 0, fel_sal = 0, num_tra = 0, num_edu = 0, fel_oci = 0, fel_ali = 0, c = 0, fel_tran = 0, num_tran = 0, fel_rel = 0, num_rel = 0, fel_ley = 0, len = array_length(personas)
				b = 0
				for(var a = 0; a < array_length(personas); a++){
					fel_sal += personas[a].felicidad_salud
					fel_viv += personas[a].familia.felicidad_vivienda
					fel_ali += personas[a].familia.felicidad_alimento
					fel_oci += personas[a].felicidad_ocio
					fel_ley += personas[a].felicidad_ley
					if personas[a].familia.casa != homeless and (personas[a].trabajo != null_edificio or personas[a].escuela != null_edificio){
						fel_tran += personas[a].felicidad_transporte
						num_tran++
					}
					if personas[a].es_hijo{
						fel_edu += personas[a].felicidad_educacion
						num_edu++
					}
					if not personas[a].es_hijo or (ley_eneabled[2] and personas[a].trabajo != null_edificio){
						fel_tra += personas[a].felicidad_trabajo
						num_tra++
					}
					if personas[a].religion{
						fel_rel += personas[a].felicidad_religion
						num_rel++
					}
				}
				if draw_boton(130, pos, "Vivienda: " + string(floor(fel_viv / len)))
					ministerio = 1
				if draw_boton(130, pos, "Trabajo: " + string(floor(fel_tra / num_tra)))
					ministerio = 2
				if draw_boton(130, pos, "Salud: " + string(floor(fel_sal / len)))
					ministerio = 3
				if draw_boton(130, pos, "Educación: " + string(floor(fel_edu / num_edu)))
					ministerio = 4
				draw_text_pos(130, pos, "Alimentación: " + string(floor(fel_ali / len)))
				draw_text_pos(130, pos, "Entretenimiento: " + string(floor(fel_oci / len)))
				draw_text_pos(130, pos, "Transporte: " + string(floor(fel_tran / num_tran)))
				draw_text_pos(130, pos, "Religión: " + string(floor(fel_rel / num_rel)))
				draw_text_pos(130, pos, "Legislación: " + string(floor(fel_ley / len)))
			}
		
		}
		//Ministerio de Vivienda
		else if ministerio = 1{
			var temp_array, fel_viv = 0
			for(var a = 0; a < array_length(edificio_nombre); a++)
				temp_array[a] = 0
			for(var a = 0; a < array_length(personas); a++){
				fel_viv += personas[a].familia.felicidad_vivienda
				temp_array[personas[a].familia.casa.tipo]++
			}
			draw_text_pos(110, pos, "Felicidad vivenda: " + string(floor(fel_viv / array_length(personas))))
			for(var a = 0; a < array_length(edificio_nombre); a++)
				if edificio_es_casa[a] and (edificio_nombre[a] = "Homeless" or array_length(edificio_count[a]) > 0)
					if draw_menu(110, pos, edificio_nombre[a] + ": " + string(temp_array[a]) + " habitantes (" + string(floor(temp_array[a] * 100 / array_length(personas))) + "%)", a)
						for(b = 0; b < array_length(edificio_count[a]); b++)
							if draw_boton(120, pos, edificio_nombre[a] + " " + string(b + 1) + " (espacio para " + string(edificio_familias_max[a] - array_length(edificio_count[a, b].familias)) + " familias)"){
								sel_build = false
								sel_info = true
								sel_tipo = 0
								sel_edificio = edificio_count[a, b]
							}
		}
		//Ministerio de Trabajo
		else if ministerio = 2{
			var fel_tra= 0, num_tra = 0, temp_array, num_des = 0
			for(var a = 0; a < array_length(edificio_nombre); a++)
				temp_array[a] = 0
			for(var a = 0; a < array_length(personas); a++)
				if not personas[a].es_hijo{
					fel_tra += personas[a].felicidad_trabajo
					num_tra++
					temp_array[personas[a].trabajo.tipo]++
					num_des += (personas[a].trabajo = null_edificio)
				}
			var vacantes = 0
			for(var a = 0; a < array_length(edificio_nombre); a++)
				if edificio_es_trabajo[a]{
					vacantes += edificio_trabajadores_max[a] * array_length(edificio_count[a])
					for(b = 0; b < array_length(edificio_count[a]); b++)
						vacantes -= array_length(edificio_count[a, b].trabajadores)
				}
			draw_text_pos(110, pos, "Felicidad laboral: " + string(floor(fel_tra / num_tra)))
			draw_text_pos(110, pos, "Desempleo: " + string(floor(100 * num_des / num_tra)) + "%")
			draw_text_pos(110, pos, string(vacantes) + " puestos de trabajo disponibles")
			for(var a = 0; a < array_length(edificio_nombre); a++)
				if edificio_es_trabajo[a] and (edificio_nombre[a] = "Desempleado" or array_length(edificio_count[a]) > 0)
					if draw_menu(120, pos, edificio_nombre[a] + ": " + string(temp_array[a]) + " trabajadores", a)
						for(b = 0; b < array_length(edificio_count[a]); b++)
							if draw_boton(120, pos, edificio_nombre[a] +" " + string(b + 1)){
								sel_build = false
								sel_info = true
								sel_tipo = 0
								sel_edificio = edificio_count[a, b]
							}
			
		}
		//Ministerio de Salud
		else if ministerio = 3{
			var fel_sal = 0, temp_enfermos = 0, num_sal = 0, temp_espera = 0, num_hambre = 0
			for(var a = 0; a < array_length(personas); a++){
				fel_sal += personas[a].felicidad_salud
				if personas[a].medico != null_edificio{
					num_sal++
					if personas[a].medico != desausiado
						temp_espera++
				}
			}
			draw_text_pos(110, pos, "Satisfación sanitaria: " + string(floor(fel_sal / array_length(personas))))
			for(var a = 0; a < 12; a++)
				temp_enfermos += mes_enfermos[a]
			draw_text_pos(110, pos, string(temp_enfermos) + " muertes por enfermedad el último año")
			draw_text_pos(110, pos, string(num_sal) + " personas enfermas")
			draw_text_pos(120, pos, string(array_length(desausiado.clientes)) + " personas sin atención médica")
			draw_text_pos(120, pos, string(temp_espera) + " personas atendidas")
			if draw_menu(110, pos, string(array_length(medicos) - 1) + " edificios médicos", 0)
				for(var a = 0; a < array_length(edificio_nombre); a++)
					if edificio_es_medico[a]
						for(b = 0; b < array_length(edificio_count[a]); b++)
							if draw_boton(120, pos, edificio_nombre[a] + string(b + 1) + " (" + string(array_length(edificio_count[a, b].clientes)) + " clientes)"){
								sel_build = false
								sel_info = true
								sel_tipo = 0
								sel_edificio = edificio_count[a, b]
							}
			for(var a = 0; a < array_length(familias); a++)
				num_hambre += (familias[a].felicidad_alimento < 10) * (real(familias[a].padre != null_persona) + real(familias[a].madre != null_persona) + array_length(familias[a].hijos))
			draw_text_pos(110, pos, string(num_hambre) + " personas hambrietas")
		}
		//Ministerio de educación
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
			draw_text_pos(110, pos, "Satisfacción educacional: " + string(floor(fel_edu / num_edu)))
			for(var a = 0; a < array_length(educacion_nombre); a++)
				draw_text_pos(120, pos, educacion_nombre[a] + ": " + string(temp_educacion[a]) + " (" + string(floor(temp_educacion[a] * 100 / array_length(personas))) + "%)")
			if draw_menu(110, pos, string(array_length(escuelas)) + " instituciones educativas", 0)
				for(var a = 0; a < array_length(edificio_nombre); a++)
					if edificio_es_escuela[a]
						for(b = 0; b < array_length(edificio_count[a]); b++)
							if draw_boton(120, pos, edificio_nombre[a] + " " + string(b + 1) + " (" + string(array_length(edificio_count[a, b].clientes)) + " estudiantes)"){
								sel_build = false
								sel_info = true
								sel_tipo = 0
								sel_edificio = edificio_count[a, b]
							}
		}
		//Ministerio de economía
		else if ministerio = 5{
			var temp_array, temp_grid, temp_text_array, count, maxi
			temp_grid[0] = mes_renta
			temp_grid[1] = mes_tarifas
			temp_grid[2] = mes_exportaciones
			temp_grid[3] = mes_herencia
			temp_grid[4] = mes_sueldos
			temp_grid[5] = mes_mantenimiento
			temp_grid[6] = mes_construccion
			temp_grid[7] = mes_importaciones
			temp_text_array[0] = "Renta"
			temp_text_array[1] = "Tarifas"
			temp_text_array[2] = "Exportaciones"
			temp_text_array[3] = "Herencia"
			temp_text_array[4] = "Sueldos"
			temp_text_array[5] = "Mantenimiento"
			temp_text_array[6] = "Construcción"
			temp_text_array[7] = "Importaciones"
			for(var a = 0; a < 8; a++){
				count[a] = 0
				maxi[a] = 0
			}
			for(var a = 0; a < 12; a++)
				for(b = 0; b < 8; b++){
					count[b] += temp_grid[b, (a + current_mes) mod 12]
					maxi[b] = max(maxi[b], temp_grid[b, a])
				}
			draw_text_pos(110, pos, "Ingresos: $" + string(count[0] + count[1] + count[2] + count[3]))
			for(b = 0; b < 4; b++)
				draw_menu(120, pos, temp_text_array[b] + ": $" + string(count[b]), b, , false)
			draw_text_pos(110, pos, "Pérdidas: $" + string(count[4] + count[5] + count[6]))
			for(b = 4; b < 8; b++)
				draw_menu(120, pos, temp_text_array[b] + ": $" + string(count[b]), b, , false)
			draw_line(400, 300, 500, 300)
			draw_line(400, 300, 400, 200)
			pos = 300
			for(b = 0; b < 8; b++)
				if show[b]{
					draw_set_color(make_color_hsv(b * 15, 255, 255))
					draw_text_pos(400, pos, temp_text_array[b])
					for(var a = 0; a < 11; a++)
						draw_line(400 + a * 10, 300 - 100 * temp_grid[b, a] / maxi[b], 400 + (a + 1) * 10, 300 - 100 * temp_grid[b, a + 1] / maxi[b])
					}
			pos = 100
			draw_set_color(c_black)
			draw_text_pos(500, pos, "Mercado internacional")
			var max_width = 0
			pos = 120
			draw_text_pos(510, pos, "Exportar")
			for(var a = 0; a < array_length(recurso_nombre); a++){
				if draw_boton(540, pos, recurso_nombre[a])
					recurso_exportado[a] = not recurso_exportado[a]
				draw_rectangle(522, pos - last_height + 2, 518 + last_height, pos - 2, not recurso_exportado[a])
				max_width = max(max_width, last_width)
			}
			pos = 120
			draw_text_pos(560 + max_width, pos, "Importar")
			for(var a = 0; a < array_length(recurso_nombre); a++)
				if draw_boton(570 + max_width, pos, recurso_nombre[a] + ": " + string(recurso_importado[a]))
					recurso_importado[a] += 100
		}
		//Leyes
		else  if ministerio = 6{
			for(var a = 0; a < array_length(ley_nombre); a++)
				if draw_boton(110, pos, ley_nombre[a] + ": " + string(ley_eneabled[a])){
					ley_eneabled[a] = not ley_eneabled[a]
					//Permitir divorcios
					if a = 0 and ley_eneabled[0]
						for(var b = 0; b < array_length(personas); b++)
							if personas[b].religion
								add_felicidad_ley(personas[b], -10)
					//Prohibir divorcios
					if a = 0 and not ley_eneabled[0]
						for(var b = 0; b < array_length(personas); b++)
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
				}
		}
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
	//Capilla
	else if in(build_index, 16, 17, 18, 19){
		pos = 0
		for(var a = 16; a < 20; a++){
			var b = 0
			if a = build_index{
				draw_text(0, pos, ">")
				b = 20
			}
			draw_text_pos(b, pos, edificio_nombre[a])
		}
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
//Almanaque
if sel_info{
	draw_set_color(c_ltgray)
	draw_rectangle(room_width, 0, room_width - 300, room_height, false)
	draw_set_color(c_black)
	draw_set_halign(fa_right)
	pos = 0
	//Información edificios
	if sel_tipo = 0 and sel_edificio != null_edificio{
		draw_text_pos(room_width, pos, edificio_nombre[sel_edificio.tipo])
		//Paro
		if sel_edificio.paro{
			draw_text_pos(room_width - 20, pos, "Edificio en paro")
			if sel_edificio.exigencia_fallida
				var a = 240 * array_length(sel_edificio.trabajadores)
			else
				a = 60 * array_length(sel_edificio.trabajadores)
			if draw_boton(room_width - 40, pos, "Sobornar huelga $" + string(a)) and dinero >= a{
				dinero -= a
				sel_edificio.paro = false
			}
			if draw_boton(room_width - 40, pos, exigencia_nombre[sel_edificio.paro_motivo]) and show_question("Aceptar exigencia?\n\n" + exigencia_nombre[sel_edificio.paro_motivo]){
				var array_edificio = [], b = sel_edificio.paro_motivo
				for(a = 0; a < array_length(edificios); a++)
					if edificios[a].paro
						if edificios[a].paro_motivo = b{
							array_push(array_edificio, edificios[a])
							edificios[a].paro = false
						}
				var temp_exigencia = add_exigencia(b, array_edificio)
				for(a = 0; a < array_length(temp_exigencia.edificios); a++)
					temp_exigencia.edificios[a].exigencia = temp_exigencia
			}
			draw_set_alpha(0.5)
		}
		//Exigencia pendiente
		else if sel_edificio.exigencia != null_exigencia
			draw_text_pos(room_width - 20, pos, "Esperando que cumplas " + exigencia_nombre[sel_edificio.paro_motivo])
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
				if draw_boton(room_width - 20, pos, "Cambiar recurso", , not sel_edificio.paro)
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
				if draw_boton(room_width - 20, pos, "Cambiar recurso", , not sel_edificio.paro)
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
		if draw_menu(room_width - 20, pos, string(array_length(sel_edificio.edificios_cerca)) + " edificios cerca", 0)
			for(var a = 0; a < array_length(sel_edificio.edificios_cerca); a++){
				var temp_edificio = sel_edificio.edificios_cerca[a]
				if draw_boton(room_width - 40, pos, edificio_nombre[temp_edificio.tipo]){
					sel_edificio = temp_edificio
					break
				}
			}
		//Destruir edificio
		pos += 40
		if draw_boton(room_width, pos, "Destruir Edificio", , not sel_edificio.paro) and (sel_edificio.tipo != 13 or array_length(edificio_count[13]) > 0){
			destroy_edificio(sel_edificio)
			sel_info = false
		}
		draw_set_alpha(1)
	}
	//Información familias
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
	//Información personas
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
		function draw_relacion(xx, yy, relacion = null_relacion, iter = 0){
			if iter = 5
				return
			draw_sprite(spr_icono, relacion.sexo, xx, yy)
			if not relacion.vivo
				draw_set_color(c_black)
			else
				if relacion.sexo
					draw_set_color(c_fuchsia)
				else
					draw_set_color(c_aqua)
			draw_circle(xx, yy, 8, false)
			draw_set_color(c_black)
			if mouse_x > xx - 10 and mouse_y > yy - 10 and mouse_x < xx + 10 and mouse_y < yy + 10{
				draw_text(mouse_x, mouse_y, relacion.nombre)
				window_set_cursor(cr_handpoint)
				if mouse_check_button_pressed(mb_left){
					mouse_clear(mb_left)
					if relacion.vivo
						sel_persona = relacion.persona
				}
			}
			if relacion.padre != null_relacion
				draw_relacion(xx - 15 * (4 - iter), yy - 30, relacion.padre, iter + 1)
			if relacion.madre != null_relacion
				draw_relacion(xx + 15 * (4 - iter), yy - 30, relacion.madre, iter + 1)
		}
		draw_relacion(room_width - 150, room_height - 50, sel_persona.relacion)
	}
	draw_set_halign(fa_left)
}
//Movimiento de la cámara
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
//Pasar día
if keyboard_check(vk_space)
	repeat(1 + 29 * keyboard_check(vk_lshift)){
		dia++
		current_mes = mes(dia)
		for(var a = 0; a < array_length(exigencia_nombre); a++)
			if exigencia_pedida[a] and dia = exigencia[a].expiracion{
				var temp_exigencia = exigencia[a]
				show_debug_message("Has fallado en " + exigencia_nombre[temp_exigencia.index])
				for(var b = 0; b < array_length(temp_exigencia.edificios); b++){
					var edificio = temp_exigencia.edificios[b]
					edificio.paro = true
					edificio.paro_tiempo = 24 + 6 * array_length(temp_exigencia.edificios)
					edificio.paro_motivo = exigencia_siguiente[edificio.paro_motivo]
					edificio.exigencia = null_exigencia
					edificio.exigencia_fallida = true
				}
				exigencia_pedida[a] = false
				exigencia[a] = null_exigencia
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
			mes_exportaciones[current_mes] = 0
			for(var a = 0; a < array_length(recurso_nombre); a++)
				recurso_precio[a] *= random_range(0.95, 1.05)
			for(var a = 0; a < array_length(edificio_nombre); a++){
				dinero -= edificio_mantenimiento[a] * array_length(edificio_count[a])
				mes_mantenimiento[current_mes] += edificio_mantenimiento[a] * array_length(edificio_count[a])
			}
			if ley_eneabled[1] and irandom(felicidad_total) > 25 or dia < 365
				add_familia()
			for(var a = 0; a < array_length(exigencia_nombre); a++)
				if exigencia_cumplida[a]{
					exigencia_cumplida_time[a]--
					if exigencia_cumplida_time[a] = 0
						exigencia_cumplida[a] = false
				}
			//Reducir la inanición
			if exigencia_pedida[2]{
				var b = 0
				for(var a = current_mes + 9; a < current_mes + 12; a++)
					b += mes_inanicion[a mod 12]
				if b = 0
					cumplir_exigencia(2)
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
					persona.educacion += random(edificio_clientes_calidad[persona.escuela.tipo] * array_length(persona.escuela.trabajadores) / edificio_trabajadores_max[persona.escuela.tipo])
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
			if persona.edad = 18 and persona.escuela != null_edificio{
				array_remove(persona.escuela.clientes, persona)
				persona.escuela = null_edificio
			}
			//Trabajo infantil :D
			if ley_eneabled[2] and persona.es_hijo and persona.edad > 12
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
			//Independizarse
			if persona.edad > 18 and (irandom_range(persona.edad, 24) = 24 or persona.edad > 24) and persona.es_hijo{
				buscar_trabajo(persona)
				if persona.trabajo != null_edificio or persona.edad > 24{
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
						riqueza : herencia,
						integrantes : 1
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
			//Adultez
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
				//Divorcio
				else if ley_eneabled[0] and random(1) < 0.01{
					var persona_2 = persona.pareja, old_familia = persona.familia, familia = {
						padre : null_persona,
						madre : null_persona,
						hijos : [null_persona],
						casa : homeless,
						sueldo : 0,
						felicidad_vivienda : old_familia.felicidad_vivienda,
						felicidad_alimento : old_familia.felicidad_alimento,
						riqueza : floor(old_familia.riqueza / 2),
						integrantes : 1
					}
					array_pop(familia.hijos)
					array_push(familias, familia)
					array_push(homeless.familias, familia)
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
				buscar_trabajo(persona)
				buscar_casa(persona)
			}
			//Vejez
			else if persona.edad > 60{
				//Jubilarse
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
				persona.felicidad_salud = floor((persona.felicidad_salud + 3 * 50) / 4)
			persona.familia.felicidad_vivienda = floor((persona.familia.felicidad_vivienda + 3 * edificio_familias_calidad[persona.familia.casa.tipo]) / 4)
			temp_array = [persona.felicidad_salud, persona.familia.felicidad_vivienda, persona.felicidad_ocio, persona.familia.felicidad_alimento, persona.felicidad_ley]
			if persona.es_hijo{
				persona.felicidad_educacion = floor((persona.felicidad_educacion + 3 * edificio_clientes_calidad[persona.escuela.tipo]) / 4)
				array_push(temp_array, persona.felicidad_educacion)
			}
			if persona.trabajo != null_edificio{
				var b = 1 + real(persona.es_hijo and ley_eneabled[2])
				persona.felicidad_trabajo = floor((persona.felicidad_trabajo + 3 * (edificio_trabajo_calidad[persona.trabajo.tipo] / (b + persona.trabajo.paro))) / 4)
				array_push(temp_array, persona.felicidad_trabajo)
			}
			if persona.religion{
				persona.felicidad_religion = floor(persona.felicidad_religion * 0.9)
				array_push(temp_array, persona.felicidad_religion)
			}
			if persona.familia.casa != homeless and (persona.trabajo != null_edificio or persona.escuela != null_edificio)
				array_push(temp_array, persona.felicidad_transporte)
			persona.felicidad = calcular_felicidad(temp_array)
			felicidad_total = (felicidad_total + persona.felicidad) / array_length(personas)
			//Descontento
			if persona.edad > 18 and persona.edad < 60 and irandom(20) >= persona.felicidad + 5 * (persona.nacionalidad = 0) and dia > 365{
				//Emigrar
				if ley_eneabled[5] and persona.familia.riqueza >= 10 * real(persona.familia.integrantes) and brandom(){
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
							for(var b = 0; b < array_length(familia.hijos); b++){
								destroy_persona(familia.hijos[b], false)
								mes_emigrantes[current_mes]++
							}
					}
				}
				//Protestas
				else if persona.trabajo != null_edificio and not persona.trabajo.paro and persona.trabajo.exigencia = null_exigencia{
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
							add_paro(2, edificio)
						else if not exigencia_cumplida[6]
							add_paro(6, edificio)
					}
					//Exigencia de salud
					else if fel_sal / array_length(edificio.trabajadores) < 30{
						if not exigencia_cumplida[0] and (not edificio.exigencia_fallida or exigencia_cumplida[5])
							add_paro(0, edificio)
						else if not exigencia_cumplida[5]
							add_paro(5, edificio)
					}
					//Exigencia de educación
					else if fel_edu / num_edu < 25 and brandom() and not exigencia_cumplida[1]
						add_paro(1, edificio)
					//Exigencia de diversión
					else if fel_div / array_length(edificio.trabajadores) < 25 and brandom() and not exigencia_cumplida[3]
						add_paro(3, edificio)
					//Exigencia de religión
					else if fel_rel / array_length(edificio.trabajadores) < 30 and not exigencia_cumplida[4]
						add_paro(4, edificio)
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
			destroy_persona(persona)
			mes_muertos[current_mes]++
		}
		//Ciclo de los edificios
		for(var a = 0; a < array_length(dia_trabajo[dia mod 28]); a++){
			var edificio = dia_trabajo[dia mod 28, a]
			//Edificios de trabajo
			if edificio_es_trabajo[edificio.tipo]{
				if edificio.paro{
					edificio.paro_tiempo--
					if edificio.paro_tiempo = 0
						edificio.paro = false
					if edificio_nombre[edificio.tipo] = "Granja" and (current_mes = 5 or current_mes = 10)
						edificio.count = 0
				}
				else{
					dinero -= edificio_trabajo_sueldo[edificio.tipo] * array_length(edificio.trabajadores)
					mes_sueldos[current_mes] += edificio_trabajo_sueldo[edificio.tipo] * array_length(edificio.trabajadores)
					for(var b = 0; b < array_length(edificio.trabajadores); b++)
						edificio.trabajadores[b].familia.riqueza += edificio_trabajo_sueldo[edificio.tipo]
					//Granjas
					if edificio_nombre[edificio.tipo] = "Granja"{
						if current_mes = 5 or current_mes = 10{
							edificio.almacen[recurso_cultivo[edificio.modo]] += round(15 * min(edificio.count, 5 * array_length(edificio.trabajadores)) * edificio.eficiencia)
							edificio.count = 0
						}
						else
							edificio.count += array_length(edificio.trabajadores)
						var b = 200 * array_contains(recurso_comida, recurso_cultivo[edificio.modo])
						if (current_mes = 0 or current_mes = 6) and edificio.almacen[recurso_cultivo[edificio.modo]] > b and recurso_exportado[recurso_cultivo[edificio.modo]]{
							dinero += floor(recurso_precio[recurso_cultivo[edificio.modo]] * (edificio.almacen[recurso_cultivo[edificio.modo]] - b))
							mes_exportaciones[current_mes] += floor(recurso_precio[recurso_cultivo[edificio.modo]] * (edificio.almacen[recurso_cultivo[edificio.modo]] - b))
							edificio.almacen[recurso_cultivo[edificio.modo]] = b
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
						if (current_mes = 0 or current_mes = 6) and recurso_exportado[1]{
							dinero += floor(recurso_precio[1] * edificio.almacen[1])
							mes_exportaciones[current_mes] += floor(recurso_precio[1] * edificio.almacen[1])
							edificio.almacen[1] = 0
						}
					}
					//Pescadería
					else if edificio_nombre[edificio.tipo] = "Pescadería"{
						edificio.almacen[8] += 10 * array_length(edificio.trabajadores)
						if (current_mes = 0 or current_mes = 6) and recurso_exportado[8] and edificio.almacen[8] > 200{
							dinero += floor(recurso_precio[8] * (edificio.almacen[8] - 200))
							mes_exportaciones[current_mes] += floor(recurso_precio[8] * (edificio.almacen[8] - 200))
							edificio.almacen[8] = 200
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
						if (current_mes = 0 or current_mes = 6) and recurso_exportado[recurso_mineral[edificio.modo]]{
							dinero += floor(recurso_precio[recurso_mineral[edificio.modo]] * edificio.almacen[recurso_mineral[edificio.modo]])
							mes_exportaciones[current_mes] += floor(recurso_precio[recurso_mineral[edificio.modo]] * edificio.almacen[recurso_mineral[edificio.modo]])
							edificio.almacen[recurso_mineral[edificio.modo]] = 0
						}
					}
					//Muelle
					else if edificio_nombre[edificio.tipo] = "Muelle"{
						if current_mes = 0 or current_mes= 6{
							var c = 50 * array_length(edificio.trabajadores)
							for(var b = 0; b < array_length(recurso_nombre); b++){
								var d = min(c, recurso_importado[b])
								edificio.almacen[b] += d
								dinero -= floor(d * recurso_precio[b] * 1.2)
								mes_importaciones[current_mes] += floor(d * recurso_precio[b] * 1.2)
								recurso_importado[b] -= d
							}
						}
					}
				}
			}
			//Casas
			if edificio_es_casa[edificio.tipo] and array_length(edificio.familias) > 0{
				dinero += edificio_familias_renta[edificio.tipo] * array_length(edificio.familias)
				mes_renta[current_mes] += edificio_familias_renta[edificio.tipo] * array_length(edificio.familias)
				var poblacion = 0
				for(var b = 0; b < array_length(edificio.familias); b++)
					poblacion += edificio.familias[b].integrantes
				//Conseguir alimento
				for(var b = 0; b < array_length(edificio_almacen_index); b++)
					if array_length(edificio_count[edificio_almacen_index[b]]) > 0{
						var tienda = edificio_count[edificio_almacen_index[b]][irandom(array_length(edificio_count[edificio_almacen_index[b]]) - 1)]
						for(var c = 0; c < array_length(recurso_comida); c++){
							var d = recurso_comida[c]
							if edificio.almacen[d] < poblacion and tienda.almacen[d] > 0{
								var e = poblacion - edificio.almacen[d]
								if tienda.almacen[d] >= e{
									tienda.almacen[d] -= e
									edificio.almacen[d] += e
								}
								else{
									edificio.almacen[d] += tienda.almacen[d]
									tienda.almacen[d] = 0
								}
							}
						}
					}
				//Repartir comida
				var fel_comida = 0, comida_total = 0, comida_variedad = 0, flag = true
				for(var b = 0; b < array_length(recurso_comida); b++){
					comida_total += edificio.almacen[recurso_comida[b]]
					if edificio.almacen[recurso_comida[b]] > poblacion / 2
						comida_variedad++
				}
				//Demanda satisfecha
				if comida_total >= poblacion{
					fel_comida = min(100, 20 + 20 * comida_variedad)
					for(var b = 0; b < array_length(recurso_comida); b++)
						edificio.almacen[recurso_comida[b]] = floor(edificio.almacen[recurso_comida[b]] * (comida_total - poblacion) / comida_total)
					if not ley_eneabled[4]
						for(var b = 0; b < array_length(edificio.familias); b++){
							var familia = edificio.familias[b], c = min(familia.riqueza, familia.integrantes)
							familia.riqueza -= c
							dinero += c
							mes_tarifas[current_mes] += c
						}
				}
				//Demanda insatisfecha
				else{
					fel_comida = min(100, 20 + 20 * comida_variedad) * comida_total / poblacion
					for(var b = 0; b < array_length(recurso_comida); b++)
						edificio.almacen[recurso_comida[b]] = 0
					if not ley_eneabled[4]
						for(var b = 0; b < array_length(edificio.familias); b++){
							var familia = edificio.familias[b], c = min(familia.riqueza, floor(familia.integrantes * comida_total / poblacion))
							familia.riqueza -= c
							dinero += c
							mes_tarifas[current_mes] += c
						}
				}
				//Actualizar felicidad por alimentación y pagar renta
				for(var b = 0; b < array_length(edificio.familias); b++){
					var familia = edificio.familias[b]
					familia.riqueza -= edificio_familias_renta[edificio.tipo]
					if familia.riqueza <= -30{
						cambiar_casa(familia, homeless)
						b--
					}
					familia.felicidad_alimento = floor((familia.felicidad_alimento + fel_comida) / 2)
					if irandom(10) > familia.felicidad_alimento{
						flag = false
						if familia.padre != null_persona{
							flag = destroy_persona(familia.padre)
							mes_inanicion[current_mes] ++
						}
						if not flag and familia.madre != null_persona{
							flag = destroy_persona(familia.madre)
							mes_inanicion[current_mes]++
						}
						if not flag
							for(var c = 0; not flag and c < array_length(familia.hijos); c++)
								if brandom(){
									flag = destroy_persona(familia.hijos[c])
									mes_inanicion[current_mes]++
									c--
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
		//Entrar a bancarrota
		if not deuda and dinero < 0{
			deuda = true
			deuda_dia = dia
			show_message("Te has quedado sin dinero, tienes un año para pagar tu deuda externa")
		}
		//Salid de bancarrota
		if deuda and dinero > 0
			deuda = false
		//Perder por bancarrota
		if deuda and dia = deuda_dia + 365{
			show_message("HAS PERDIDO\n\nNo has sido capaz de pagar tu deuda externa a tiempo")
			if show_question("¿Volver a jugar?")
				game_restart()
			else
				game_end()
		}
	}
//Añadir familia
if keyboard_check(vk_lcontrol) and (keyboard_check_pressed(ord("F")) or (keyboard_check(ord("F")) and keyboard_check(vk_lshift)))
	add_familia()
//Reiniciar
if keyboard_check_pressed(ord("R")) and keyboard_check(vk_lcontrol)
	game_restart()
//Salir
if keyboard_check_pressed(vk_escape)
	game_end()
//Pantalla completa
if keyboard_check_pressed(vk_f4)
	window_set_fullscreen(not window_get_fullscreen())
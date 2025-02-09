#region Visual
window_set_cursor(cr_default)
//Dibujar mundo
#region Dibujo de mundo
for(var a = 0; a <= xsize; a++)
	draw_line(a * 16 - xpos, -ypos, a * 16 - xpos, ysize * 16 - ypos)
for(var a = 0; a <= ysize; a++)
	draw_line(-xpos, a * 16 - ypos, xsize * 16 - xpos, a * 16 - ypos)
for(var a = min_camx; a < max_camx; a++)
	for(var b = min_camy; b < max_camy; b++){
		draw_set_color(altura_color[a, b])
		draw_rectangle(a * 16 - xpos, b * 16 - ypos, a * 16 + 15 - xpos, b * 16 + 15 - ypos, false)
	}
#endregion
#region vistas
if keyboard_check(ord("G")){
	if mouse_wheel_up()
		build_type = (build_type + 1) mod array_length(recurso_cultivo)
	if mouse_wheel_down()
		build_type = (build_type + array_length(recurso_cultivo) - 1) mod array_length(recurso_cultivo)
}
if keyboard_check(ord("G")) or (build_sel and edificio_nombre[build_index] = "Granja")
	draw_gradiente(build_type, 0)
if keyboard_check(ord("M")){
	if mouse_wheel_up()
		build_type = (build_type + 1) mod array_length(recurso_mineral)
	if mouse_wheel_down()
		build_type = (build_type + array_length(recurso_mineral) - 1) mod array_length(recurso_mineral)
}
if keyboard_check(ord("M")) or (build_sel and edificio_nombre[build_index] = "Mina")
	draw_gradiente(build_type, 1)
if keyboard_check(ord("B")) or (build_sel and (edificio_es_casa[build_index] or build_index = 21))
	draw_gradiente(0, 2)
if keyboard_check(ord("C"))
	draw_gradiente(0, 3)
#endregion
//Dibujo de arboles
for(var a = min_camx; a < max_camx; a++)
	for(var b = min_camy; b < max_camy; b++)
		if bosque[a, b]
			draw_sprite(spr_arbol, 0, a * 16 - xpos, b * 16 - ypos)
//Información general
draw_set_alpha(0.5)
draw_set_color(c_ltgray)
draw_rectangle(0, room_height, string_width($"FPS: {fps}\n{fecha(dia)}\n{array_length(personas)} habitantes\n$ {dinero}"), room_height - string_height($"FPS: {fps}\n{fecha(dia)}\n{array_length(personas)} habitantes\n$ {dinero}"), false)
draw_set_color(c_black)
draw_set_valign(fa_bottom)
pos = room_height
draw_text_pos(0, pos, $"FPS: {fps}\n{fecha(dia)}\n{array_length(personas)} habitantes\n$ {dinero}")
for(var a = 0; a < array_length(exigencia_nombre); a++)
	if exigencia_pedida[a]
		draw_text_pos(0, pos, $"{exigencia_nombre[a]} {exigencia[a].expiracion - dia} días restantes")
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
		draw_set_color(c_red)
		draw_circle(b* 16 - xpos + 4, c * 16 - ypos + 4, 3, false)
		if edificio.huelga{
			draw_set_color(c_white)
			draw_rectangle(b * 16 - xpos, c * 16 - ypos, b * 16 - xpos + string_width("PARO"), c * 16 - ypos + string_height("PARO"), false)
			draw_set_color(c_red)
			draw_text(b * 16 - xpos, c * 16 - ypos, "PARO")
		}
	}
}
//Edificios en construcción
for(var a = 0; a < array_length(cola_construccion); a++){
	var next_build = cola_construccion[a], b = next_build.x, c = next_build.y
	draw_set_color(make_color_hsv(edificio_color[next_build.id], 255, 255))
	draw_rectangle(b * 16 - xpos, c * 16 - ypos, (b + edificio_width[next_build.id]) * 16 - 1 - xpos, (c + edificio_height[next_build.id]) * 16 - 1- ypos, true)
	draw_text(b * 16 - xpos, c * 16 - ypos, $"{edificio_nombre[next_build.id]}{edificio_nombre[next_build.id] = "Mina" ? "\n" + recurso_nombre[recurso_mineral[next_build.tipo]] : ""}{edificio_nombre[next_build.id] = "Granja" ? "\n" + recurso_nombre[recurso_cultivo[next_build.tipo]] : ""}")
}
#endregion
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
		for(var a = 0; a < array_length(edificio_categoria[build_categoria]); a++){
			b = edificio_categoria[build_categoria, a]
			if draw_boton(110, pos, $"{edificio_nombre[b]} ${edificio_precio[b]}", , ,
				function(b){
					draw_set_valign(fa_bottom)
					draw_text(100, room_height - 100, $"{edificio_es_casa[b] ? "Espacio para " + string(edificio_familias_max[b]) + " familias\n" : ""}{
						edificio_es_trabajo[b] ? "Necesita " + string(edificio_trabajadores_max[b]) + " trabajadores " + ((edificio_trabajo_educacion[b] = 0) ? "sin educación" : "con " + educacion_nombre[edificio_trabajo_educacion[b]]) + "\n" : ""}{
						edificio_es_escuela[b] ? "Enseña a " + string(edificio_clientes_max[b]) + " alumnos\n" : ""}{
						edificio_es_medico[b] ? "Atiende a " + string(edificio_clientes_max[b]) + " pacientes\n" : ""}{
						edificio_es_ocio[b] or edificio_es_iglesia[b] ? "Acepta " + string(edificio_clientes_max[b]) + " visitantes\n" : ""}{edificio_descripcion[b]}")
					draw_set_valign(fa_top)
				}, b) and dinero + 2500 >= edificio_precio[b]{
				build_index = b
				build_sel = true
				sel_build = false
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
			if draw_menu(120, pos, $"Felicidad: {floor(felicidad_total)}", 3, , true){
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
			draw_text_pos(110, pos, $"Felicidad vivenda: {floor(fel_viv / array_length(personas))}")
			for(var a = 0; a < array_length(edificio_nombre); a++)
				if edificio_es_casa[a] and (edificio_nombre[a] = "Homeless" or array_length(edificio_count[a]) > 0)
					if draw_menu(110, pos, $"{edificio_nombre[a]}: {temp_array[a]} habitantes ({floor(temp_array[a] * 100 / array_length(personas))}%)", a)
						for(b = 0; b < array_length(edificio_count[a]); b++)
							if draw_boton(120, pos, $"{edificio_nombre[a]} {b + 1} (espacio para {edificio_familias_max[a] - array_length(edificio_count[a, b].familias)} familias)"){
								sel_build = false
								sel_info = true
								sel_tipo = 0
								sel_edificio = edificio_count[a, b]
							}
		}
		//Ministerio de Trabajo
		else if ministerio = 2{
			var fel_tra= 0, num_tra = 0, temp_array, num_des = 0, num_temp = 0
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
					for(b = 0; b < array_length(edificio_count[a]); b++){
						vacantes -= array_length(edificio_count[a, b].trabajadores)
						if ley_eneabled[6] and a = 20
							num_temp += array_length(edificio_count[a, b].trabajadores)
					}
				}
			draw_text_pos(110, pos, $"Felicidad laboral: {floor(fel_tra / num_tra)}")
			draw_text_pos(110, pos, $"Desempleo: {floor(100 * num_des / num_tra)}%")
			draw_text_pos(110, pos, $"{vacantes} puestos de trabajo disponibles")
			for(var a = 0; a < array_length(edificio_nombre); a++)
				if edificio_es_trabajo[a] and (edificio_nombre[a] = "Desempleado" or array_length(edificio_count[a]) > 0)
					if draw_menu(120, pos, $"{edificio_nombre[a]}: {temp_array[a]} trabajadores", a)
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
					if draw_boton(120, pos, $"{edificio_nombre[next_build.id]} ({edificio_precio[next_build.id]})") and dinero >= edificio_precio[next_build.id]{
						array_delete(cola_construccion, a, 1)
						var edificio = add_edificio(next_build.x, next_build.y, next_build.id)
						if edificio_nombre[build_index] = "Granja"{
							var d = 0
							for(b = 0; b < edificio_width[build_index]; b++)
								for(var c = 0; c < edificio_height[build_index]; c++)
									d += cultivo[build_type][# next_build.x + b, next_build.y + c]
							edificio.eficiencia = d / edificio_width[build_index] / edificio_height[build_index]
							edificio.modo = next_build.tipo
						}
						else if edificio_nombre[build_index] = "Mina"
							edificio.modo = next_build.tipo
						//Despedir a todos los trabajadores si la ley de trabajo temporal está habilitada
						if array_length(cola_construccion) = 0 and ley_eneabled[6]
							for(b = 0; b < array_length(edificio_count[20]); b++){
								edificio = edificio_count[20, b]
								set_paro(true, edificio)
								while array_length(edificio.trabajadores) > 0
									cambiar_trabajo(edificio.trabajadores[0], null_edificio)
							}
					}
				}
			draw_text_pos(110, pos, $"{num_temp} trabajadores temporales ({floor(100 * num_temp / num_tra)}%)")
			for(var a = 0; a < array_length(educacion_nombre); a++)
				if array_length(trabajo_educacion[a]) > 0 and draw_menu(110, pos, educacion_nombre[a], 5 + a)
					for(b = 0; b < array_length(trabajo_educacion[a]); b++)
						draw_text_pos(120, pos, edificio_nombre[trabajo_educacion[a, b].tipo])
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
			draw_text_pos(110, pos, $"Satisfación sanitaria: {floor(fel_sal / array_length(personas))}")
			for(var a = 0; a < 12; a++)
				temp_enfermos += mes_enfermos[a]
			draw_text_pos(110, pos, $"{temp_enfermos} muertes por enfermedad el último año")
			draw_text_pos(110, pos, $"{num_sal} personas enfermas")
			draw_text_pos(120, pos, $"{array_length(desausiado.clientes)} personas sin atención médica")
			draw_text_pos(120, pos, $"{temp_espera} personas atendidas")
			if draw_menu(110, pos, $"{array_length(medicos) - 1} edificios médicos", 0)
				for(var a = 0; a < array_length(edificio_nombre); a++)
					if edificio_es_medico[a]
						for(b = 0; b < array_length(edificio_count[a]); b++)
							if draw_boton(120, pos, $"{edificio_nombre[a]} {b + 1} ({array_length(edificio_count[a, b].clientes)} clientes)"){
								sel_build = false
								sel_info = true
								sel_tipo = 0
								sel_edificio = edificio_count[a, b]
							}
			for(var a = 0; a < array_length(familias); a++)
				num_hambre += (familias[a].felicidad_alimento < 10) * (real(familias[a].padre != null_persona) + real(familias[a].madre != null_persona) + array_length(familias[a].hijos))
			draw_text_pos(110, pos, $"{num_hambre} personas hambrietas")
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
							if draw_boton(120, pos, $"{edificio_nombre[a]} {b + 1} ({array_length(edificio_count[a, b].clientes)} estudiantes)"){
								sel_build = false
								sel_info = true
								sel_tipo = 0
								sel_edificio = edificio_count[a, b]
							}
		}
		//Ministerio de Economía
		else if ministerio = 5{
			var temp_array, temp_grid, temp_text_array, count, maxi, trab_esta = 0, trab_total = 0, temp_exportaciones, temp_importaciones
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
			#endregion
			for(var a = 0; a <= 9; a++){
				count[a] = 0
				maxi[a] = 0
			}
			for(var a = 0; a < array_length(recurso_nombre); a++){
				temp_exportaciones[a] = 0
				temp_importaciones[a] = 0
			}
			for(var a = 0; a < 12; a++){
				for(b = 0; b <= 9; b++){
					count[b] += temp_grid[b, (a + current_mes) mod 12]
					maxi[b] = max(maxi[b], temp_grid[b, a])
				}
				for(b = 0; b < array_length(recurso_nombre); b++){
					temp_exportaciones[b] += mes_exportaciones_recurso[a, b]
					temp_importaciones[b] += mes_importaciones_recurso[a, b]
				}
			}
			for(var a = 0; a < array_length(personas); a++)
				if personas[a].trabajo != null_edificio{
					trab_total++
					trab_esta += not personas[a].trabajo.privado
				}
			#region Ingresos
			if draw_menu(110, pos, $"Ingresos: ${count[0] + count[1] + count[2] + count[3] + count[9]}", 0){
				draw_text_pos(120, pos, $"{temp_text_array[0]}: ${count[0]}")
				draw_text_pos(120, pos, $"{temp_text_array[1]}: ${count[1]}")
				draw_text_pos(120, pos, $"{temp_text_array[2]}: ${count[2]}")
				if draw_menu(120, pos, $"{temp_text_array[3]}: ${count[3]}", 1)
					for(var c = 0; c < array_length(recurso_nombre); c++)
						if temp_exportaciones[c] > 0
							draw_text_pos(130, pos, $"{recurso_nombre[c]}: ${temp_exportaciones[c]}")
				draw_text_pos(120, pos, $"{temp_text_array[9]}: ${count[9]}")
			}
			if draw_menu(110, pos, $"Pérdidas: ${count[4] + count[5] + count[6] + count[7]}", 2){
				draw_text_pos(120, pos, $"{temp_text_array[4]}: ${count[4]}")
				draw_text_pos(120, pos, $"{temp_text_array[5]}: ${count[5]}")
				draw_text_pos(120, pos, $"{temp_text_array[6]}: ${count[6]}")
				if draw_menu(120, pos, $"{temp_text_array[7]}: ${count[7]}", 3)
					for(var c = 0; c < array_length(recurso_nombre); c++)
						if temp_importaciones[c] > 0
							draw_text_pos(130, pos, $"{recurso_nombre[c]}: ${temp_importaciones[c]}")
				draw_text_pos(120, pos, $"{temp_text_array[8]}: ${count[8]}")
			}
			draw_text_pos(110, pos, $"Balance: {count[0] + count[1] + count[2] + count[3] + count[9] - count[4] - count[5] - count[6] - count[7] - count[8]}")
			if trab_total > 0
				draw_text_pos(100, pos, $"{floor(100 * trab_esta / trab_total)} % de trabajadores estatales.")
			if draw_menu(110, pos, $"{array_length(encargos)} encargos", 4)
				for(var a = 0; a < array_length(encargos); a++){
					var encargo = encargos[a]
					if encargo.cantidad > 0{
						if encargo.edificio != null_edificio{
							if draw_boton(120, pos, $"{encargo.cantidad} de {recurso_nombre[encargo.recurso]} de {edificio_nombre[encargo.edificio.tipo]}"){
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
						if draw_boton(120, pos, $"{-encargo.cantidad} de {recurso_nombre[encargo.recurso]} a {edificio_nombre[encargo.edificio.tipo]}"){
							sel_build = false
							sel_info = true
							sel_tipo = 0
							sel_edificio = encargo.edificio
						}
				}
			pos = 100
			draw_set_color(c_black)
			draw_text_pos(500, pos, "Mercado internacional")
			var max_width = 0
			var last_pos = 140
			for(var a = 0; a < array_length(recurso_nombre); a++){
				draw_text_pos(420, last_pos + a * 20, recurso_nombre[a])
				max_width = max(max_width, last_width)
			}
			pos = 120
			draw_text_pos(420 + max_width, pos, "Exportar")
			for(var a = 0; a < array_length(recurso_nombre); a++)
				recurso_exportado[a] = draw_boton_rectangle(420 + max_width, pos + a * 20, 420 + max_width + 18, pos + a * 20 + 18, recurso_exportado[a])
			max_width += last_width + 10
			pos = 120
			draw_text_pos(420 + max_width, pos, "Importar")
			last_pos = pos
			for(var a = 0; a < array_length(recurso_nombre); a++){
				if draw_boton(420 + max_width, last_pos + a * 20, $"{recurso_importado[a]}", , , function() {draw_text(mouse_x + 20, mouse_y, "Shift para reducir")})
					if not keyboard_check(vk_lshift)
						recurso_importado[a] += 100
					else if recurso_importado[a] > 0
						recurso_importado[a] -= 100
				var max_width_2 = max_width + last_width
				if draw_boton(420 + max_width_2, last_pos + a * 20, $"({recurso_importado_fijo[a]})", , , function() {draw_text(mouse_x + 20, mouse_y, "Importación fija mensual")})
					if not keyboard_check(vk_lshift)
						recurso_importado_fijo[a] += 50
					else if recurso_importado_fijo[a] > 0
						recurso_importado_fijo[a] -= 50
			}
		}
		//Ministerio de Exterior
		else if ministerio = 6{
			draw_text_pos(100, pos, "Relaciones Exteriores")
			for(var a = 1; a < array_length(pais_nombre); a++){
				draw_text_pos(110, pos, $"{pais_nombre[a]} ({pais_relacion[a]})")
				var d = 0
				for(b = 0; b < array_length(recurso_nombre); b++)
					for(var c = 0; c < array_length(recurso_tratados[b]); c++)
						if recurso_tratados[b, c].pais = a
							d++
				if d > 0 and draw_menu(120, pos, $"{d} tratados comerciales", a)
					for(b = 0; b < array_length(recurso_nombre); b++)
						for(var c = 0; c < array_length(recurso_tratados[b]); c++){
							var tratado = recurso_tratados[b, c]
							if tratado.pais = a
								draw_text_pos(130, pos, $"{tratado.cantidad} de {recurso_nombre[tratado.recurso]}, {tratado.tiempo} meses restantes.")
						}
			}
			pos = 120
			draw_text_pos(480, pos, "Ofertas disponibles")
			for(var a = 0; a < array_length(tratados_ofertas); a++){
				var tratado = tratados_ofertas[a]
				if draw_boton(500, pos, $"{tratado.cantidad} de {recurso_nombre[tratado.recurso]} a {pais_nombre[tratado.pais]} (+ {floor(tratado.factor * 100) - 100}%, {floor(tratado.tiempo / 12)} años y {tratado.tiempo mod 12} meses)"){
					add_tratado(tratado.pais, tratado.recurso, tratado.cantidad, tratado.factor, tratado.tiempo)
					array_delete(tratados_ofertas, a, 1)
				}
			}
		}
		//Leyes
		else if ministerio = 7{
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
		draw_text(mx * 16 - xpos, (my - 1) * 16 - ypos, $"Eficiencia: {floor(c * 100 / edificio_width[build_index] / edificio_height[build_index])}%")
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
			draw_text(mx * 16 - xpos, (my - 1) * 16 - ypos, $"Depósito: {c}")
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
					draw_text(mx * 16 - xpos, (my - 2) * 16 - ypos, $"{c} madera disponible")
			}
		}
		//Construcción del muelle
		else
			flag = edificio_valid_place(mx, my, build_index)
	if not flag
		draw_text(mx * 16 - xpos, (my - 2) * 16 - ypos, "Construcción bloqueada")
	//Construir
	if mouse_check_button_pressed(mb_left){
		mouse_clear(mb_left)
		if flag{
			for(var a = 0; a < edificio_width[build_index]; a++)
				for(var b = 0; b < edificio_height[build_index]; b++)
					array_set(construccion_reservada[mx + a], my + b, true)
			if array_length(cola_construccion) = 0 and ley_eneabled[6]
				for(var a = 0; a < array_length(edificio_count[20]); a++)
					set_paro(false, edificio_count[20, a])
			array_push(cola_construccion, {
				x : mx,
				y : my,
				id : build_index,
				tipo : build_type,
				tiempo : edificio_construccion_tiempo[build_index]})
			build_sel = keyboard_check(vk_lshift)
			dinero -= edificio_precio[build_index]
			mes_construccion[current_mes] += edificio_precio[build_index]
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
	if mx >= 0 and my >= 0 and mx < xsize and my < ysize and mouse_x < room_width - sel_info * 300 and not sel_build{
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
		if sel_edificio.huelga{
			draw_text_pos(room_width - 20, pos, "Edificio en huelga")
			if sel_edificio.exigencia_fallida
				var a = 240 * array_length(sel_edificio.trabajadores)
			else
				a = 60 * array_length(sel_edificio.trabajadores)
			if draw_boton(room_width - 40, pos, $"Sobornar huelga ${a}") and dinero >= a{
				dinero -= a
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
			draw_set_alpha(0.5)
		}
		//Exigencia pendiente
		else if sel_edificio.exigencia != null_exigencia
			draw_text_pos(room_width - 20, pos, $"Esperando que cumplas {exigencia_nombre[sel_edificio.huelga_motivo]}")
		#region presupuesto
		for(var a = 0; a < 5; a++)
			if draw_sprite_boton(spr_icono, 3 - (a > sel_edificio.presupuesto), room_width - 200 + a * 40, pos, 40, 40)
				for(var b = 0; b < array_length(edificio_count[sel_edificio.tipo]); b++){
					if keyboard_check(vk_lshift)
						var edificio = edificio_count[sel_edificio.tipo, b]
					else{
						b = array_length(edificio_count[sel_edificio.tipo])
						edificio = sel_edificio
					}
					edificio.vivienda_calidad -= edificio.presupuesto
					edificio.trabajo_calidad -= 4 * edificio.presupuesto
					edificio.trabajo_sueldo -= edificio.presupuesto
					edificio.mantenimiento -= edificio.presupuesto
					edificio.presupuesto = a
					edificio.vivienda_calidad += edificio.presupuesto
					edificio.trabajo_calidad += 4 * edificio.presupuesto
					edificio.trabajo_sueldo += edificio.presupuesto
					edificio.mantenimiento += edificio.presupuesto
				}
		pos += 40
		draw_text_pos(room_width - 40, pos, $"{edificio_es_trabajo[sel_edificio.tipo] ? "Calidad laboral: " + string(sel_edificio.trabajo_calidad) + "  Sueldo: $" + string(sel_edificio.trabajo_sueldo) + "\n" : ""}{
			edificio_es_casa[sel_edificio.tipo] ? "Calidad de vivienda: " + string(sel_edificio.vivienda_calidad) + "\n" : ""}")
		#endregion
		//Información familias
		if edificio_es_casa[sel_edificio.tipo]{
			if draw_menu(room_width - 20, pos, $"Familias: {array_length(sel_edificio.familias)}/{edificio_familias_max[sel_edificio.tipo]}", 3)
				for(var a = 0; a < array_length(sel_edificio.familias); a++)
					if draw_boton(room_width - 40, pos, $"Familia {sel_edificio.familias[a].padre.apellido} {sel_edificio.familias[a].madre.apellido}"){
						sel_familia = sel_edificio.familias[a]
						sel_tipo = 1
					}
		}
		//Información trabajadores
		if edificio_es_trabajo[sel_edificio.tipo]{
			if draw_menu(room_width - 20, pos, $"Trabajadores: {array_length(sel_edificio.trabajadores)}/{edificio_trabajadores_max[sel_edificio.tipo]}", 4)
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
				draw_text_pos(room_width - 40, pos, $"Eficiencia: {floor(sel_edificio.eficiencia * 100)}%")
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
			if edificio_nombre[sel_edificio.tipo] = "Mina"{
				draw_text_pos(room_width - 20, pos, $"Extrayendo {recurso_nombre[recurso_mineral[sel_edificio.modo]]}")
				var c = 0
				for(var a = max(0, sel_edificio.x - 1); a < min(xsize - 1, sel_edificio.x + edificio_width[sel_edificio.tipo] + 1); a++)
					for(var b = max(0, sel_edificio.y - 1); b < min(xsize - 1, sel_edificio.y + edificio_height[sel_edificio.tipo] + 1); b++)
						if mineral[sel_edificio.modo][a, b]
							c += mineral_cantidad[sel_edificio.modo][a, b]
				draw_text_pos(room_width - 40, pos, $"Depósito: {c}")
				if not sel_edificio.privado and draw_boton(room_width - 20, pos, "Cambiar recurso", , not sel_edificio.huelga)
					sel_modo = not sel_modo
				if sel_modo
					for(var a = 0; a < array_length(recurso_mineral); a++)
						if a != sel_edificio.modo{
							if draw_boton(room_width - 40, pos, recurso_nombre[recurso_mineral[a]])
								sel_edificio.modo = a
							if mouse_x > room_width - 40 - last_width and mouse_y > pos - last_height and mouse_x < room_width - 40 and mouse_y < pos{
								draw_gradiente(a, 1)
								draw_set_color(c_black)
							}
						}
			}
		}
		//Información escuelas / consultas
		if edificio_es_escuela[sel_edificio.tipo] or edificio_es_medico[sel_edificio.tipo]{
			if draw_menu(room_width - 20, pos, $"{edificio_es_escuela[sel_edificio.tipo] ? "Estudientes" : "Clientes"}: {array_length(sel_edificio.clientes)}/{edificio_clientes_max[sel_edificio.tipo]}", 2)
				for(var a = 0; a < array_length(sel_edificio.clientes); a++)
					if draw_boton(room_width - 40, pos, name(sel_edificio.clientes[a])){
						sel_persona = sel_edificio.clientes[a]
						sel_tipo = 2
					}
		}
		//Almacen
		if draw_menu(room_width - 20, pos, "Almacen", 1, , false){
			var text = ""
			for(var a = 0; a < array_length(recurso_nombre); a++)
				if floor(sel_edificio.almacen[a]) != 0
					text += $"{text != "" ? "\n" : ""}{recurso_nombre[a]}: {floor(sel_edificio.almacen[a])}"
			draw_text_pos(room_width - 40, pos, text != "" ? text : "Sin recursos")
		}
		//Edificios cercanos
		if draw_menu(room_width - 20, pos, $"{array_length(sel_edificio.edificios_cerca)} edificios cerca", 0)
			for(var a = 0; a < array_length(sel_edificio.edificios_cerca); a++){
				var temp_edificio = sel_edificio.edificios_cerca[a]
				if draw_boton(room_width - 40, pos, edificio_nombre[temp_edificio.tipo]){
					sel_edificio = temp_edificio
					break
				}
			}
		if not edificio_estatal[sel_edificio.tipo] and not sel_edificio.huelga{
			pos += 20
			if sel_edificio.privado{
				if draw_boton(room_width, pos, $"Estatizar Edificio -${floor(edificio_precio[sel_edificio.tipo] * 1.1)}") and dinero >= floor(edificio_precio[sel_edificio.tipo] * 1.1){
					dinero -= floor(edificio_precio[sel_edificio.tipo] * 1.1)
					sel_edificio.privado = false
				}
			}
			else if draw_boton(room_width, pos, $"Privatizar Edificio +${floor(edificio_precio[sel_edificio.tipo] * 0.9)}"){
				dinero += floor(edificio_precio[sel_edificio.tipo] * 0.9)
				sel_edificio.privado = true
			}
		}
		if edificio_nombre[sel_edificio.tipo] = "Muelle"{
			if draw_boton(room_width - 20, pos, "Abrir ministerio de economía"){
				sel_build = true
				sel_info = false
				ministerio = 5
			}
		}
		//Destruir edificio
		pos += 40
		if not sel_edificio.privado and ((sel_edificio.tipo != 13 and sel_edificio.tipo != 20) or array_length(edificio_count[sel_edificio.tipo]) > 1) and draw_boton(room_width, pos, "Destruir Edificio", , not sel_edificio.huelga){
			destroy_edificio(sel_edificio)
			sel_info = false
		}
		draw_set_alpha(1)
	}
	//Información familias
	else if sel_tipo = 1 and sel_familia != null_familia{
		draw_text_pos(room_width, pos, name_familia(sel_familia))
		if sel_familia.casa = homeless
			draw_text_pos(room_width - 20, pos, "Sin hogar")
		else if draw_boton(room_width - 20, pos, $"Vivienda: {edificio_nombre[sel_familia.casa.tipo]}"){
			sel_edificio = sel_familia.casa
			sel_tipo = 0
		}
		if sel_familia.padre != null_persona and draw_boton(room_width - 20, pos, $"Padre: {sel_familia.padre}"){
			sel_persona = sel_familia.padre
			sel_tipo = 2
		}
		if sel_familia.madre != null_persona and draw_boton(room_width - 20, pos, $"Madre: {sel_familia.madre}"){
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
		else if draw_boton(room_width - 20, pos, $"Vive en: {edificio_nombre[sel_persona.familia.casa.tipo]}"){
			sel_edificio = sel_persona.familia.casa
			sel_tipo = 0
		}
		if sel_persona.trabajo = null_edificio
			draw_text_pos(room_width - 20, pos, "Sin trabajo")
		else if draw_boton(room_width - 20, pos, $"Trabaja en: {edificio_nombre[sel_persona.trabajo.tipo]}"){
			sel_edificio = sel_persona.trabajo
			sel_tipo = 0
		}
		draw_text_pos(room_width - 20, pos, $"Educación: {educacion_nombre[floor(sel_persona.educacion)]}")
		if sel_persona.escuela != null_edificio and draw_boton(room_width - 40, pos, $"Estudiando en {edificio_nombre[sel_persona.escuela.tipo]}"){
			sel_edificio = sel_persona.escuela
			sel_tipo = 0
		}
		else if sel_persona.es_hijo
			draw_text_pos(room_width - 40, pos, "Sin escolarizar")
		if sel_persona.medico != null_edificio{
			draw_text_pos(room_width - 20, pos, $"Enferm{ao(sel_persona)}")
			if sel_persona.medico = desausiado
				draw_text_pos(room_width - 40, pos, "Sin tratamiento")
			else if draw_boton(room_width - 40, pos, $"Tratándose en {edificio_nombre[sel_persona.medico.tipo]}"){
				sel_edificio = sel_persona.medico
				sel_tipo = 0
			}
		}
		else
			draw_text_pos(room_width - 20, pos, $"San{ao(sel_persona)}")	
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
#region Movimiento de la cámara
if mouse_x < 20 or keyboard_check(ord("A"))
	xpos = max(0, xpos - (1 + 7 * keyboard_check(vk_lshift)))
if mouse_y < 20 or keyboard_check(ord("W"))
	ypos = max(0, ypos - (1 + 7 * keyboard_check(vk_lshift)))
if mouse_x > room_width - 20 or keyboard_check(ord("D"))
	xpos = min(xsize * 16 - room_width, xpos + (1 + 7 * keyboard_check(vk_lshift)))
if mouse_y > room_height - 20 or keyboard_check(ord("S"))
	ypos = min(ysize * 16 - room_height, ypos + (1 + 7 * keyboard_check(vk_lshift)))
min_camx = floor(xpos / 16)
min_camy = floor(ypos / 16)
max_camx = ceil((xpos + room_width) / 16)
max_camy = ceil((ypos + room_height) / 16)
#endregion
//Pasar día
if keyboard_check(vk_space)
	repeat(1 + 29 * keyboard_check(vk_lshift)){
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
				b += array_length(edificio_count[20, a].trabajadores) * (0.8 + 0.1 * edificio_count[20, a].presupuesto)
			var next_build = cola_construccion[0]
			next_build.tiempo -= b
			//Edificio_terminado
			if next_build.tiempo <= 0{
				array_shift(cola_construccion)
				var edificio = add_edificio(next_build.x, next_build.y, next_build.id)
				if edificio_nombre[build_index] = "Granja"{
					var c = 0
					for(var a = 0; a < edificio_width[build_index]; a++)
						for(b = 0; b < edificio_height[build_index]; b++)
							c += cultivo[build_type][# next_build.x + a, next_build.y + b]
					edificio.eficiencia = c / edificio_width[build_index] / edificio_height[build_index]
					edificio.modo = next_build.tipo
				}
				else if edificio_nombre[build_index] = "Mina"
					edificio.modo = next_build.tipo
				//Despedir a todos los trabajadores si la ley de trabajo temporal está habilitada
				if array_length(cola_construccion) = 0 and ley_eneabled[6]
					for(var a = 0; a < array_length(edificio_count[20]); a++){
						edificio = edificio_count[20, a]
						set_paro(true, edificio)
						while array_length(edificio.trabajadores) > 0
							cambiar_trabajo(edificio.trabajadores[0], null_edificio)
					}
			}
		}
		//Mover recursos
		if array_length(encargos) > 0{
			var c = 0, rss_in = [], rss_out = []
			for(var a = 0; a < array_length(edificio_count[22]); a++)
				c += array_length(edificio_count[22, a].trabajadores) * (0.8 + 0.1 * edificio_count[22, a].presupuesto)
			c = round(c)
			for(var a = 0; a < array_length(recurso_nombre); a++){
				array_push(rss_in, false)
				array_push(rss_out, false)
			}
			for(var a = 0; a < array_length(encargos); a++){
				var next_encargo = encargos[a], edificio = edificio_count[13, irandom(array_length(edificio_count[13]) - 1)], b = 0
				//Encargo hacia el Muelle
				if next_encargo.cantidad > 0 and not rss_in[next_encargo.recurso]{
					rss_in[next_encargo.recurso] = true
					b = min(c, next_encargo.cantidad)
					next_encargo.cantidad -= b
					edificio.almacen[next_encargo.recurso] += b
					if next_encargo.cantidad = 0
						array_delete(encargos, a--, 1)
					c -= b
					if c = 0
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
			for(var a = 0; a < array_length(recurso_nombre); a++){
				array_set(mes_exportaciones_recurso[current_mes], a, 0)
				array_set(mes_importaciones_recurso[current_mes], a, 0)
			}
			//Actualizar precios de recursos y tratados comerciales
			for(var a = 0; a < array_length(recurso_nombre); a++){
				recurso_precio[a] *= random_range(0.95, 1.05)
				for(var b = 0; b < array_length(recurso_tratados[a]); b++){
					var tratado = recurso_tratados[a, b]
					tratado.tiempo--
					if tratado.tiempo = 0{
						show_debug_message($"No has podido cumplir el tratado de exportar {tratado.cantidad} de {recurso_nombre[tratado.recurso]} a {pais_nombre[tratado.pais]}")
						pais_relacion[tratado.pais]--
						array_delete(recurso_tratados[a], b--, 1)
					}
				}
			}
			#region Nuevas ofertas de tratados
			add_tratado_oferta()
			if array_length(tratados_ofertas) > 15
				array_shift(tratados_ofertas)
			#endregion
			//Cobrar mantenimiento
			for(var a = 0; a < array_length(edificio_nombre); a++){
				var c = 0
				for(var b = 0; b < array_length(edificio_count[a]); b++)
					c += not edificio_count[a, b].privado
				dinero -= edificio_mantenimiento[a] * c
				mes_mantenimiento[current_mes] += edificio_mantenimiento[a] * c
			}
			//Inmigración
			if ley_eneabled[1] and irandom(felicidad_total) > 25 or dia < 365{
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
			felicidad_minima = floor(17 + 3 * sqrt(floor(dia / 365)))
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
					var familia = add_familia(, false)
					if persona.sexo
						familia.madre = persona
					else
						familia.padre = persona
					persona.familia = familia
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
				if array_length(edificio_count[temp_array[b]]) > 0 and (persona.edad > 12 or (edificio_nombre[temp_array[b]] != "Taberna")) and (array_length(persona.familia.hijos) > 0 or (edificio_nombre[temp_array[b]] != "Circo")) and ((not persona.sexo and persona.edad > 15) or (edificio_nombre[temp_array[b]] != "Cabaret")){
					var ocio = edificio_count[temp_array[b], irandom(array_length(edificio_count[temp_array[b]]) - 1)]
					if ocio.count < edificio_clientes_max[temp_array[b]] and persona.familia.riqueza >= edificio_clientes_tarifa[temp_array[b]]{
						persona.familia.riqueza -= edificio_clientes_tarifa[temp_array[b]]
						if not ocio.privado{
							dinero += edificio_clientes_tarifa[temp_array[b]]
							mes_tarifas[current_mes] += edificio_clientes_tarifa[temp_array[b]]
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
			#region Calculo de felicidad
			felicidad_total = felicidad_total * array_length(personas) - persona.felicidad
			if array_length(medicos) = 1
				persona.felicidad_salud = floor(persona.felicidad_salud / 2)
			else
				if persona.familia.casa != homeless{
					if persona.trabajo != null_edificio
						persona.felicidad_salud = floor((persona.felicidad_salud + 3 * (50 - min(100, max(0, contaminacion[persona.familia.casa.x, persona.familia.casa.y])) / 5) * (50 - min(100, max(0, contaminacion[persona.trabajo.x, persona.trabajo.y])) / 5)) / 4)
					else if persona.escuela != null_edificio
						persona.felicidad_salud = floor((persona.felicidad_salud + 3 * (50 - min(100, max(0, contaminacion[persona.familia.casa.x, persona.familia.casa.y])) / 5) * (50 - min(100, max(0, contaminacion[persona.escuela.x, persona.escuela.y])) / 5)) / 4)
					else
						persona.felicidad_salud = floor((persona.felicidad_salud + 3 * (50 - min(100, max(0, contaminacion[persona.familia.casa.x, persona.familia.casa.y])) / 5)) / 4)
				}
				else
					persona.felicidad_salud = floor((persona.felicidad_salud + 3 * 30) / 4)
			persona.familia.felicidad_vivienda = floor((persona.familia.felicidad_vivienda + 3 * persona.familia.casa.vivienda_calidad) / 4)
			temp_array = [persona.felicidad_salud, persona.familia.felicidad_vivienda, persona.felicidad_ocio, persona.familia.felicidad_alimento, persona.felicidad_ley]
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
			if persona.familia.casa != homeless and (persona.trabajo != null_edificio or persona.escuela != null_edificio)
				array_push(temp_array, persona.felicidad_transporte)
			persona.felicidad = calcular_felicidad(temp_array)
			felicidad_total = (felicidad_total + persona.felicidad) / array_length(personas)
			#endregion
			//Descontento
			if persona.edad > 18 and persona.edad < 60 and irandom(felicidad_minima) >= persona.felicidad + 5 * (persona.nacionalidad = 0) and dia > 365{
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
				else if persona.trabajo != null_edificio and not persona.trabajo.huelga and persona.trabajo.exigencia = null_exigencia and not persona.trabajo.privado{
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
					else if fel_edu / num_edu < 25 and brandom() and not exigencia_cumplida[1]
						add_huelga(1, edificio)
					//Exigencia de diversión
					else if fel_div / array_length(edificio.trabajadores) < 25 and brandom() and not exigencia_cumplida[3]
						add_huelga(3, edificio)
					//Exigencia de religión
					else if fel_rel / array_length(edificio.trabajadores) < 30 and not exigencia_cumplida[4]
						add_huelga(4, edificio)
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
		#endregion
		//Ciclo de los edificios
		for(var a = 0; a < array_length(dia_trabajo[dia mod 28]); a++){
			var edificio = dia_trabajo[dia mod 28, a]
			//Edificios de trabajo
			if edificio_es_trabajo[edificio.tipo]{
				if edificio.huelga{
					edificio.huelga_tiempo--
					if edificio.huelga_tiempo = 0
						set_paro(false, edificio)
					if edificio_nombre[edificio.tipo] = "Granja" and (current_mes = 5 or current_mes = 10)
						edificio.count = 0
				}
				else if not edificio.paro{
					if not edificio.privado{
						dinero -= edificio.trabajo_sueldo * array_length(edificio.trabajadores)
						mes_sueldos[current_mes] += edificio.trabajo_sueldo * array_length(edificio.trabajadores)
					}
					for(var b = 0; b < array_length(edificio.trabajadores); b++)
						edificio.trabajadores[b].familia.riqueza += edificio.trabajo_sueldo
					//Granjas
					if edificio_nombre[edificio.tipo] = "Granja"{
						if current_mes = 5 or current_mes = 10{
							edificio.almacen[recurso_cultivo[edificio.modo]] += round(15 * min(edificio.count, 5 * array_length(edificio.trabajadores)) * edificio.eficiencia * (0.8 + 0.1 * edificio.presupuesto))
							edificio.count = 0
						}
						else
							edificio.count += array_length(edificio.trabajadores)
						var b = 200 * array_contains(recurso_comida, recurso_cultivo[edificio.modo])
						if (current_mes = 0 or current_mes = 6) and edificio.almacen[recurso_cultivo[edificio.modo]] > b{
							add_encargo(recurso_cultivo[edificio.modo], edificio.almacen[recurso_cultivo[edificio.modo]] - b, edificio, not edificio.privado)
							edificio.almacen[recurso_cultivo[edificio.modo]] = b
						}
					
					}
					//Aserradero
					else if edificio_nombre[edificio.tipo] = "Aserradero"{
						//Cortar árboles
						if array_length(edificio.array_real_1) > 0{
							var b = round(10 * array_length(edificio.trabajadores) * (0.8 + 0.1 * edificio.presupuesto))
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
							add_encargo(1, edificio.almacen[1], edificio, not edificio.privado)
							edificio.almacen[1] = 0
						}
					}
					//Pescadería
					else if edificio_nombre[edificio.tipo] = "Pescadería"{
						edificio.almacen[8] += round(10 * array_length(edificio.trabajadores) * (0.8 + 0.1 * edificio.presupuesto))
						if (current_mes = 0 or current_mes = 6) and recurso_exportado[8] and edificio.almacen[8] > 200{
							add_encargo(8, edificio.almacen[8] - 200, edificio, not edificio.privado)
							edificio.almacen[8] = 200
						}
					}
					//Minas
					else if edificio_nombre[edificio.tipo] = "Mina"{
						var b = round(12 * array_length(edificio.trabajadores) * (0.8 + 0.1 * edificio.presupuesto)), e = b
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
							set_paro(true, edificio)
						edificio.almacen[recurso_mineral[edificio.modo]] += e - b
						if (current_mes = 0 or current_mes = 6){
							add_encargo(recurso_mineral[edificio.modo], edificio.almacen[recurso_mineral[edificio.modo]], edificio, not edificio.privado)
							edificio.almacen[recurso_mineral[edificio.modo]] = 0
						}
					}
					//Muelle
					else if edificio_nombre[edificio.tipo] = "Muelle"{
						if current_mes = 0 or current_mes= 6{
							var c = round(150 * array_length(edificio.trabajadores) * (0.8 + 0.1 * edificio.presupuesto))
							for(var b = 0; b < array_length(recurso_nombre) and c > 0; b++){
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
											}
										}
										total -= d
										mes_exportaciones[current_mes] += floor(temp_factor * d * recurso_precio[b])
										array_set(mes_exportaciones_recurso[current_mes], b, mes_exportaciones_recurso[current_mes, b] + floor(temp_factor * d * recurso_precio[b]))
										dinero += floor(temp_factor * d * recurso_precio[b])
									}
									c -= total
								}
								#region Importaciones
								var total = min(c, recurso_importado[b])
								edificio.almacen[b] += total
								dinero -= floor(total * recurso_precio[b] * 1.2)
								mes_importaciones[current_mes] += floor(total * recurso_precio[b] * 1.2)
								array_set(mes_importaciones_recurso[current_mes], b, mes_importaciones_recurso[current_mes, b] + floor(total * recurso_precio[b] * 1.2))
								recurso_importado[b] -= total
								c -= total
								total = min(c, recurso_importado_fijo[b])
								edificio.almacen[b] += total
								dinero -= floor(total * recurso_precio[b] * 1.2)
								mes_importaciones[current_mes] += floor(total * recurso_precio[b] * 1.2)
								array_set(mes_importaciones_recurso[current_mes], b, mes_importaciones_recurso[current_mes, b] + floor(total * recurso_precio[b] * 1.2))
								c -= total
								#endregion
							}
						}
					}
					//Planta Siderúrgica
					else if edificio_nombre[edificio.tipo] = "Planta Siderúrgica"{
						var b = max(0, min(floor(edificio.almacen[9] / 2), floor(edificio.almacen[10] / 3), round(array_length(edificio.trabajadores) * (0.8 + 0.1 * edificio.presupuesto))))
						edificio.almacen[9] -= b * 2
						edificio.almacen[10] -= b * 3
						edificio.almacen[15] += b * 2
						add_encargo(9, edificio.almacen[9] + edificio.pedido[9] - 240, edificio, not edificio.privado)
						add_encargo(10, edificio.almacen[10] + edificio.pedido[10] - 360, edificio, not edificio.privado)
						add_encargo(15, edificio.almacen[15], edificio, not edificio.privado)
						edificio.almacen[15] = 0
						edificio.pedido[9] = 240 - edificio.almacen[9]
						edificio.pedido[10] = 360 - edificio.almacen[10]
					}
					//Fábrica textil
					else if edificio_nombre[edificio.tipo] = "Fábrica Textil"{
						var b = max(0, min(floor(edificio.almacen[3] / 3), round(array_length(edificio.trabajadores) * (0.8 + 0.1 * edificio.presupuesto))))
						edificio.almacen[3] -= b * 3
						edificio.almacen[16] += b
						add_encargo(3, edificio.almacen[3] + edificio.pedido[3] - 360, edificio, not edificio.privado)
						add_encargo(16, edificio.almacen[16], edificio, not edificio.privado)
						edificio.almacen[16] = 0
						edificio.pedido[3] = 360 - edificio.almacen[3]
					}
					//Astillero
					else if edificio_nombre[edificio.tipo] = "Astillero"{
						var b = max(0, min(floor(edificio.almacen[1] / 4), edificio.almacen[7], edificio.almacen[12], edificio.almacen[16], round(array_length(edificio.trabajadores) * (0.8 + 0.1 * edificio.presupuesto) / 5)))
						edificio.almacen[1] -= b * 4
						edificio.almacen[7] -= b
						edificio.almacen[12] -= b
						edificio.almacen[16] -= b
						edificio.almacen[17] += b / 10
						add_encargo(1, edificio.almacen[1] + edificio.pedido[1] - 200, edificio, not edificio.privado)
						add_encargo(7, edificio.almacen[7] + edificio.pedido[7] - 50, edificio, not edificio.privado)
						add_encargo(12, edificio.almacen[12] + edificio.pedido[12] - 50, edificio, not edificio.privado)
						add_encargo(16, edificio.almacen[16] + edificio.pedido[16] - 50, edificio, not edificio.privado)
						if edificio.almacen[17] >= 1
							add_encargo(17, floor(edificio.almacen[17]), edificio, not edificio.privado)
						edificio.almacen[17] -= floor(edificio.almacen[17])
						edificio.pedido[1] = 200 - edificio.almacen[1]
						edificio.pedido[7] = 50 - edificio.almacen[7]
						edificio.pedido[12] = 50 - edificio.almacen[12]
						edificio.pedido[16] = 50 - edificio.almacen[16]
					}
				}
			}
			//Casas
			if edificio_es_casa[edificio.tipo] and array_length(edificio.familias) > 0{
				if not edificio.privado{
					dinero += edificio_familias_renta[edificio.tipo] * array_length(edificio.familias)
					mes_renta[current_mes] += edificio_familias_renta[edificio.tipo] * array_length(edificio.familias)
				}
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
					familia.felicidad_alimento = floor((familia.felicidad_alimento + fel_comida) / 2)
					if irandom(10) > familia.felicidad_alimento{
						flag = false
						if familia.padre != null_persona{
							flag = destroy_persona(familia.padre)
							if exigencia_pedida[2]
								fallar_exigencia(2)
							mes_inanicion[current_mes] ++
						}
						if not flag and familia.madre != null_persona{
							flag = destroy_persona(familia.madre)
							if exigencia_pedida[2]
								fallar_exigencia(2)
							mes_inanicion[current_mes]++
						}
						if not flag
							for(var c = 0; not flag and c < array_length(familia.hijos); c++)
								if brandom(){
									flag = destroy_persona(familia.hijos[c])
									if exigencia_pedida[2]
										fallar_exigencia(2)
									mes_inanicion[current_mes]++
									c--
								}
						if flag{
							b--
							continue
						}
					}
				}
				if edificio != homeless
					for(var b = 0; b < array_length(edificio.familias); b++){
						var familia = edificio.familias[b]
						familia.riqueza -= edificio_familias_renta[edificio.tipo]
						if familia.riqueza <= -30{
							cambiar_casa(familia, homeless)
							b--
						}
					}
			}
			//Edificios médicos
			if edificio_es_medico[edificio.tipo]{
				//Curar pacientes
				repeat(min(array_length(edificio.clientes), round(edificio_clientes_calidad[edificio.tipo] * array_length(edificio.trabajadores) / 50 * (0.8 + 0.1 * edificio.presupuesto)))){
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
				if edificio_trabajadores_max[edificio.tipo] = 0
					edificio.count = 0
				else
					edificio.count = max(0, floor(edificio.count * (1 - array_length(edificio.trabajadores) / edificio_trabajadores_max[edificio.tipo])))
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
#region abreviatura
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
//Claves
if keyboard_check(vk_lshift) and keyboard_check(ord("4")){
	dinero += 100
	mes_herencia[current_mes] += 100
}
#endregion
function edificio_mejora(edificio = control.null_edificio, mejora = control.null_mejora){
	var agua = mejora.bool_agua, agua_num = mejora.agua, energia = mejora.bool_energia, energia_num = mejora.energia, precio = mejora.precio, anno = mejora.anno, nombre = mejora.nombre, recursos_id = mejora.recurso_id, recursos_num = mejora.recurso_num, descripcion = mejora.descripcion
	with control{
		if floor(dia / 360) >= anno{
			if agua
				mejora_requiere_agua = true
			if energia
				mejora_requiere_energia = true
			if not edificio.privado and (not agua or edificio.agua) and (not energia or edificio.energia){
				var flag = array_contains(mejoras_desbloqueadas, string(nombre)), precio_tecnologia = 0
				if not flag
					precio_tecnologia = floor(precio * (1 + 15 / (5 + floor(dia / 360) - anno)))
				if not array_contains(edificio.mejoras, string(nombre)) and draw_boton(room_width - 40, pos, $"{flag ? "" : "Desbloquear "}{nombre} ${precio + precio_tecnologia}",,, function(text){draw_text(mouse_x, mouse_y, text)}, descripcion) and dinero >= precio + precio_tecnologia{
					if not flag{
						array_push(mejoras_desbloqueadas, string(nombre))
						edificio_experiencia[edificio.tipo] = 1
					}
					if agua{
						edificio.agua_consumo += agua_num
						agua_output += agua_num
					}
					if energia{
						edificio.energia_consumo += energia_num
						energia_output += energia_num
					}
					dinero -= precio + precio_tecnologia
					mes_construccion[current_mes] += precio
					mes_investigacion[current_mes] += precio_tecnologia
					for(var a = 0; a < array_length(recursos_id); a++)
						recurso_construccion[recursos_id[a]] += real(recursos_num[a])
					array_push(edificio.mejoras, string(nombre))
					mejora.efecto(edificio)
					edificio.precio += precio
				}
			}
		}
	}
}
function edificio_mejora(nombre, edificio = control.null_edificio, anno = 0, precio = 0, descripcion = "", recursos_id = [], recursos_num = [], agua = false, agua_num = 0, energia = false, energia_num = 0){
	with control{
		if not edificio.privado and (not agua or edificio.agua) and (not energia or edificio.energia){
			var flag = array_contains(mejoras_desbloqueadas, string(nombre))
			if not flag
				precio = floor(precio * (2 + 15 / (5 + floor(dia / 365) - anno)))
			if not array_contains(edificio.mejoras, string(nombre)) and floor(dia / 365) >= anno and draw_boton(room_width - 40, pos, $"{flag ? "" : "Desbloquear "}{nombre} ${precio}",,, function(text){draw_text(mouse_x, mouse_y, text)}, descripcion) and dinero >= precio{
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
				dinero -= precio
				mes_construccion[current_mes] += precio
				for(var a = 0; a < array_length(recursos_id); a++)
					recurso_construccion[recursos_id[a]] += real(recursos_num[a])
				array_push(edificio.mejoras, string(nombre))
				return true
			}
		}
		return false
	}
}
function valorizar_edificio(edificio = null_edificio){
	with control{
		var index = edificio.tipo, width = edificio.width, height = edificio.height, var_edificio_nombre = edificio_nombre[index]
		var temp_precio = edificio_precio[index], temp_text = $"Edificio base: ${temp_precio}"
		if var_edificio_nombre = "Mina"{
			var c = 0, d = min(xsize - 1, edificio.x + width + 1), e = min(xsize - 1, edificio.y + height + 1)
			for(var a = max(0, edificio.x - 1); a < d; a++)
				for(var b = max(0, edificio.y - 1); b < e; b++)
					if mineral[edificio.modo][a, b]
						c += mineral_cantidad[edificio.modo][a, b]
			c = floor(c * recurso_precio[recurso_mineral[edificio.modo]] * impuesto_minero)
			temp_precio += c
			temp_text += $"\nDerechos mineros: ${c}"
		}
		else if var_edificio_nombre = "Aserradero"{
			var c = 0, d = min(edificio.x + width + 5, xsize), e = min(edificio.y + height + 5, ysize)
			for(var a = max(0, edificio.x - 5); a < d; a++)
				for(var b = max(0, edificio.y - 5); b < e; b++)
					if bosque[a, b]
						c += bosque_madera[a, b]
			c = floor(c * recurso_precio[1] * impuesto_maderero)
			temp_precio += c
			temp_text += $"\nDerechos madereros: ${c}"
		}
		else if var_edificio_nombre = "Pozo Petrolífero"{
			var c = 0, d = min(edificio.x + width, xsize), e = min(edificio.y + height, ysize)
			for(var a = edificio.x; a < d; a++)
				for(var b = edificio.y; b < e; b++)
					c += petroleo[a, b]
			c = floor(c * recurso_precio[27] * impuesto_petrolifero)
			temp_precio += c
			temp_text += $"\nDerechos petrolíferos: ${c}"
		}
		temp_text += $"\nPrecio terreno: ${valor_terreno * width * height}"
		temp_precio += valor_terreno * width * height
		var b = 0
		for(var a = 0; a < array_length(recurso_nombre); a++)
			if edificio.almacen[a] > 0
				b += edificio.almacen[a] * recurso_precio[a]
		if b > 0{
			temp_text += $"\nInventario: ${floor(b)}"
			temp_precio += floor(b)
		}
		return {int : temp_precio, str : temp_text}
	}
}
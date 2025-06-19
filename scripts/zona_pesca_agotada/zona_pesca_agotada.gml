function zona_pesca_agotada(zona_pesca = control.null_zona_pesca){
	with control{
		if zona_pesca.cantidad <= 0{
			array_remove(zonas_pesca, zona_pesca, "Zona de pesca agotada")
			var a = min(zona_pesca.a + 5, xsize - 1), b = min(zona_pesca.b + 5, ysize - 1), c = max(0, zona_pesca.b - 5)
			for(var d = max(0, zona_pesca.a - 5); d <= a; d++)
				for(var e = c; e <= b; e++)
					array_add(zona_pesca_num[d], e, -1)
			for(a = 0; a < array_length(edificio_count[14]); a++){
				var temp_edificio = edificio_count[14, a]
				if temp_edificio.zona_pesca = zona_pesca
					buscar_zona_pesca(temp_edificio)
			}
		}
	}
}
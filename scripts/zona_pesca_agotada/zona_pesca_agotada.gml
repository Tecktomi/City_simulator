function zona_pesca_agotada(zona_pesca = control.null_zona_pesca){
	with control{
		if zona_pesca.cantidad <= 0{
			array_remove(zonas_pesca, zona_pesca, "Zona de pesca agotada")
			var a = zona_pesca.a, b = zona_pesca.b
			ds_grid_add_region(zona_pesca_num, max(0, a - 5), max(0, b - 5), min(xsize - 1, a + 4), min(ysize - 1, b + 4), -1)
			for(a = 0; a < array_length(edificio_count[14]); a++){
				var temp_edificio = edificio_count[14, a]
				if temp_edificio.zona_pesca = zona_pesca
					if not buscar_zona_pesca(temp_edificio){
						set_paro(true, temp_edificio)
						while array_length(temp_edificio.trabajadores) > 0{
							var persona = temp_edificio.trabajadores[0]
							cambiar_trabajo(persona, null_edificio)
							buscar_trabajo(persona)
						}
						if temp_edificio.privado
							destroy_edificio(temp_edificio)
					}
			}
		}
	}
}
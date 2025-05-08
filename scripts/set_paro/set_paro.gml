function set_paro(paro, edificio = control.null_edificio){
	with control{
		if debug
			show_debug_message($"{fecha(dia)} {edificio.nombre} ha {paro ? "entrado en" : "salido de"} paro")
		edificio.paro = paro
		if array_length(edificio.trabajadores) < edificio.trabajadores_max{
			if paro
				array_remove(trabajo_educacion[edificio_trabajo_educacion[edificio.tipo]], edificio, "edificio se va a paro y ya no está disponible")
			else
				array_push(trabajo_educacion[edificio_trabajo_educacion[edificio.tipo]], edificio)
		}
	}
}
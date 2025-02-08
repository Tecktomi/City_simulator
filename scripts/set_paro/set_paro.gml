function set_paro(paro, edificio = control.null_edificio){
	with control{
		edificio.paro = paro
		if array_length(edificio.trabajadores) < edificio_trabajadores_max[edificio.tipo]
			if paro
				array_remove(trabajo_educacion[edificio_trabajo_educacion[edificio.tipo]], edificio)
			else
				array_push(trabajo_educacion[edificio_trabajo_educacion[edificio.tipo]], edificio)
	}
}
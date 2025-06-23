function set_trabajadores_max(numero, edificio = control.null_edificio){
	with control{
		edificio.trabajadores_max = numero
		while array_length(edificio.trabajadores) > numero
			cambiar_trabajo(edificio.trabajadores[0], null_edificio)
		if edificio.trabajadores_max_allow > numero
			edificio.trabajadores_max_allow = numero
	}
}
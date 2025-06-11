function set_escuela_clientes_max(cantidad, escuela = control.null_edificio){
	with control{
		escuela.servicio_max = cantidad
		while array_length(escuela.clientes) > cantidad
			buscar_escuela(array_pop(escuela.clientes))
	}
}
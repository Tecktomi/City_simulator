function set_carcel_cantidad(edificio = control.null_edificio){
	with control{
		edificio.servicio_max = edificio.count * array_length(edificio.trabajadores)
		while array_length(edificio.clientes) > edificio.servicio_max
			arrestar_persona(array_pop(edificio.clientes), array_pop(edificio.array_complex).a)
	}
}
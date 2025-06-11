function set_escuela_servicio_max(educacion, escuela = control.null_edificio){
	with control{
		escuela.escuela_max = educacion
		for(var a = 0; a < array_length(escuela.clientes); a++)
			if escuela.clientes[a].educacion > educacion
				buscar_escuela(escuela.clientes[a--])
	}
}
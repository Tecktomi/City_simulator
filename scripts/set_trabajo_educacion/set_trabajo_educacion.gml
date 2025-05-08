function set_trabajo_educacion(educacion, edificio = control.null_edificio){
	if educacion > edificio.trabajo_educacion
		with control{
			if array_contains(trabajo_educacion[edificio.trabajo_educacion], edificio){
				array_remove(trabajo_educacion[edificio.trabajo_educacion], edificio)
				array_push(trabajo_educacion[educacion], edificio)
			}
			for(var a = 0; a < array_length(edificio.trabajadores); a++)
				if edificio.trabajadores[a].educacion < educacion
					cambiar_trabajo(edificio.trabajadores[a--], null_edificio)
			for(var a = 0; a < array_length(edificio.casas_cerca); a++){
				var casa = edificio.casas_cerca[a]
				array_remove(casa.trabajos_cerca[edificio.trabajo_educacion], edificio)
				array_push(casa.trabajos_cerca[educacion], edificio)
			}
			edificio.trabajo_educacion = educacion
		}
}
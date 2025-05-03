function set_mantenimiento(mantenimiento, edificio = control.null_edificio){
	with control{
		array_remove(edificios_por_mantenimiento[min(20, edificio.mantenimiento)], edificio)
		edificio.mantenimiento = max(0, real(mantenimiento))
		array_push(edificios_por_mantenimiento[min(20, edificio.mantenimiento)], edificio)
	}
}
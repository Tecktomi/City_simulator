function add_mantenimiento(mantenimiento, edificio = control.null_edificio){
	set_mantenimiento(edificio.mantenimiento + mantenimiento, edificio)
}
function add_contaminacion(cont, edificio = control.null_edificio){
	show_debug_message(0)
	remove_contaminacion(edificio)
	edificio.contaminacion += real(cont)
	set_contaminacion(edificio)
}
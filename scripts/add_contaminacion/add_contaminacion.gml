function add_contaminacion(cont, edificio = control.null_edificio){
	remove_contaminacion(edificio)
	edificio.contaminacion += real(cont)
	set_contaminacion(edificio)
}
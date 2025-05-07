function add_contaminacion(cont, edificio = control.null_edificio){
	remove_contaminacion(edificio)
	edificio.contaminacion += cont
	add_contaminacion(edificio)
}
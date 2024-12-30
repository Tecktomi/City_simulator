function array_remove(array, value){
	var a = array_get_index(array, value)
	if a = -1
		show_error("Error en array_remove", true)
	array_delete(array, a, 1)
}
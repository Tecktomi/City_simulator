function array_remove(array, value, from = ""){
	var a = 0
	if is_array(value){
		for(var b = 0; b < array_length(array); b++)
			if array_equals(array[b], value){
				a = b
				break
			}
	}
	else
		a = array_get_index(array, value)
	if a = -1{
		show_debug_message(from)
		show_debug_message(typeof(array))
		show_debug_message(string_struct_begin(array))
		show_debug_message("--------------------------------------------")
		show_debug_message(typeof(value))
		show_debug_message(string_struct_begin(value))
		show_error("Error en array_remove", true)
	}
	array_delete(array, a, 1)
	return a
}
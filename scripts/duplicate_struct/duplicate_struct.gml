function duplicate_struct(struct){
	var names = struct_get_names(struct)
	var len = array_length(names)
	var new_struct = {}
	for(var a = 0; a < len; a++)
		struct_set(new_struct, names[a], struct_get(struct, names[a]))
	return new_struct
}
function my_get_string(title = "", def = "", funcion = function(){}, param = []){
	with control{
		getstring = true
		getstring_title = title
		getstring_default = def
		keyboard_string = def
		getstring_function = funcion
		getstring_param = param
	}
}
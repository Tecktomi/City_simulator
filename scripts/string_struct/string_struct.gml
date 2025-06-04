function string_struct(struct, b = 0){
	if b >= 3
		return "..."
	if not is_struct(struct){
		if not is_array(struct){
			if not is_bool(struct)
				return string(struct)
			else
				if struct
					return "True"
				else
					return "False"
		}
		else{
			var len = array_length(struct)
			if len = 0
				return "[]"
			var text = "["
			for(var a = 0; a < len; a++){
				if is_struct(struct[a]){
					if array_contains(global.stack, struct)
						text += "..."
					else{
						array_push(global.stack, struct)
						text += string_struct(struct[a], b + 1)
					}
				}
				else
					if not is_bool(struct[a])
						text += string(struct[a])
					else
						if struct[a]
							text += "True"
						else
							text += "False"
				if a < len - 1
					text += ", "
			}
			return text + "]"
		}
	}
	else{
		if struct = control.null_persona
			return string_repeat(" ", b) + "null_persona"
		else if struct = control.null_edificio
			return string_repeat(" ", b) + "null_edificio"
		else if struct = control.null_familia
			return string_repeat(" ", b) + "null_familia"
		else if struct = control.null_empresa
			return string_repeat(" ", b) + "null_empresa"
		else if struct = control.null_relacion
			return string_repeat(" ", b) + "null_relacion"
		else if struct = control.null_construccion
			return string_repeat(" ", b) + "null_construccion"
		else if struct = control.null_carretera
			return string_repeat(" ", b) + "null_carretera"
		else if array_contains(global.stack, struct)
			return string_repeat(" ", b) + "..."
		else{
			array_push(global.stack, struct)
			var text = "{\n"
			var names = struct_get_names(struct)
			var len = array_length(names)
			for(var a = 0; a < len; a++)
				text += string_repeat(" ", b * 2) + names[a] + ": " + string_struct(struct_get(struct, names[a]), b + 1) + "\n"
			return text + string_repeat(" ", b * 2) + "}"
		}
	}
}
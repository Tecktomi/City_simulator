function string_struct(struct, b = 0){
	if b >= 10
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
		if array_contains(global.stack, struct)
			return string_repeat(" ", b) +  "..."
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
function add_industria_io(edificio = control.null_edificio, input_id = [], input_num = [], output_id = [], output_num = []){
	with control{
		for(var a = 0; a < array_length(input_id); a++){
			var c = input_id[a], flag = false
			for(var b = 0; b < array_length(edificio.input_id); b++)
				if c = edificio.input_id[b]{
					edificio.input_num[b] += real(input_num[a])
					if edificio.input_num[b] <= 0{
						array_delete(edificio.input_id, b, 1)
						array_delete(edificio.input_num, b, 1)
					}
					flag = true
					break
				}
			if not flag{
				array_push(edificio.input_id, c)
				array_push(edificio.input_num, real(input_num[a]))
			}
		}
		for(var a = 0; a < array_length(output_id); a++){
			var c = output_id[a], flag = false
			for(var b = 0; b < array_length(edificio.output_id); b++)
				if c = edificio.output_id[b]{
					edificio.output_num[b] += real(output_num[a])
					if edificio.output_num[b] <= 0{
						array_delete(edificio.output_id, b, 1)
						array_delete(edificio.output_num, b, 1)
					}
					flag = true
					break
				}
			if not flag{
				array_push(edificio.output_id, c)
				array_push(edificio.output_num, real(output_num[a]))
			}
		}
	}
}
function set_industria_io(edificio = control.null_edificio, input_id = [0], input_num = [0], output_id = [0], output_num = [0]){
	with control{
		for(var a = 0; a < array_length(edificio.input_id); a++){
			var b = edificio.input_id[a]
			if not array_contains(input_id, b){
				edificio.ganancia += recurso_precio[b] * edificio.almacen[b]
				add_encargo(b, edificio.almacen[b], edificio)
				edificio.almacen[b] = 0
			}
		}
		edificio.input_id = input_id
		edificio.input_num = input_num
		edificio.output_id = output_id
		edificio.output_num = output_num
	}
}
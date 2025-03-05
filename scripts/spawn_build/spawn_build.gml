function spawn_build(var_checked, index, times = 1){
	var coord, edificio;
	with control
		repeat(times){
			do coord = array_shift(var_checked)
			until array_length(var_checked) = 0 or edificio_valid_place(coord.x, coord.y, index)
			if array_length(var_checked) > 0
				edificio = add_edificio(coord.x, coord.y, index)
		}
	return edificio
}
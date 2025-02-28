function spawn_build(var_checked, index, times = 1){
	var coord;
	with control{
		repeat(times){
			do coord = array_shift(var_checked)
			until array_length(var_checked) = 0 or edificio_valid_place(coord.x, coord.y, index)
			add_edificio(coord.x, coord.y, index)
		}
	}
}
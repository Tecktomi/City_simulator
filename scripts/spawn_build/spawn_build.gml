function spawn_build(checked, index, times = 1){
	var coord;
	with control{
		repeat(times){
			do coord = array_shift(checked)
			until array_length(checked) = 0 or edificio_valid_place(coord.x, coord.y, index)
			add_edificio(coord.x, coord.y, index)
		}
	}
	return checked
}
function min_array(array){
	var b = array[0]
	for(var a = 1; a < array_length(array); a++)
		b = min(b, array[a])
	return b
}
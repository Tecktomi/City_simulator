function calcular_felicidad(array = [0]){
	var b = 0, c = 100
	for(var a = 1; a < array_length(array); a++){
		b += real(array[a])
		c = min(c, array[a])
	}
	return floor((b + c) / (1 + array_length(array)))
}
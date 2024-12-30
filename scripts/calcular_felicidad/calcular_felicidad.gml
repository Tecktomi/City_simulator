function calcular_felicidad(felicidad){
	var b = 0, c = 100
	for(var a = 1; a < argument_count; a++){
		b += real(argument[a])
		if real(argument[a]) < c
			c = real(argument[a])
	}
	return floor((real(felicidad) + (b + 2 * c) / (argument_count + 1)) / 2)
}
function calcular_felicidad_transporte(trabajo = control.null_edificio, casa = control.null_edificio){
	return 10000 / (100 + 3 * distancia(casa, trabajo))
}
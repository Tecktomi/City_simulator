function add_exigencia(tipo, target = [control.null_edificio]){
	var exigencia = {
		index : real(tipo),
		expiracion : control.dia + 365,
		value : 0,
		edificios : target
	}
	control.exigencia_pedida[tipo] = true
	control.exigencia[tipo] = exigencia
	return exigencia
}
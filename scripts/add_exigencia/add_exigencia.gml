function add_exigencia(tipo, target = [control.null_edificio]){
	var exigencia = {
		index : real(tipo),
		expiracion : dia + 360,
		value : 0,
		edificios : target
	}
	if tipo = 2
		exigencia.expiracion = dia + 100
	control.exigencia_pedida[tipo] = true
	control.exigencia[tipo] = exigencia
	return exigencia
}
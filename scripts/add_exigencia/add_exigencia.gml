function add_exigencia(tipo, target = [control.null_edificio]){
	with control{
		var exigencia = {
			index : real(tipo),
			expiracion : dia + 365,
			value : 0,
			edificios : target
		}
		if tipo = 2
			exigencia.expiracion = dia + 100
		exigencia_pedida[tipo] = true
		exigencia[tipo] = exigencia
		return exigencia
	}
}
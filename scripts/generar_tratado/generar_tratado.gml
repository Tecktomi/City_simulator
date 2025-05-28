function generar_tratado(){
	with control{
		var pais = pais_current[irandom_range(1, array_length(pais_current) - 1)], a = 0, b = random(1)
		do{
			for(a = 0; a < array_length(pais.recursos); a++){
				b -= abs(pais.recursos[a])
				if b < 0
					break
			}
		}
		until array_contains(recurso_current, a)
		var temp_precio = recurso_precio[a], c = power(10, floor(log10(1000 / temp_precio))), flag = (1 - 2 * (pais.recursos[a] < 0))
		var tratado = {
			pais: pais,
			recurso : a,
			cantidad : flag * floor(irandom_range(2500, 5000) / temp_precio / c) * c,
			factor : random_range(1.1, 1.3),
			tiempo : irandom_range(60, 96),
			tipo : flag
		}
		if debug
			show_debug_message($"{fecha(dia)} generar_tratado({tratado.cantidad} de {recurso_nombre[tratado.recurso]} a {pais.nombre})")
		array_push(tratados_ofertas, tratado)
		return tratado
	}
}
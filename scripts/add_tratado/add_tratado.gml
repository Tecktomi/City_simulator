function add_tratado(pais, recurso, cantidad, factor, tiempo){
	var tratado = {
		pais : real(pais),
		recurso : real(recurso),
		cantidad : real(cantidad),
		factor : real(factor),
		tiempo : real(tiempo)
	}
	array_push(control.recurso_tratados[recurso], tratado)
	array_sort(control.recurso_tratados[recurso], function(a, b){return a.factor > b.factor})
	return tratado
}
function add_tratado_oferta(){
	var a = irandom(array_length(control.recurso_nombre) - 1)
	var tratado = {
		pais: irandom_range(1, array_length(control.pais_nombre) - 1),
		recurso : a,
		cantidad : 100 * irandom_range(floor(10 / control.recurso_precio[a]), floor(25 / control.recurso_precio[a])),
		factor : random_range(1.1, 1.3),
		tiempo : irandom_range(60, 96)
	}
	array_push(control.tratados_ofertas, tratado)
	return tratado
}
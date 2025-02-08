function add_tratado(pais, recurso, cantidad, factor, tiempo){
	with control{
		var tratado = {
			pais : real(pais),
			recurso : real(recurso),
			cantidad : real(cantidad),
			factor : real(factor),
			tiempo : real(tiempo)
		}
		array_push(recurso_tratados[recurso], tratado)
		array_sort(recurso_tratados[recurso], function(a, b){return a.factor > b.factor})
		return tratado
	}
}
function add_tratado_oferta(){
	with control{
		var a = irandom(array_length(recurso_nombre) - 1)
		var tratado = {
			pais: irandom_range(1, array_length(pais_nombre) - 1),
			recurso : a,
			cantidad : 100 * max(2, irandom_range(floor(15 / recurso_precio[a]), floor(40 / recurso_precio[a]))),
			factor : random_range(1.1, 1.3),
			tiempo : irandom_range(60, 96)
		}
		array_push(tratados_ofertas, tratado)
		return tratado
	}
}
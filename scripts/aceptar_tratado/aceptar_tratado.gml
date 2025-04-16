function aceptar_tratado(pais, recurso, cantidad, factor, tiempo){
	with control{
		var tratado = {
			pais : real(pais),
			recurso : real(recurso),
			cantidad : abs(real(cantidad)),
			factor : real(factor),
			tiempo : real(tiempo),
			tipo : (cantidad > 0)
		}
		if cantidad > 0{
			array_push(recurso_tratados_venta[recurso], tratado)
			array_sort(recurso_tratados_venta[recurso], function(a, b){return a.factor > b.factor})
		}
		else{
			recurso_importado[recurso] += abs(real(cantidad))
			array_push(recurso_tratados_compra[recurso], tratado)
			array_sort(recurso_tratados_compra[recurso], function(a, b){return a.factor > b.factor})
		}
		return tratado
	}
}
function aceptar_tratado(recurso, cantidad, factor, tiempo, pais = control.null_pais){
	with control{
		var tratado = {
			pais : pais,
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
			recurso_importado_fijo[recurso] += abs(real(cantidad))
			array_push(recurso_tratados_compra[recurso], tratado)
			array_sort(recurso_tratados_compra[recurso], function(a, b){return a.factor > b.factor})
		}
		tratados_num++
		return tratado
	}
}
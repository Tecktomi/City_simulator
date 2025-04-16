function add_encargo(recurso, cantidad, edificio = control.null_edificio){
	with control{
		if debug
			show_debug_message($"{fecha(dia)} add_encargo({recurso_nombre[recurso]})")
		if cantidad != 0{
			var encargo = {
				recurso : real(recurso),
				cantidad : floor(cantidad),
				edificio : edificio
			}
			array_push(encargos, encargo)
			if edificio.privado{
				var a = floor(recurso_precio[recurso] * cantidad)
				dinero -= a
				dinero_privado += a
				edificio.empresa.dinero += a
				if cantidad > 0{
					mes_compra_interna[current_mes] += a
					array_add(mes_compra_recurso[current_mes], recurso, a)
					array_add(mes_compra_recurso_num[current_mes], recurso, cantidad)
				}
				else{
					mes_venta_interna[current_mes] -= a
					array_add(mes_venta_recurso[current_mes], recurso, -a)
					array_add(mes_venta_recurso_num[current_mes], recurso, -cantidad)
				}
			}
		}
	}
}
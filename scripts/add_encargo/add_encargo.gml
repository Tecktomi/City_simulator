function add_encargo(recurso, cantidad, edificio = control.null_edificio){
	with control{
		if cantidad != 0{
			var encargo = {
				recurso : real(recurso),
				cantidad : real(cantidad),
				edificio : edificio
			}
			array_push(encargos, encargo)
			if edificio.privado{
				dinero -= floor(recurso_precio[recurso] * cantidad)
				if cantidad > 0
					mes_compra_interna[current_mes] += floor(recurso_precio[recurso] * cantidad)
				else
					mes_venta_interna[current_mes] -= floor(recurso_precio[recurso] * cantidad)
			}
		}
	}
}
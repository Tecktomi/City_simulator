function add_encargo(recurso, cantidad, edificio = control.null_edificio, estatal = false){
	var encargo = {
		recurso : real(recurso),
		cantidad : real(cantidad),
		edificio : edificio
	}
	with control{
		array_push(encargos, encargo)
		if not estatal{
			dinero -= floor(recurso_precio[recurso] * cantidad)
			mes_compra_interna[current_mes] += floor(recurso_precio[recurso] * cantidad)
		}
	}
}
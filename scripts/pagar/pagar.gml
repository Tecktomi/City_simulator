function pagar(cantidad, edificio = control.null_edificio, ganancia = true){
	with control{
		if edificio = null_edificio{
			dinero += cantidad
			return abs(cantidad)
		}
		if ganancia
			edificio.ganancia += cantidad
		else
			edificio.precio += abs(cantidad)
		if edificio.privado{
			dinero_privado += cantidad
			edificio.empresa.dinero += cantidad
			return 0
		}
		dinero += cantidad
		return abs(cantidad)
	}
}
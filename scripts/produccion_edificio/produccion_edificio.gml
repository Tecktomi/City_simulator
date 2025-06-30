function produccion_edificio(recurso, edificio = control.null_edificio, base = 0){
	with control{
		edificio.ganancia += recurso_precio[recurso] * (edificio.almacen[recurso] - base)
		add_encargo(recurso, (edificio.almacen[recurso] - base), edificio)
		edificio.almacen[recurso] = base
	}
}
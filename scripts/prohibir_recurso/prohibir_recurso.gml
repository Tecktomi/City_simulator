function prohibir_recurso(recurso, edificios_prohibidos = [35]){
	with control{
		for(var a = 0; a < array_length(recurso_lujo); a++)
			if recurso_lujo[a] = recurso{
				array_delete(recurso_lujo, a, 1)
				array_delete(recurso_lujo_probabilidad, a, 1)
				break
			}
		for(var a = 0; a < array_length(edificios_prohibidos); a++)
			for(var b = 0; b < array_length(edificio_count[edificios_prohibidos[a]]); b++){
				var edificio = edificio_count[edificios_prohibidos[a], b]
				edificio.ganancia += edificio.almacen[recurso] + edificio.pedido[recurso]
				add_encargo(recurso, edificio.almacen[recurso], edificio)
				edificio.pedido[recurso] = 0
				edificio.almacen[recurso] = 0
			}
		for(var a = 0; a < array_length(encargos); a++){
			var encargo = encargos[a]
			if encargo.recurso = recurso and array_contains(edificios_prohibidos, encargo.edificio.tipo) and encargo.cantidad < 0
				array_delete(encargos, a--, 1)
		}
	}
}
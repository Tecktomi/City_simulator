function destroy_empresa(empresa = control.null_empresa){
	with control{
		for(var a = 0; a < array_length(empresa.edificios); a++){
			var edificio = empresa.edificios[a], width = edificio_width[edificio.tipo], height = edificio_height[edificio.tipo]
			edificio.empresa = null_empresa
			set_paro(true, edificio)
			if edificio.rotado{
				var b = width
				width = height
				height = width
			}
			var venta = {
				edificio : edificio,
				precio : edificio_precio[edificio.tipo],
				width : width,
				height : height,
				estatal : false
			}
			array_push(edificios_a_la_venta, venta)
		}
		if empresa.nacional{
			empresa.jefe.empresa = null_empresa
			dinero += empresa.dinero
		}
		array_remove(empresas, empresa, "eliminar empresa")
		if sel_build and ministerio = 7
			close_show()
	}
}
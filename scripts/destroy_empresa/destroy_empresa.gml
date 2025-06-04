function destroy_empresa(empresa = control.null_empresa){
	with control{
		for(var a = 0; a < array_length(empresa.ventas); a++){
			var venta = empresa.ventas[a]
			venta.empresa = null_empresa
		}
		for(var a = 0; a < array_length(empresa.edificios); a++){
			var edificio = empresa.edificios[a], width = edificio.width, height = edificio.height, complex_2 = valorizar_edificio(edificio), temp_precio = complex_2.int
			edificio.empresa = null_empresa
			set_paro(true, edificio)
			var venta = {
				edificio : edificio,
				precio : temp_precio,
				width : width,
				height : height,
				estatal : false,
				empresa : null_empresa
			}
			array_push(edificios_a_la_venta, venta)
			edificio.venta = true
		}
		for(var a = 0; a < array_length(empresa.terreno); a++){
			var complex =  empresa.terreno[a]
			if bool_edificio[# complex.a, complex.b]
				array_delete(empresa.terreno, a--, 1)
			else{
				array_set(zona_privada[complex.a], complex.b, false)
				array_set(zona_empresa[complex.a], complex.b, null_empresa)
			}
		}
		if empresa.nacional{
			empresa.jefe.empresa = null_empresa
			dinero += empresa.dinero
		}
		array_remove(dia_empresas[empresa.dia_factura], empresa, "Eliminar la empresa de su día de factura")
		array_remove(empresas, empresa, "eliminar empresa")
		if sel_build and ministerio = 7
			close_show()
	}
}
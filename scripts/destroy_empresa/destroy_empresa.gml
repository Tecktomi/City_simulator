function destroy_empresa(empresa = control.null_empresa){
	with control{
		for(var a = 0; a < array_length(empresa.edificios); a++){
			var edificio = empresa.edificios[a]
			edificio.empresa = null_empresa
			set_paro(true, edificio)
		}
		if empresa.nacional{
			empresa.jefe.empresa = null_empresa
			dinero += empresa.dinero
		}
		array_remove(empresas, empresa)
	}
}
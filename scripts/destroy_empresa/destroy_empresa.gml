function destroy_empresa(empresa = control.null_empresa){
	with control{
		dinero += empresa.dinero
		for(var a = 0; a < array_length(empresa.edificios); a++)
			set_paro(true, empresa.edificios[a])
		array_remove(empresas, empresa)
	}
}
function add_empresa(inversion, persona = control.null_persona){
	with control{
		var empresa = {
			jefe : persona,
			dinero : inversion,
			edificios : [null_edificio]
		}
		persona.empresa = empresa
		persona.familia.riqueza -= inversion
		array_pop(empresa.edificios)
		array_push(empresas, empresa)
		return empresa
	}
}
function add_empresa(inversion, nacional = false, persona = control.null_persona){
	with control{
		var empresa = {
			jefe : persona,
			dinero : inversion,
			edificios : [null_edificio],
			nacional : nacional
		}
		if nacional{
			persona.empresa = empresa
			persona.familia.riqueza -= inversion
		}
		array_pop(empresa.edificios)
		array_push(empresas, empresa)
		return empresa
	}
}
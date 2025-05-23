function add_empresa(inversion, nacional = false, persona = control.null_persona){
	with control{
		var empresa = {
			jefe : persona,
			dinero : inversion,
			edificios : [null_edificio],
			nacional : nacional,
			nombre : "",
			quiebra : false,
			dia_factura : irandom(29),
			terreno : [{a : 0, b : 0}],
			ventas : [null_venta],
			construcciones : [null_construccion]
		}
		array_pop(empresa.terreno)
		array_pop(empresa.ventas)
		array_pop(empresa.construcciones)
		if nacional{
			persona.empresa = empresa
			persona.familia.riqueza -= inversion
			empresa.nombre = $"{persona.apellido} {choose("Ldta.", "S.A.", "Hmns.", "Corp.", "Asociados")}"
		}
		else
			empresa.nombre = gen_nombre_empresa()
		array_push(dia_empresas[empresa.dia_factura], empresa)
		array_pop(empresa.edificios)
		array_push(empresas, empresa)
		return empresa
	}
}
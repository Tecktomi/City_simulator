function for_familia(funcion, familia = control.null_familia, hijos = true, valores = undefined){
	if familia.padre != null_persona
		funcion(familia.padre, valores)
	if familia.integrantes > 0 and familia.madre != null_persona
		funcion(familia.madre, valores)
	if hijos and familia.integrantes > 0
		for(var a = 0; a < array_length(familia.hijos); a++)
			funcion(familia.hijos[a], valores)
}
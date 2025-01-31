function name(persona = control.null_persona){
	return persona.nombre + " " + persona.apellido
}
function name_familia(familia = control.null_familia){
	if familia.padre != control.null_persona and familia.madre != control.null_persona
		return $"Familia {familia.padre.apellido} {familia.madre.apellido}"
	else{
		if familia.madre != control.null_persona
			return $"Familia {familia.madre.apellido}"
		else if familia.padre != control.null_persona
			return $"Familia {familia.padre.apellido}"
		else
			return "Sin familia"
	}
}
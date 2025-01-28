function print_familia(familia = control.null_familia){
	var text = ""
	if familia.padre != null_persona
		text += "Padre: " + name(familia.padre) + "\n"
	else
		text += "Sin padre\n"
	if familia.madre != null_persona
		text += "Madre: " + name(familia.madre) + "\n"
	else
		text += "Sin madre\n"
	if array_length(familia.hijos) = 0
		text += "Sin hijos\n"
	else
		for(var a = 0; a < array_length(familia.hijos); a++)
			text += "Hijo " + string(a) + ") " + name(familia.hijos[a]) + "\n"
	text += "Viven en " + control.edificio_nombre[familia.casa.tipo]
	return text
}
function buscar_casa(persona = control.null_persona){
	var casa = control.homeless
	if (persona.familia.padre = control.null_persona or persona.familia.padre.trabajo = control.null_edificio or persona.familia.padre.trabajo = control.jubilado) and (persona.familia.madre = control.null_persona or persona.familia.madre.trabajo = control.null_edificio or persona.familia.madre.trabajo = control.jubilado)
		casa = control.casas[irandom(array_length(control.casas) - 1)]
	else if array_length(persona.trabajo.casas_cerca) > 0
		casa = persona.trabajo.casas_cerca[irandom(array_length(persona.trabajo.casas_cerca) - 1)]
	if casa != control.homeless and casa != persona.familia.casa and array_length(casa.familias) < control.edificio_familias_max[casa.tipo] and (persona.familia.sueldo - array_length(persona.familia.hijos)) >= control.edificio_familias_renta[casa.tipo] and control.edificio_familias_calidad[casa.tipo] > control.edificio_familias_calidad[persona.familia.casa.tipo]{
		cambiar_casa(persona.familia, casa)
		return true
	}
	return false
}
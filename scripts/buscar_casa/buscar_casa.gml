function buscar_casa(persona = control.null_persona){
	with control{
		if array_length(casas_libres) > 0{
			var casa = homeless
			if (persona.familia.padre = null_persona or persona.familia.padre.trabajo = null_edificio or persona.familia.padre.trabajo = jubilado) and (persona.familia.madre = null_persona or persona.familia.madre.trabajo = null_edificio or persona.familia.madre.trabajo = jubilado)
				casa = casas_libres[irandom(array_length(casas_libres) - 1)]
			else if array_length(persona.trabajo.casas_cerca) > 0
				casa = persona.trabajo.casas_cerca[irandom(array_length(persona.trabajo.casas_cerca) - 1)]
			if casa != homeless and casa != persona.familia.casa and array_length(casa.familias) < edificio_familias_max[casa.tipo] and (persona.familia.sueldo - persona.familia.integrantes) >= edificio_familias_renta[casa.tipo] and casa.vivienda_calidad > persona.familia.casa.vivienda_calidad{
				cambiar_casa(persona.familia, casa)
				return true
			}
		}
		return false
	}
}
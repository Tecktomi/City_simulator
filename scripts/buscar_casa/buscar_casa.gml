function buscar_casa(persona = control.null_persona){
	with control{
		if array_length(casas_libres) > 0{
			var casa = homeless, familia = persona.familia
			if (familia.padre = null_persona or in(familia.padre.trabajo, null_edificio, jubilado, delincuente)) and (familia.madre = null_persona or in(familia.madre.trabajo, null_edificio, jubilado, delincuente))
				casa = casas_libres[irandom(array_length(casas_libres) - 1)]
			else if array_length(persona.trabajo.casas_cerca) > 0
				casa = persona.trabajo.casas_cerca[irandom(array_length(persona.trabajo.casas_cerca) - 1)]
			if casa != homeless and casa != familia.casa and array_length(casa.familias) < edificio_familias_max[casa.tipo] and (familia.sueldo - familia.integrantes + max(0, familia.riqueza / 60)) >= edificio_familias_renta[casa.tipo] and casa.vivienda_calidad > familia.casa.vivienda_calidad{
				cambiar_casa(familia, casa)
				return true
			}
		}
		return false
	}
}
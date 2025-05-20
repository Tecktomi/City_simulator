function buscar_casa(persona = control.null_persona){
	with control{
		if array_length(casas_libres) > 0{
			var casa = homeless, familia = persona.familia
			if (familia.padre = null_persona or in(familia.padre.trabajo, null_edificio, jubilado, delincuente, prostituta)) and (familia.madre = null_persona or in(familia.madre.trabajo, null_edificio, jubilado, delincuente, prostituta))
				casa = array_pick(casas_libres)
			else if array_length(persona.trabajo.casas_cerca) > 0
				casa = array_pick(persona.trabajo.casas_cerca)
			var a = 0, b = 0
			if not in(persona.trabajo, null_edificio, jubilado, delincuente, prostituta){
				a = calcular_felicidad_transporte(casa, persona.trabajo)
				b = calcular_felicidad_transporte(familia.casa, persona.trabajo)
			}
			if persona.pareja != null_persona and not in(persona.pareja.trabajo, null_edificio, jubilado, delincuente, prostituta){
				a += calcular_felicidad_transporte(casa, persona.pareja.trabajo)
				b += calcular_felicidad_transporte(familia.casa, persona.pareja.trabajo)
			}
			if casa != homeless and casa != familia.casa and array_length(casa.familias) < edificio_familias_max[casa.tipo] and (familia.sueldo - ((ley_eneabled[4] and (familia.padre.religion or familia.madre.religion or ley_eneabled[16])) ? 0 : familia.integrantes) + ((ley_eneabled[9] and (familia.padre.religion or familia.madre.religion or ley_eneabled[16])) ? array_length(familia.hijos) : 0) + max(0, familia.riqueza / 30)) >= casa.vivienda_renta and (casa.vivienda_calidad + a) > (familia.casa.vivienda_calidad + b){
				cambiar_casa(familia, casa)
				return true
			}
		}
		return false
	}
}
function buscar_atencion_medica(persona = control.null_persona){
	with control{
		if array_length(medicos) > 1{
			var medico = medicos[irandom_range(1, array_length(medicos) - 1)]
			if array_length(medico.clientes) < medico.servicio_max{
				if debug
					show_debug_message(fecha(dia) + $" buscar_atencion_medica ({name(persona)}) -> ({medico.nombre})")
				array_push(medico.clientes, persona)
				persona.medico = medico
				return true
			}
		}
		if debug
			show_debug_message(fecha(dia) + $" buscar_atencion_medica ({name(persona)}) -> (Desausiado)")
		array_push(desausiado.clientes, persona)
		persona.medico = desausiado
		return false
	}
}
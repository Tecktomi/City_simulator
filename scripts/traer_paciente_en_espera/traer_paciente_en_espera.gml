function traer_paciente_en_espera(medico = control.null_edificio){
	with control{
		if array_length(desausiado.clientes) > 0{
			var persona = array_shift(desausiado.clientes)
			if debug
				show_debug_message(fecha(dia) + $" traer_paciente_en_espera ({name(persona)})")
			array_push(medico.clientes, persona)
			persona.medico = medico
		}
	}
}
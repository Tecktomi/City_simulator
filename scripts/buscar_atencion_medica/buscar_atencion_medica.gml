function buscar_atencion_medica(persona = control.null_persona){
	with control{
		if array_length(medicos) > 1{
			var medico = medicos[irandom_range(1, array_length(medicos) - 1)]
			if array_length(medico.clientes) < edificio_clientes_max[medico.tipo]{
				array_push(medico.clientes, persona)
				persona.medico = medico
				return true
			}
		}
		array_push(desausiado.clientes, persona)
		persona.medico = desausiado
		return false
	}
}
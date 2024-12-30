function buscar_atencion_medica(persona = control.null_persona){
	if array_length(control.medicos) > 1{
		var medico = control.medicos[irandom_range(1, array_length(medicos) - 1)]
		if array_length(medico.clientes) < control.edificio_clientes_max[medico.tipo]{
			array_push(medico.clientes, persona)
			persona.medico = medico
		}
	}
	else{
		array_push(control.desausiado.clientes, persona)
		persona.medico = control.desausiado
	}
}
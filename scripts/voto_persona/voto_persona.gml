function voto_persona(persona = control.null_persona){
	with control{
		if persona.edad > 18 and not persona.candidato and (ley_eneabled[10] or (not persona.sexo and persona.educacion > 0)){
			var c = 0, p_ec = persona.politica_economia, p_sc = persona.politica_sociocultural, d = sqrt(sqr(p_ec - politica_economia) + sqr(p_sc - politica_sociocultural)) / sqrt(clamp((persona.felicidad + persona.felicidad_temporal) / felicidad_minima, 0, 2))
			for(var b = 0; b < array_length(candidatos); b++){
				var candidato = candidatos[b], c_ec = candidato.politica_economia, c_sc = candidato.politica_sociocultural, dis = sqrt(sqr(p_ec - c_ec) + sqr(p_sc - c_sc)) / candidato.candidato_popularidad
				if dis < d{
					d = dis
					c = b + 1
				}
			}
			return c
		}
		return -1
	}
}
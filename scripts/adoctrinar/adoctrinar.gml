function adoctrinar(persona = control.null_persona){
	with control{
		persona.politica_economia = (20 * persona.politica_economia + adoctrinamiento * politica_economia) / (20 + adoctrinamiento)
		persona.politica_sociocultural = (20 * persona.politica_sociocultural + adoctrinamiento * politica_sociocultural) / (20 + adoctrinamiento)
	}
}
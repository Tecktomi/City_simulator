function add_felicidad_ley(persona = control.null_persona, valor = 0){
	if persona != control.null_persona
		persona.felicidad_ley = min(100, max(0, persona.felicidad_ley + valor))
}
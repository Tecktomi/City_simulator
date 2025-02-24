function add_felicidad_ley(persona = control.null_persona, valor = 0){
	if persona != control.null_persona
		persona.felicidad_ley = clamp(persona.felicidad_ley + valor, 0, 100)
}
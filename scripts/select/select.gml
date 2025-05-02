function select(edificio = control.null_edificio, familia = control.null_familia, persona = control.null_persona, construccion = control.null_construccion, terreno = control.null_terreno){
	with control{
		close_show()
		sel_build = false
		sel_info = true
		sel_edificio = null_edificio
		sel_familia = null_familia
		sel_persona = null_persona
		sel_construccion = null_construccion
		if edificio != null_edificio{
			sel_tipo = 0
			sel_edificio = edificio
		}
		if familia != null_familia{
			sel_tipo = 1
			sel_familia = familia
		}
		if persona != null_persona{
			sel_tipo = 2
			sel_persona = persona
		}
		if construccion != null_construccion{
			sel_tipo = 3
			sel_construccion = construccion
		}
		if terreno != null_terreno{
			sel_tipo = 4
			sel_terreno = terreno
		}
		return false
	}
}
function add_persona(){
	var a = brandom()
	var persona = {
		familia : control.null_familia,
		trabajo : control.null_edificio,
		pareja : control.null_persona,
		sexo : a,
		nombre : gen_nombre(a),
		apellido : gen_apellido(),
		cumple : irandom(354),
		edad : irandom_range(20, 50),
		embarazo : -1,
		muerte : -1,
		felicidad : 50,
		felicidad_trabajo : 50,
		felicidad_educacion : 50,
		felicidad_salud : 50,
		felicidad_ocio : 50,
		felicidad_transporte : 50,
		felicidad_religion : 50,
		felicidad_ley : 50,
		educacion : 0,
		escuela : control.null_edificio,
		medico : control.null_edificio,
		ocios : [],
		es_hijo : false,
		nacionalidad : 0,
		religion : false,
		relacion : {
			padre : control.null_relacion,
			madre : control.null_relacion,
			hijos : [],
			vivo : true,
			persona: undefined,
			nombre : "",
			sexo : a
			
		}
	}
	
	array_push(control.null_edificio.trabajadores, persona)
	array_push(control.personas, persona)
	array_push(control.cumples[persona.cumple], persona)
	control.felicidad_total = (control.felicidad_total * (array_length(control.personas) - 1) + 50) / array_length(control.personas)
	for(var b = 0; b < array_length(control.edificio_nombre); b++)
		if control.edificio_es_ocio[b]
			array_push(persona.ocios, b)
	persona.relacion.persona = persona
	persona.relacion.nombre = name(persona)
	return persona
}
function add_persona(){
	with control{
		var a = brandom()
		var persona = {
			familia : null_familia,
			trabajo : null_edificio,
			pareja : null_persona,
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
			escuela : null_edificio,
			medico : null_edificio,
			ocios : [],
			es_hijo : false,
			nacionalidad : 0,
			religion : false,
			relacion : {
				padre : null_relacion,
				madre : null_relacion,
				hijos : [],
				vivo : true,
				persona: undefined,
				nombre : "",
				sexo : a
			
			}
		}
	
		array_push(null_edificio.trabajadores, persona)
		array_push(personas, persona)
		array_push(cumples[persona.cumple], persona)
		felicidad_total = (felicidad_total * (array_length(personas) - 1) + 50) / array_length(personas)
		for(var b = 0; b < array_length(edificio_nombre); b++)
			if edificio_es_ocio[b]
				array_push(persona.ocios, b)
		persona.relacion.persona = persona
		persona.relacion.nombre = name(persona)
		return persona
	}
}
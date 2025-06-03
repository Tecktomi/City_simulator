function add_familia(origen = null_pais, generada = true){
	with control{
		var familia = {
			padre : null_persona,
			madre : null_persona,
			hijos : [null_persona],
			casa : homeless,
			sueldo : 0,
			felicidad_vivienda : 50,
			felicidad_alimento : 50,
			riqueza : irandom_range(30, 50),
			integrantes : 1,
			index : ++familia_count,
			banco : false
		}
		array_pop(familia.hijos)
		if generada{
			var persona = add_persona()
			persona.familia = familia
			persona.educacion = sqr(random(2.1))
			if origen = null_pais
				persona.nacionalidad = pais_current[irandom_range(1, array_length(pais_current) - 1)]
			else
				persona.nacionalidad = origen
			persona.nombre = gen_nombre(persona.sexo, persona.nacionalidad.idioma)
			persona.apellido = gen_apellido(persona.nacionalidad.idioma)
			persona.religion = (irandom(100) < persona.nacionalidad.religion)
			if persona.sexo{
				familia.madre = persona
				if persona.nacionalidad.idioma = 5
					persona.apellido += "a"
			}
			else
				familia.padre = persona
			if brandom(){
				mes_inmigrantes[current_mes]++
				var persona_2 = add_persona()
				persona_2.familia = familia
				persona_2.educacion = sqr(random(2.1))
				persona.pareja = persona_2
				persona_2.pareja = persona
				persona_2.sexo = not persona.sexo
				persona_2.relacion.sexo = persona_2.sexo
				persona_2.nombre = gen_nombre(persona_2.sexo)
				while persona.apellido = persona_2.apellido
					persona_2.apellido = gen_apellido()
				persona_2.relacion.nombre = name(persona_2)
				persona_2.edad = irandom_range(max(20, persona.edad - 5), persona.edad + 5)
				if origen = null_pais
					persona_2.nacionalidad = choose(persona.nacionalidad, paises[irandom_range(1, array_length(paises) - 1)])
				else
					persona_2.nacionalidad = origen
				persona_2.nombre = gen_nombre(persona_2.sexo, persona_2.nacionalidad.idioma)
				persona_2.apellido = gen_apellido(persona_2.nacionalidad.idioma)
				persona_2.religion = choose(persona.religion, (irandom(100) < persona_2.nacionalidad.religion))
				if persona.sexo
					familia.padre = persona_2
				else{
					familia.madre = persona_2
					if persona_2.nacionalidad.idioma = 5
						persona_2.apellido += "a"
				}
				persona.relacion.pareja = persona_2.relacion
				persona_2.relacion.pareja = persona.relacion
				persona_2.politica_economia = clamp(persona.politica_economia + random_range(-1, 1), 0, 6)
				persona_2.politica_sociocultural = clamp(persona.politica_sociocultural + random_range(-1, 1), 0, 6)
				familia.integrantes++
				repeat(irandom(3)){
					mes_inmigrantes[current_mes]++
					var hijo = add_persona()
					hijo.familia = familia
					hijo.apellido = familia.padre.apellido
					if hijo.sexo and persona.nacionalidad.idioma = 5
						persona.apellido += "a"
					hijo.edad = irandom(min(persona.edad - 18, persona_2.edad - 18, 18))
					hijo.educacion = max(0, random((hijo.edad - 4) / 5))
					hijo.es_hijo = true
					hijo.nacionalidad = choose(persona.nacionalidad, persona_2.nacionalidad)
					hijo.nombre = gen_nombre(hijo.sexo, hijo.nacionalidad.idioma)
					hijo.religion = choose(persona.religion, persona_2.religion)
					hijo.relacion.padre = persona.relacion
					hijo.relacion.madre = persona_2.relacion
					hijo.relacion.nombre = name(hijo)
					hijo.politica_economia = clamp(persona.politica_economia + random_range(-1, 1), 0, 6)
					hijo.politica_sociocultural = clamp(persona.politica_sociocultural + random_range(-1, 1), 0, 6)
					array_push(persona.relacion.hijos, hijo.relacion)
					array_push(persona_2.relacion.hijos, hijo.relacion)
					array_push(familia.hijos, hijo)
					familia.integrantes++
				}
			}
			mes_inmigrantes[current_mes]++
		}
		array_push(homeless.familias, familia)
		array_push(familias, familia)
		return familia
	}
}
function add_familia(origen = -1){
	var familia = {
		padre : control.null_persona,
		madre : control.null_persona,
		hijos : [null_persona],
		casa : control.homeless,
		sueldo : 0,
		felicidad_vivienda : 50,
		felicidad_alimento : 50,
		riqueza : irandom_range(30, 50)
	}
	array_pop(familia.hijos)
	var persona = add_persona()
	persona.familia = familia
	persona.educacion = sqr(random(2.1))
	if origen = -1
		persona.nacionalidad = irandom_range(1, array_length(control.pais_nombre) - 1)
	else
		persona.nacionalidad = origen
	persona.religion = (irandom(100) < control.pais_religion[persona.nacionalidad])
	if persona.sexo
		familia.madre = persona
	else
		familia.padre = persona
	if brandom(){
		control.mes_inmigrantes[mes(control.dia)]++
		var persona_2 = add_persona()
		persona_2.familia = familia
		persona_2.educacion = sqr(random(2.1))
		persona.pareja = persona_2
		persona_2.pareja = persona
		persona_2.sexo = not persona.sexo
		persona_2.nombre = gen_nombre(persona_2.sexo)
		while persona.apellido = persona_2.apellido
			persona_2.apellido = gen_apellido()
		persona_2.edad = irandom_range(max(20, persona.edad - 5), persona.edad + 5)
		if origen = -1
			persona_2.nacionalidad = choose(persona.nacionalidad, irandom_range(1, array_length(control.pais_nombre) - 1))
		else
			persona_2.nacionalidad = origen
		persona_2.religion = choose(persona.religion, (irandom(100) < control.pais_religion[persona_2.nacionalidad]))
		if persona.sexo
			familia.padre = persona_2
		else
			familia.madre = persona_2
		repeat(irandom(3)){
			control.mes_inmigrantes[mes(control.dia)]++
			var hijo = add_persona()
			hijo.familia = familia
			hijo.apellido = familia.padre.apellido
			hijo.edad = irandom(min(persona.edad - 18, persona_2.edad - 18, 18))
			hijo.educacion = max(0, random((hijo.edad - 4) / 5))
			hijo.es_hijo = true
			hijo.nacionalidad = choose(persona.nacionalidad, persona_2.nacionalidad)
			hijo.religion = choose(persona.religion, persona_2.religion)
			hijo.relacion.padre = persona.relacion
			hijo.relacion.madre = persona_2.relacion
			array_push(familia.hijos, hijo)
		}
	}
	array_push(control.homeless.familias, familia)
	array_push(control.familias, familia)
	control.mes_inmigrantes[mes(control.dia)]++
	return familia
}
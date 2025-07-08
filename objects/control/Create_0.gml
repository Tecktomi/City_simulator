randomize()
var a, b
debug = false
#region Save
	roaming = game_save_id
	directory_create(roaming + "Personas")
	directory_create(roaming + "Edificios")
	directory_create(roaming + "Construcciones")
	directory_create(roaming + "Terreno")
	directory_create(roaming + "Familias")
	directory_create(roaming + "Relaciones")
	directory_create(roaming + "Exigencias")
	directory_create(roaming + "Tratados")
	ini_open(roaming + "config.txt")
	window_set_size(ini_read_real("MAIN", "view_width", 1280), ini_read_real("MAIN", "view_height", 720))
	window_center()
	window_set_fullscreen(ini_read_real("MAIN", "fullscreen", 0))
	ini_close()
#endregion
#region Paises y Guerras
	null_guerra = {
		nombre : "null_guerra",
		anno_inicio : 0,
		anno_fin : 0,
		bando_a : [],
		bando_b : []
	}
	guerras = [null_guerra]
	array_pop(guerras)
	guerras_current = [null_guerra]
	array_pop(guerras_current)
	null_pais = {
		nombre : "null_pais",
		religion : 0,
		inicio : 0,
		fin : 0,
		idioma : 0,
		industria : 0,
		relacion : 0,
		guerras : [null_guerra],
		dia_nacional : 0,
		recursos : [0]
	}
	array_pop(null_pais.guerras)
	array_pop(null_pais.recursos)
	array_push(null_guerra.bando_a, null_pais)
	array_pop(null_guerra.bando_a)
	array_push(null_guerra.bando_b, null_pais)
	array_pop(null_guerra.bando_b)
	pais_dia = array_create(360, null_pais)
	paises = [null_pais]
	array_pop(paises)
	pais_current = [null_pais]
	array_pop(pais_current)
	function def_pais(nombre, religion, inicio, fin, idioma, industria){
		do var a = irandom(359)
		until pais_dia[a] = null_pais
		var pais = {
			nombre : string(nombre),
			religion : real(religion),
			inicio : real(inicio),
			fin : real(fin),
			idioma : real(idioma),
			industria : real(industria),
			relacion : 0,
			guerras : [null_guerra],
			dia_nacional : a,
			recursos : [0]
		}
		pais_dia[a] = pais
		array_pop(pais.guerras)
		array_pop(pais.recursos)
		array_push(paises, pais)
		if inicio = 0
			array_push(pais_current, pais)
		return pais
	}
	#region Definición de países
		pais_tropico = def_pais("Trópico", 92, 0, 0, 0, 0)
		pais_cuba = def_pais("Cuba", 59, 95, 0, 0, 0.3)
		pais_mexico = def_pais("México", 95, 21, 0, 0, 0.3)
		pais_el_salvador = def_pais("El Salvador", 88, 41, 0, 0, 0.2)
		pais_costa_rica = def_pais("Costa Rica", 91, 38, 0, 0, 0.2)
		pais_honduras = def_pais("Honduras", 88, 38, 0, 0, 0.2)
		pais_panama = def_pais("Panamá", 93, 103, 0, 0, 0.4)
		pais_guatemala = def_pais("Guatemala", 95, 38, 0, 0, 0.2)
		pais_haiti = def_pais("Haití", 87, 0, 0, 1, 0.1)
		pais_republica_dominicana = def_pais("República Dominicana", 88, 44, 0, 0, 0.2)
		//10
		pais_venezuela = def_pais("Venezuela", 90, 31, 0, 0, 0.4)
		pais_colombia = def_pais("Colombia", 92, 31, 0, 0, 0.3)
		pais_brasil = def_pais("Brasil", 88, 22, 0, 2, 0.4)
		pais_belice = def_pais("Belice", 88, 181, 0, 3, 0.2)
		pais_jamaica = def_pais("Jamaica", 77, 162, 0, 3, 0.2)
		pais_nicaragua = def_pais("Nicaragua", 86, 38, 0, 0, 0.2)
		pais_bahamas = def_pais("Bahamas", 96, 173, 0, 3, 0.2)
		pais_estados_unidos = def_pais("Estados Unidos", 78, 0, 0, 3, 0.9)
		pais_gran_colombia = def_pais("Gran Colombia", 80, 19, 31, 0, 0.3)
		pais_probincias_unidas_de_centroamerica = def_pais("Probincias Unidas de Centroamérica", 80, 23, 40, 0, 0.3)
		//20
		pais_espanna = def_pais("España", 90, 0, 0, 0, 0.6)
		pais_francia = def_pais("Francia", 70, 0, 0, 1, 0.7)
		pais_inglaterra = def_pais("Inglaterra", 70, 0, 0, 3, 1)
		pais_portugal = def_pais("Portugal", 80, 0, 0, 2, 0.6)
		pais_holanda = def_pais("Holanda", 70, 0, 0, 4, 0.6)
		pais_virreinato_de_nueva_espanna = def_pais("Virreinato de Nueva España", 80, 0, 21, 0, 0.3)
		pais_virreinato_de_nueva_granada = def_pais("Virreinato de Nueva Granada", 80, 0, 19, 0, 0.3)
		pais_imperio_aleman = def_pais("Imperio Alemán", 60, 71, 118, 4, 0.7)
		pais_alemania_nazi = def_pais("Alemania Nazi", 70, 133, 145, 4, 1)
		pais_union_sovietica = def_pais("Unión Soviética", 10, 122, 191, 5, 0.7)
		//30
		pais_china = def_pais("China", 0, 112, 0, 6, 0.7)
	#endregion
	idioma_nombre = ["Español", "Francés", "Portugués", "Inglés", "Alemán", "Ruso", "Chino"]
	function def_guerra(nombre = "guerra", inicio = 0, fin = 0, bando_a = [null_pais], bando_b = [null_pais]){
		var guerra = {
			nombre : nombre,
			inicio : inicio,
			fin : fin,
			bando_a : bando_a,
			bando_b : bando_b
		}
		if nombre = "guerra" and array_length(bando_a) > 0{
			if array_equals(bando_b, [0])
				guerra.nombre = $"Guerra civil de {pais_nombre[bando_a[0]]}"
			else if array_length(bando_b) > 0
				guerra.nombre = $"Guerra {pais_nombre[bando_a[0]]}-{pais_nombre[bando_b[0]]}"
		}
		array_push(guerras, guerra)
		return guerra
	}
	#region Definición de guerras
		def_guerra("Guerras Revolucionarias Francesas", 0, 4, [pais_espanna, pais_francia, pais_holanda], [pais_haiti, pais_estados_unidos, pais_inglaterra])
		def_guerra("Revolución haitiana", 0, 4, [8, pais_espanna, pais_inglaterra], [pais_francia])
		def_guerra("Guerras Napoleonicas", 4, 8, [pais_estados_unidos, pais_espanna, pais_francia, pais_holanda], [pais_inglaterra, pais_portugal])
		def_guerra("Guerras Anglo-españolas", 6, 9, [pais_espanna], [pais_inglaterra])
		def_guerra("Guerras Napoleonicas", 9, 15, [pais_francia, pais_holanda], [pais_espanna, pais_inglaterra, pais_portugal])
		def_guerra("Guerras de independencia Hispanoamericanas", 10, 21, [pais_espanna], [pais_francia, pais_inglaterra, pais_virreinato_de_nueva_espanna])
		def_guerra("Guerras de independencia Hispanoamericanas", 10, 19, [pais_espanna], [pais_francia, pais_inglaterra, pais_virreinato_de_nueva_granada])
		def_guerra("Guerras anglo-estadounidences", 12, 12, [pais_inglaterra, pais_virreinato_de_nueva_espanna], [pais_estados_unidos])
		def_guerra("Toma de Amelia", 17, 17, [pais_estados_unidos, pais_espanna], [])
		def_guerra("Reconquista de México", 21, 29, [pais_mexico], [pais_espanna])
		def_guerra("Guerra de los Comanches", 21, 48, [pais_mexico], [])
		def_guerra("Independencia de Brasil", 22, 25, [pais_brasil, pais_inglaterra], [pais_portugal])
		def_guerra("guerra de los Pasteles", 38, 39, [pais_mexico], [pais_francia])
		def_guerra("Intervención", 46, 48, [pais_mexico], [pais_estados_unidos])
		def_guerra("Guerra nacional Centroamericana", 55, 57, [pais_el_salvador, pais_costa_rica, pais_honduras, pais_guatemala], [pais_cuba, pais_nicaragua])
		def_guerra("Guerra de Reforma", 57, 61, [pais_mexico, pais_estados_unidos], [pais_francia])
		def_guerra("Intervención francesa en México", 62, 67, [pais_mexico, pais_estados_unidos], [pais_espanna, pais_francia, pais_inglaterra])
		def_guerra("Guerra de la Restauración", 63, 65, [9], [pais_espanna])
		def_guerra("Intento de Barrios", 85, 85, [pais_honduras, pais_guatemala], [pais_mexico, pais_el_salvador, pais_costa_rica, pais_nicaragua])
		def_guerra("Crisis de Panamá", 85, 85, [pais_colombia], [pais_estados_unidos])
		def_guerra("Independencia Cubana", 95, 98, [pais_cuba, pais_estados_unidos], [pais_espanna])
		def_guerra("Guerra hispano-estadounidence", 98, 98, [pais_espanna], [pais_estados_unidos, pais_cuba])
		def_guerra("Guerras bananeras", 98, 134, [pais_estados_unidos], [pais_cuba, pais_mexico, pais_honduras, pais_panama, pais_haiti, pais_republica_dominicana, pais_colombia, pais_nicaragua])
		def_guerra("Guerra de los Mil días", 99, 102, [pais_venezuela, pais_colombia], [pais_guatemala, pais_nicaragua])
		def_guerra("Bloqueo internacional a Venezuela", 102, 103, [pais_venezuela, pais_estados_unidos], [pais_mexico, pais_espanna, pais_inglaterra])
		def_guerra("Guerrita de agosto", 106, 106, [pais_cuba, pais_estados_unidos], [])
		def_guerra("Revolución mexicana", 110, 120, [pais_mexico], [pais_estados_unidos, pais_inglaterra])
		def_guerra("Primera Guerra Mundial", 114, 118, [pais_estados_unidos, pais_francia, pais_inglaterra, pais_china], [pais_imperio_aleman])
		def_guerra("Primera guerra civil de Honduras", 119, 119, [pais_mexico, pais_honduras, pais_estados_unidos], [pais_el_salvador])
		def_guerra("Guerra de Coto", 121, 121, [pais_costa_rica], [pais_panama])
		def_guerra("Segunda guerra civil de Honduras", 24, 24, [pais_honduras], [pais_estados_unidos])
		def_guerra("Guerra cistera", 126, 129, [pais_mexico, pais_estados_unidos], [])
		def_guerra("Guerra Constitucionalista de Nicaragua", 126, 127, [pais_nicaragua], [])
		def_guerra("La Violencia", 130, 160, [pais_colombia], [])
		def_guerra("Segunda guerra cristera", 134, 138, [pais_mexico], [])
		def_guerra("Guerra civil española", 136, 139, [pais_mexico, pais_francia], [pais_espanna, pais_portugal])
		def_guerra("Segunda Guerra Mundial", 139, 145, [pais_mexico, pais_brasil, pais_estados_unidos, pais_francia, pais_inglaterra, pais_holanda, pais_union_sovietica, pais_china], [pais_espanna, pais_alemania_nazi])
		def_guerra("Guerra civil de Costa Rica", 148, 148, [pais_costa_rica], [])
		def_guerra("Crisis del Archipielago Los Monjes", 152, 152, [pais_venezuela], [pais_colombia])
		def_guerra("Revolución Cubana", 153, 159, [pais_cuba], [pais_estados_unidos])
		def_guerra("Invasión de Costa Rica", 155, 155, [pais_venezuela, pais_nicaragua], [pais_costa_rica])
		def_guerra("Guerra de Mocorón", 157, 160, [pais_honduras], [pais_nicaragua])
		def_guerra("Invasión cubana", 159, 159, [pais_cuba], [pais_panama, pais_republica_dominicana])
		def_guerra("Rebelión del Escambray", 160, 165, [pais_cuba], [pais_estados_unidos])
		def_guerra("Conflicto interno Colombiano", 160, 0, [pais_colombia, pais_brasil, pais_estados_unidos], [])
		def_guerra("Guerra civil de Guatemala", 160, 196, [pais_guatemala, pais_estados_unidos], [pais_cuba])
		def_guerra("Guerra de independencia de Angola", 161, 175, [pais_cuba], [pais_portugal])
		def_guerra("Invasión Bahía de Cochinos", 161, 161, [pais_cuba], [pais_estados_unidos])
		def_guerra("Invasiones cubanas en Venezuela", 161, 167, [pais_cuba], [pais_venezuela])
		def_guerra("Operación cuarentena", 162, 162, [9, pais_venezuela, pais_estados_unidos], [pais_cuba])
		def_guerra("Guerrillas en Venezuela", 162, 0, [pais_venezuela, pais_colombia], [pais_cuba])
		def_guerra("Guerra de las Arenas", 163, 164, [pais_cuba], [pais_estados_unidos, pais_francia])
		def_guerra("Independencia de Guinea-Bisau", 164, 174, [pais_cuba], [pais_portugal])
		def_guerra("Crisis del Congo", 165, 165, [pais_cuba], [])
		def_guerra("Guerra civil dominicana", 165, 165, [pais_estados_unidos], [pais_republica_dominicana])
		def_guerra("Guerra de desgaste", 168, 170, [pais_cuba, pais_union_sovietica], [])
		def_guerra("Guerra de Yom Kipur", 173, 173, [pais_cuba, pais_union_sovietica], [pais_estados_unidos, pais_francia, pais_inglaterra])
		def_guerra("Independencia de Eritrea", 177, 191, [pais_cuba], [])
		def_guerra("Revolución Sandinista", 179, 190, [pais_honduras, pais_nicaragua, pais_estados_unidos], [pais_cuba])
		def_guerra("Guerra civil de El Salvador", 179, 192, [pais_el_salvador, pais_nicaragua, pais_estados_unidos], [pais_china])
		def_guerra("operación Charly", 179, 181, [pais_el_salvador, pais_honduras, pais_guatemala, pais_nicaragua], [])
		def_guerra("Invasión de Granada", 183, 183, [pais_estados_unidos], [pais_cuba])
		def_guerra("Invasiónde Panamá", 189, 190, [pais_panama], [pais_estados_unidos])
		def_guerra("Operación Uphold Democracy", 194, 196, [pais_estados_unidos], [pais_haiti])
		def_guerra("Guerra contra el narcotráfico", 206, 0, [pais_mexico, pais_estados_unidos], [])
	#endregion
#endregion
#region Leyes, ministerios, noticias y zonas de pesca
	dia = 1
	#region Leyes
		ley_nombre = []
		ley_eneabled = []
		ley_anno = []
		ley_precio = []
		ley_descripcion = []
		ley_economia = []
		ley_sociocultural = []
		ley_tiempo = []
		function def_ley(nombre, eneabled, anno, precio, economia, sociocultural, descripcion){
			array_push(ley_nombre, string(nombre))
			array_push(ley_eneabled, bool(eneabled))
			array_push(ley_anno, real(anno))
			array_push(ley_precio, real(precio))
			array_push(ley_economia, real(economia))
			array_push(ley_sociocultural, real(sociocultural))
			array_push(ley_descripcion, string(descripcion))
			array_push(ley_tiempo, 0)
		}
		def_ley("Divorcios", false, 100, 250, 2, 2, "Permite a los ciudadanos separarse legalmente, molestará a los ciudadanos religiosos")
		def_ley("Inmigracion", true, 0, 500, 4, 1, "Permite la entrada de inmigrantes a la isla")
		def_ley("Trabajo infantil", false, 0, 800, 5, 5, "Permite trabajar a los niños mayores de 12 años, molestará a todo ciudadano con hijos")
		def_ley("Jubilación", false, 90, 500, 1, 3, "Permite jubilarse a los ciudadanos mayores de 65 años, le agradará a los beneficiados")
		def_ley("Comida gratis", false, 0, 500, 1, 2, "La comida es gratis, le permite a todos los habitantes acceder a ella")
		def_ley("Emigración", true, 0, 800, 4, 1, "Le permite a los ciudadanos molestos irse del país si lo desean")
		def_ley("Trabajo temporal", false, 0, 500, 4, 4, "Despide automáticamente a los trabajadores de las constructoras cuando no hay proyectos pendientes")
		def_ley("Tomas", true, 0, 500, 1, 0, "Permite que los ciudadanos construyan tomas cuando no logran encontrar un hogar")
		def_ley("Agua potable universal", false, 70, 1000, 1, 2, "Asegura que todas las casas tengan acceso a agua potable")
		def_ley("Subsidio infantil", false, 90, 500, 1, 3, "El estado mantiene económicamente a los hijos, alegrará a todos los ciudadanos con hijos")
		//10
		def_ley("Sufragio femenino", false, 120, 800, 3, 1, "Permite a mujeres votarle a su majestad")
		def_ley("Policía armada", true, 0, 1000, 3, 6, "Le da a la policía las herramientas para hacer bien su trabajo")
		def_ley("Seguro laboral", false, 90, 800, 2, 3, "Indemnizará a las familias de los trabajadores que mueran por accidente laboral")
		def_ley("Regularización de Pesca", false, 110, 800, 2, 4, "Impide a las pescaderías extraer pescado cuando su zona de extración está muy dañada")
		def_ley("Libre comercio", true, 120, 800, 5, 1, "Permite a empresas privadas importar los recursos que necesiten")
		def_ley("Prostitución", false, 180, 500, 3, 0, "Permite oficialmente la prostitución, cabarets y enfurece a los religiosos")
		def_ley("Estado laico", false, 0, 1000, 3, 1, "Separación entre la iglesia y el estado, permite a ciudadanos no religiosos acceder a derechos civiles")
		def_ley("Ley seca", false, 120, 500, 3, 5, "Impide la venta de alcohol en la isla, con todo lo que eso implica")
		def_ley("Prohibición de drogas", false, 139, 500, 4, 5, "Impide la venta recreativa de Cañamo a la población")
		def_ley("Prohibición de colillas", false, 210, 800, 3, 4, "Impide la venta recreativa de Tabaco a la población")
		//20
		def_ley("Prohibición de armas", false, 100, 800, 1, 5, "Impide la venta recreativa de Armas a la población")
		def_ley("Matrimonio igualitario", false, 200, 800, 0, 1, "Permite a personas del mismo sexo casarse")
		def_ley("Libertad de prensa", false, 0, 500, 3, 0, "Permite a los medios de comunicación mostrar una ideología distinta a la oficial")
		def_ley("Colonia punitiva", false, 0, 500, 6, 5, "Recibe presos de otros países (aumentando la inmigración) a cambio de un ingreso mensual")
		def_ley("Pena de muerte", true, 120, 800, 3, 6, "Ahorraremos espacio en las prisiones acabando con los peores criminales")
		def_ley("Condiciones laborales dignas", false, 90, 800, 1, 1, "Mejora la calidad laboral de todos los trabajadores pero aumenta el mantenimiento")
	#endregion
	politica_economia_nombre = ["Extrema izquierda", "Izquierda", "Centro izquierda", "Centro", "Centro derecha", "Derecha", "Extrema derecha"]
	politica_sociocultural_nombre = ["Extremo libertario", "Libertario", "Libertario moderado", "Moderado", "Autoritario moderado", "Autoritario", "Extremo autoritario"]
	politica_economia = 3
	politica_sociocultural = 3
	politica_religion = 0.5
	medios_comunicacion = [43, 57, 63]
	medios_comunicacion_modos = ["Libre expresión", "Campaña política", "Publicidad invasiva"]
	campanna = 0
	ministerio_nombre = ["Población", "Vivienda", "Trabajo", "Salud", "Educación", "Economía", "Exterior", "Propiedad privada", "Leyes"]
	ministerio = -1
	null_noticia = {
		dia : 0,
		titulo : "null_noticia",
		descripcion : ""
	}
	noticias = [null_noticia]
	array_pop(noticias)
	null_zona_pesca = {
		a : 0,
		b : 0,
		cantidad : 0,
		cantidad_max : 0
	}
	carreteras_index = 0
	null_carretera = {
		index : 0,
		tramos : [[0, 0]],
		edificios : [],
		taxis : 0,
		dia_taxis : []
	}
	array_pop(null_carretera.tramos)
	carreteras = [null_carretera]
	array_pop(carreteras)
	null_auto = {
		x : 0,
		y : 0,
		hmove : 0,
		vmove : 0,
		dir : 0,
		time : 0
	}
	autos = [null_auto]
	array_pop(autos)
#endregion
#region Personas
	null_relacion = {
		padre : undefined,
		madre : undefined,
		pareja : undefined,
		hijos : [],
		vivo : false,
		persona : undefined,
		nombre : "VOID",
		sexo : false
	}
	null_relacion.padre = null_relacion
	null_relacion.madre = null_relacion
	null_relacion.pareja = null_relacion
	array_push(null_relacion.hijos, null_relacion)
	array_pop(null_relacion.hijos)
	null_persona = {
		familia : undefined,
		trabajo : undefined,
		pareja : undefined,
		sexo : false,
		nombre : "VOID",
		apellido : "",
		cumple : 0,
		edad : 0,
		embarazo : -1,
		muerte : -1,
		felicidad : 0,
		felicidad_trabajo : 0,
		felicidad_educacion : 0,
		felicidad_salud : 0,
		felicidad_ocio : 0,
		felicidad_transporte : 0,
		felicidad_religion : 0,
		felicidad_ley : 0,
		felicidad_crimen : 0,
		felicidad_temporal : 0,
		educacion : 0,
		escuela : undefined,
		medico : undefined,
		ocios : [undefined],
		lujos : [false],
		es_hijo : false,
		nacionalidad : 0,
		religion : true,
		relacion : null_relacion,
		ladron : undefined,
		preso : false,
		empresa : undefined,
		politica_economia : 3,
		politica_sociocultural : 3,
		candidato : false,
		candidato_popularidad : 1,
		informado : false,
		favorito : false
	}
	null_persona.pareja = null_persona
	null_relacion.persona = null_persona
	personas = [null_persona]
	array_pop(null_persona.lujos)
	array_pop(personas)
	personas_favoritas = [null_persona]
	array_pop(personas_favoritas)
	candidatos = [null_persona]
	array_pop(candidatos)
	candidatos_votos = []
	candidatos_votos_total = 0
	elecciones = false
	for(a = 0; a < 360; a++){
		cumples[a] = [null_persona]
		array_pop(cumples[a])
		embarazo[a] = [null_persona]
		array_pop(embarazo[a])
		muerte[a] = [null_persona]
		array_pop(muerte[a])
	}
	educacion_nombre = ["Analfabeto", "Educación Básica", "Educación Media", "Educación Técnica", "Educación Profesional"]
	for(a = 0; a < array_length(educacion_nombre); a++)
		trabajo_educacion[a] = []
#endregion
#region Familias
	familia_count = 0
	null_familia = {
		padre : null_persona,
		madre : null_persona,
		hijos : [null_persona],
		casa : undefined,
		sueldo : 0,
		felicidad_vivienda : 0,
		felicidad_alimento : 0,
		riqueza : 0,
		integrantes : 0,
		index : familia_count,
		banco : false
	}
	array_pop(null_familia.hijos)
	familias = [null_familia]
	array_pop(familias)
	null_persona.familia = null_familia
	sueldo_minimo = 0
#endregion
#region Recursos
	recurso_nombre = [	"Cereales", "Madera", "Plátanos", "Algodón", "Tabaco", "Azucar", "Soya", "Cañamo", "Pescado", "Carbón",
						"Hierro", "Oro", "Cobre", "Aluminio", "Níquel", "Acero", "Tela", "Barcos", "Carne", "Leche",
						"Lana", "Cuero", "Ron", "Queso", "Herramientas", "Muebles", "Ladrillos", "Petróleo", "Armas", "Ropa",
						"Químicos", "Vehículos", "Plásticos", "Computadores", "Comida enlatada", "Electrodomésticos"]
	recurso_precio = [1.5, 1.2, 1.6, 1.8, 2.2, 1.4, 1.2, 2.8, 1.6, 2.5, 3.5, 5, 3, 2.2, 4, 12, 8, 400, 2.2, 1.2, 1.4, 2.2, 12, 8, 15, 15, 1, 4, 40, 10, 5, 100, 5, 60, 2, 30]
	recurso_anno = [0, 0, 0, 0, 0, 0, 110, 0, 0, 0,  0, 0, 0, 90, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 60, 0, 0, 70, 105, 130, 170, 50, 120]
	recurso_prima = [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, true, true, true, true, false, false, false, false, true, true, false, false, false, false, false, false, false, false]
	recurso_current = []
	recurso_cultivo = [0, 2, 3, 4, 5, 6, 7]
	cultivo_altura_minima = [0.6, 0.55, 0.65, 0.6, 0.55, 0.65, 0.55]
	recurso_comida = [0, 2, 6, 8, 18, 19, 23, 34]
	recurso_lujo = [4, 7, 22, 25, 28, 29, 31, 32, 33, 35]
	recurso_lujo_probabilidad = [1, 1, 1, 0.2, 0.1, 1, 0.1, 1, 0.2, 0.2]
	recurso_lujo_ocio = [10, 10, 10, 5, 1, 5, 15, 10]
	for(a = 0; a < array_length(recurso_lujo); a++)
		array_push(null_persona.lujos, false)
	recurso_mineral = [9, 10, 11, 12, 13, 14]
	recurso_mineral_color = [c_black, c_gray, c_yellow, c_orange, c_ltgray, c_dkgray]
	recurso_mineral_rareza = [0.85, 0.875, 0.95, 0.85, 0.9, 0.925]
	ganado_nombre = ["Vacas", "Cabras", "Ovejas", "Cerdos"]
	ganado_produccion = [[18, 21], [19], [20], [18]]
	recurso_ganado = [18, 19, 20, 21]
	recurso_usado_construccion = []
	recurso_usado_mejoras = []
	for(a = 0; a < array_length(paises); a++){
		var pais = paises[a], industria = pais.industria, c = 0, d = 0, text = $"{pais.nombre}: ["
		pais.recursos = []
		for(b = 0; b < array_length(recurso_nombre); b++){
			d = (recurso_prima[b] ? random(1) - industria : random(1) + industria - 1)
			d = sign(d) * sqrt(abs(d))
			array_push(pais.recursos, d)
			c += abs(d)
		}
		for(b = 0; b < array_length(recurso_nombre); b++){
			d = pais.recursos[b] / c
			pais.recursos[b] = d
			text += $"{d}, "
		}
		if debug
			show_debug_message(text + "]")
	}
	null_tratado = {
		pais : null_pais,
		recurso : 0,
		cantidad : 0,
		factor : 1,
		tiempo : 0,
		tipo : false
	}
	tratados_ofertas = [null_tratado]
	array_pop(tratados_ofertas)
	for(a = 0; a < array_length(recurso_nombre); a++){
		recurso_importado[a] = 0
		recurso_exportado[a] = true
		recurso_importado_fijo[a] = 0
		recurso_importado_privado[a] = 0
		recurso_tratados_venta[a] = [null_tratado]
		recurso_tratados_compra[a] = [null_tratado]
		recurso_construccion[a] = 0
		recurso_utilizado[a] = 0
		array_pop(recurso_tratados_venta[a])
		array_pop(recurso_tratados_compra[a])
		for(b = 0; b < 24; b++)
			recurso_historial[a, b] = recurso_precio[a]
		recurso_precio_original[a] = max(0.5, recurso_precio[a] / 2)
		recurso_importacion_privada[a] = 0
		if floor(dia / 360) >= recurso_anno[a]
			array_push(recurso_current, a)
	}
#endregion
#region Edificios
	#region Descripción
	edificio_descripcion = ["", "", "", "",
		"Produce diversos cultivos dependiendo de la fertilidad del terreno",
		"Corta áboles cercanos para extraer madera",
		"Entrega educación media a los niños que viven cerca",
		"Entrega atención médica a los habitantes que viven cerca",
		"Vivienda precaria pero barata, es mejor que vivir en la calle",
		"Mejor que una chabola",
		"Excelente vivienda con gran jardín, solo los habitantes más adinerados pueden costearselo",
		"Sirve ron a cualquiera que pueda pagar, a la gente le gusta",
		"Entrega entretenimiento a toda familia que tenga hijos",
		"Transporta bienes y personas por alta mar, tu isla necesita tener al menos uno de estos",
		"Extrae pescado del mar",
		"Extrae diversos metales de los distintos depósitos",
		"Entrega satisfacción espiritual a tus ciudadanos creyentes, puede también funcionar como centro médico, albergue o escuela primaria",
		"", "", "",
		"Trabaja en la construcción de edificios en tu isla, necesitas al menus una de estas",
		"Mejora la belleza del lugar además de entregar algo de entretención a los ciudadanos cerca",
		"Mueve bienes entre los edificios, es vital para mantener la economía funcionando",
		"Consume hierro y carbón para producir acero, contamina bastante",
		"Genera entretenimiento a cierta área de la población, espero que esté prohibido el trabajo infantil",
		"Consume algodón y lana para producir tela",
		"Fabrica barcos a partir de bastante madera, cañamo, cobre y tela",
		"Reproduce animales para obtener recursos de estos",
		"Consume azúcar para producir ron",
		"Consume leche para producir queso",
		"Usa madera, acero y cuero para producir herramientas",
		"Vivienda urbana por excelencia",
		"Vivienda anarquista por excelencia, se construirán automáticamente si no hay casas disponibles",
		"",
		"Reduce el crimen al encerrar a los delincuentes cercanos por un tiempo, además puede ayudar con los disturbios",
		"Genera ganancias vendiendo los bienes de lujo que la gente quiere",
		"Utiliza madera para producir muebles",
		"Produce ropa a partir de telas y cuero",
		"Aquí mismo se extrae la arcilla y se cosen ladrillos",
		"Produce plástico a partir del petróleo y productos químicos, contamina mucho",
		"Extrae petróleo de bajo tierra, consume agua potable",
		"Utiliza combustible para dar presión de agua, necesario para mejorar las condiciones de alcantarillado",
		"Genera energía elétrica a partir de la quema de combustibles fósiles",
		"Entrega entretenimiento e información a la gente que sepa leer",
		"Evita que se produzcan incendios en la isla",
		"Utiliza madera, níquel y acero para producir armas, es un edificio bastante peligroso",
		"Toma el dinero de la gente y lo distribuye para mejorar la vida de todos",
		"Vivienda de altísima calidad, el objetivo de toda la sociedad es permitirle a sus dueños virir aquí",
		"Vivienda urbana moderna, permite a varias familias convivir en vivendas pareadas",
		"Bloque de casas organizadas para maximizar las familias por metro cuadrado a bajo costo",
		"Produce productos químicos usando distintos componentes",
		"Produce vehículos a partir de varios materiales",
		"Permite enlatar comida a gran escala",
		"Aquí se presentan obras para el deleite de la élite",
		"Aquí se proyectan películas para el deleite de las masas",
		"Aquí se juega a la pelota, corazón y orgullo de cualquier ciudad latinoaméricana",
		"Infaltable para el ocio nocturno de tus habitantes, ojalá que nadie viva al lado",
		"Transmite para todas las casas y trabajos con electricidad en el área",
		"Usa el poder del sol para generar energía infinita y limpia, ¡que milagro!",
		"",
		"Permite a los ciudadanos moverse rápidamente entre edificios conectados por calles",
		"Entrega entretenimiento a la gente que sepa leer, además de mejorar la especialización de la industria",
		"Entrega educación de mayor alto nivel, es muy caro de mantener",
		"Entrega servicio de televisión a todos los hogares con acceso a la red electrica en la isla",
		"Entrega atención médica de alta calidad, requiere acceso a luz y agua",
		"Permite encarcelar a los ciudadanos no deseados",
		"Defiende las fronteras marinas de la piratería"]
	#endregion
	#region arreglos vacíos
		edificio_nombre = []
		edificio_width = []
		edificio_height = []
		edificio_precio = []
		edificio_construccion_tiempo = []
		edificio_recursos_id = []
		edificio_recursos_num = []
		edificio_mantenimiento = []
		edificio_anno = []
		edificio_belleza = []
		edificio_contaminacion = []
		edificio_estatal = []
		edificio_es_costero = []
		edificio_es_almacen = []
		edificio_sprite = []
		edificio_sprite_id = []
		edificio_es_casa = []
		edificio_familias_max = []
		edificio_familias_calidad = []
		edificio_familias_renta = []
		edificio_es_medico = []
		edificio_es_ocio = []
		edificio_es_iglesia = []
		edificio_es_escuela = []
		edificio_escuela_max = []
		edificio_servicio_clientes = []
		edificio_servicio_calidad = []
		edificio_servicio_tarifa = []
		edificio_bool_agua = []
		edificio_agua = []
		edificio_bool_energia = []
		edificio_energia = []
		edificio_plano = []
		edificio_resize = []
		edificio_resize_no_productiva = []
		edificio_es_trabajo = []
		edificio_trabajadores_max = []
		edificio_trabajo_calidad = []
		edificio_trabajo_sueldo = []
		edificio_trabajo_educacion = []
		edificio_trabajo_riesgo = []
		edificio_es_industria = []
		edificio_industria_input_id = []
		edificio_industria_input_num = []
		edificio_industria_output_id = []
		edificio_industria_output_num = []
		edificio_industria_velocidad = []
		edificio_industria_optativo = []
	#endregion
	#region funciones de definición
		function def_edificio_base(nombre, width = 0, height = 0, precio = 0, tiempo = 0, recur_id = [0], recur_num = [0], mant = 0, belleza = 50, cont = 0, estatal = true, es_costero = false, es_almacen = false, sprite = false, sprite_id = spr_1x1, es_casa = false, fam_max = 0, fam_cal = 0, fam_ren = 0, anno = 0){
			array_push(edificio_nombre, string(nombre))
			array_push(edificio_width, width)
			array_push(edificio_height, height)
			array_push(edificio_precio, precio)
			array_push(edificio_construccion_tiempo, tiempo)
			array_push(edificio_recursos_id, recur_id)
			array_push(edificio_recursos_num, recur_num)
			array_push(edificio_mantenimiento, mant)
			array_push(edificio_belleza, belleza)
			array_push(edificio_contaminacion, cont)
			array_push(edificio_estatal, estatal)
			array_push(edificio_es_costero, es_costero)
			array_push(edificio_es_almacen, es_almacen)
			array_push(edificio_sprite, sprite)
			array_push(edificio_sprite_id, sprite_id)
			array_push(edificio_es_casa, es_casa)
			array_push(edificio_familias_max, fam_max)
			array_push(edificio_familias_calidad, fam_cal)
			array_push(edificio_familias_renta, real(fam_ren))
			array_push(edificio_anno, anno)
		}
		function def_edificio_servicio(es_medico = false, es_ocio = false, es_iglesia = false, es_escuela = false, escuela_max = 0, cli_max = 0, cli_cal = 0, cli_tar = 0, bool_agua = false, agua = 0, bool_energia = false, energia = 0, plano = false, resize = false, no_prod = false){
			array_push(edificio_es_medico, es_medico)
			array_push(edificio_es_ocio, es_ocio)
			array_push(edificio_es_iglesia, es_iglesia)
			array_push(edificio_es_escuela, es_escuela)
			array_push(edificio_escuela_max, escuela_max)
			array_push(edificio_servicio_clientes, cli_max)
			array_push(edificio_servicio_calidad, cli_cal)
			array_push(edificio_servicio_tarifa, cli_tar)
			array_push(edificio_bool_agua, bool_agua)
			array_push(edificio_agua, agua)
			array_push(edificio_bool_energia, bool_energia)
			array_push(edificio_energia, energia)
			array_push(edificio_plano, plano)
			array_push(edificio_resize, resize)
			array_push(edificio_resize_no_productiva, no_prod)
		}
		function def_edificio_trabajo(es_trabajo = false, trab_max = 0, trab_cal = 0, trab_sue = 0, trab_edu = 0, trab_ries = 0, es_industria = false, ind_in_id = [0], ind_in_num = [0], ind_out_id = [0], ind_out_num = [0], ind_vel = 1, ind_opt = false){
			for(var a = 0; a < array_length(ind_in_id); a++)
				if ind_in_num[a] = 0{
					array_delete(ind_in_id, a, 1)
					array_delete(ind_in_num, a--, 1)
				}
			for(var a = 0; a < array_length(ind_out_id); a++)
				if ind_out_num[a] = 0{
					array_delete(ind_out_id, a, 1)
					array_delete(ind_out_num, a--, 1)
				}
			array_push(edificio_es_trabajo, es_trabajo)
			array_push(edificio_trabajadores_max, trab_max)
			array_push(edificio_trabajo_calidad, trab_cal)
			array_push(edificio_trabajo_sueldo, trab_sue)
			array_push(edificio_trabajo_educacion, trab_edu)
			array_push(edificio_trabajo_riesgo, trab_ries)
			array_push(edificio_es_industria, es_industria)
			array_push(edificio_industria_input_id, ind_in_id)
			array_push(edificio_industria_input_num, ind_in_num)
			array_push(edificio_industria_output_id, ind_out_id)
			array_push(edificio_industria_output_num, ind_out_num)
			array_push(edificio_industria_velocidad, ind_vel)
			array_push(edificio_industria_optativo, ind_opt)
		}
	#endregion
	#region definición
		def_edificio_base("Sin trabajo"); def_edificio_servicio(); def_edificio_trabajo()
		def_edificio_base("Jubilado"); def_edificio_servicio(); def_edificio_trabajo(, 0, 15, 2)
		def_edificio_base("Sin atención médica"); def_edificio_servicio(true); def_edificio_trabajo()
		def_edificio_base("Homeless",,,,,,,,,,,,,,,true); def_edificio_servicio(); def_edificio_trabajo()
		def_edificio_base("Granja", 3, 3, 300, 180, [1, 15, 26], [10, 2, 10], 4, 40, -10, false,,true); def_edificio_servicio(,,,,,,,,,,,, true, true, true); def_edificio_trabajo(true, 10, 25, 4,,,,,,,, 28)
		def_edificio_base("Aserradero", 3, 2, 650, 240, [1, 15], [8, 2], 5, 30, 10, false); def_edificio_servicio(,,,,,,,,,, true, 20); def_edificio_trabajo(true, 10, 30, 5,, 0.03,,,,,, 5)
		def_edificio_base("Escuela", 3, 3, 800, 640, [1, 15, 26], [30, 5, 25], 6, 40); def_edificio_servicio(,,,true, 2, 20, 60,, true, 10); def_edificio_trabajo(true, 4, 50, 8, 2)
		def_edificio_base("Consultorio", 2, 3, 1200, 720, [1, 15, 24, 26], [25, 5, 5, 20], 15, 55); def_edificio_servicio(true,,,,,20, 60, 20, true, 10, true, 10); def_edificio_trabajo(true, 3, 65, 11, 3,,,,,,, 6)
		def_edificio_base("Chabola", 2, 2, 200, 300, [1, 15, 26], [10, 2, 15], 3, 40, 10, false,,,,,true, 5, 30, 4); def_edificio_servicio(,,,,,,,, true, 10, true, 10); def_edificio_trabajo()
		def_edificio_base("Cabaña", 2, 1, 250, 200, [1, 15, 25], [6, 1, 6], 2, 55, 10, false,,,,,true, 2, 45, 6); def_edificio_servicio(,,,,,,,, true, 8, true, 8); def_edificio_trabajo()
		//10
		def_edificio_base("Parcela", 3, 2, 400, 360, [1, 15, 25, 26], [15, 3, 10, 30], 10, 75, 10, false,,,,,true, 2, 65, 12); def_edificio_servicio(,,,,,,,, true, 10, true, 10); def_edificio_trabajo(true, 1, 40, 4)
		def_edificio_base("Taberna", 2, 1, 200, 240, [1, 15, 26], [10, 2, 20], 3, 30,, false); def_edificio_servicio(, true,,,, 8, 25, 1, true, 5); def_edificio_trabajo(true, 2, 35, 5)
		def_edificio_base("Circo", 4, 4, 500, 240, [1, 16], [10, 20], 6, 30,, false); def_edificio_servicio(, true,,,, 16, 20, 1); def_edificio_trabajo(true, 8, 25, 4,, 0.02)
		def_edificio_base("Muelle", 6, 6, 2200, 1080, [1, 15, 17, 24, 26], [40, 40, 3, 10, 40], 10, 30, 15,, true, true); def_edificio_servicio(,,,,,,,,,, true, 30, true); def_edificio_trabajo(true, 6, 30, 6, 1, 0.02,,,,,, 140)
		def_edificio_base("Pescadería", 5, 5, 200, 360, [1, 15, 17], [10, 5, 2], 6, 25, 10, false, true, true); def_edificio_servicio(,,,,,,,,,,,, true); def_edificio_trabajo(true, 6, 25, 5,, 0.04,,,,,, 9)
		def_edificio_base("Mina", 4, 3, 800, 720, [1, 15, 26], [20, 10, 10], 10, 25, 15, false); def_edificio_servicio(,,,,,,,,,, true, 10); def_edificio_trabajo(true, 8, 20, 5,, 0.04,,,,,, 5)
		def_edificio_base("Capilla", 4, 3, 1100, 600, [1, 15, 26], [20, 5, 30], 10, 65); def_edificio_servicio(,, true,,, 12, 40); def_edificio_trabajo(true, 2, 60, 6, 1,,,,,,, 1.5)
		def_edificio_base("Hospicio", 4, 3, 1500, 1080, [1, 15, 24, 26], [20, 5, 5, 30], 15, 50); def_edificio_servicio(true,, true,,, 10, 30,, true, 20); def_edificio_trabajo(true, 5, 60, 8, 2,,,,,,, 1)
		def_edificio_base("Albergue", 4, 3, 1300, 600, [1, 15, 26], [20, 5, 30], 12, 40,,,,,,, true, 10, 25); def_edificio_servicio(,, true,,, 10, 30,, true, 10); def_edificio_trabajo(true, 3, 50, 5, 1,,,,,,, 1)
		def_edificio_base("Escuela parroquial", 4, 3, 1300, 720, [1, 15, 26], [20, 5, 30], 12, 45); def_edificio_servicio(,, true, true, 1, 10, 35, 10); def_edificio_trabajo(true, 5, 60, 6, 2,,,,,,, 1)
		//20
		def_edificio_base("Oficina de Construcción", 3, 2, 1000, 600, [1, 15, 24, 26], [10, 5, 10, 20], 8, 35); def_edificio_servicio(,,,,,,,,,, true, 30); def_edificio_trabajo(true, 6, 35, 5, 1, 0.03)
		def_edificio_base("Plaza", 2, 2, 200, 180, [1, 26], [5, 15], 4, 70, -15); def_edificio_servicio(, true,,,, 3, 10); def_edificio_trabajo()
		def_edificio_base("Oficina de Transporte", 3, 2, 800, 600, [1, 15, 26], [10, 5, 20], 6, 35); def_edificio_servicio(,,,,,,,,,, true, 30); def_edificio_trabajo(true, 6, 30, 4,, 0.01)
		def_edificio_base("Planta Siderúrgica", 5, 4, 2500, 1080, [1, 15, 24, 26], [30, 20, 20, 40], 25, 25, 20, false); def_edificio_servicio(,,,,,,,,,,true, 10); def_edificio_trabajo(true, 15, 30, 6,, 0.02, true, [9, 10], [2, 3], [15], [2], 1)
		def_edificio_base("Cabaret", 4, 3, 700, 450, [1, 15, 26], [20, 5, 20], 6, 30,, false); def_edificio_servicio(, true,,,, 6, 40, 3); def_edificio_trabajo(true, 4, 35, 6,, 0.01)
		def_edificio_base("Taller Textil", 5, 4, 3000, 900, [1, 15, 24, 26], [30, 10, 20, 40], 20, 30, 10, false); def_edificio_servicio(); def_edificio_trabajo(true, 15, 25, 5,, 0.01, true, [3, 20], [1, 1], [16], [1], 2)
		def_edificio_base("Astillero", 9, 6, 6200, 1800, [1, 15, 24, 26], [50, 40, 20, 40], 40, 40, 10, false, true); def_edificio_servicio(,,,,,,,,,, true, 40); def_edificio_trabajo(true, 30, 35, 4,, 0.02, true, [1, 7, 12, 16], [5, 1, 1, 1], [17], [0.1], 0.3)
		def_edificio_base("Rancho", 4, 4, 400, 180, [1], [30], 5, 45, -10, false,, true); def_edificio_servicio(,,,,,,,,,, true, 10, true, true, true); def_edificio_trabajo(true, 4, 40, 4,, 0.01,,,,,, 0.5)
		def_edificio_base("Destilería", 5, 4, 3500, 900, [1, 15, 24, 26], [25, 10, 25, 40], 20, 40, 5, false); def_edificio_servicio(,,,,,,,, true, 30); def_edificio_trabajo(true, 12, 40, 5,, 0.01, true, [5], [3], [22], [1], 1)
		def_edificio_base("Quesería", 5, 4, 2500, 720, [1, 15, 24, 26], [25, 10, 25, 40], 15, 40, 5, false,, true); def_edificio_servicio(); def_edificio_trabajo(true, 8, 40, 5,,, true, [19], [3], [23], [3], 0.5)
		//30
		def_edificio_base("Herrería", 5, 4, 3500, 1080, [1, 15, 24, 26], [25, 30, 20, 40], 20, 30, 15, false); def_edificio_servicio(); def_edificio_trabajo(true, 10, 30, 5,, 0.01, true, [1, 15, 21], [1, 1, 1], [24], [2], 0.5)
		def_edificio_base("Conventillo", 3, 3, 1000, 720, [1, 15, 25, 26], [10, 10, 10, 30], 4,, 15, false,,,,,true, 10, 40, 5, 20); def_edificio_servicio(,,,,,,,, true, 25, true, 25); def_edificio_trabajo()
		def_edificio_base("Toma", 1, 1,,,,,, 20, 5,,,,true ,, true, 1, 15); def_edificio_servicio(); def_edificio_trabajo()
		def_edificio_base("Delincuente"); def_edificio_servicio(); def_edificio_trabajo(,,10,,, 0.05)
		def_edificio_base("Comisaría", 4, 2, 900, 720, [1, 15, 26], [20, 25, 25], 12, 40); def_edificio_servicio(,,,,, 8); def_edificio_trabajo(true, 4, 40, 7,, 0.04,,,,,, 2)
		def_edificio_base("Mercado", 4, 4, 600, 360, [1, 15, 16, 26], [20, 5, 20, 20], 4, 40, 10, false); def_edificio_servicio(); def_edificio_trabajo(true, 4, 35, 4,,,,,,,, 20)
		def_edificio_base("Mueblería", 5, 4, 2500, 720, [1, 15, 24, 26], [25, 10, 20, 40], 20, 40, 5, false); def_edificio_servicio(); def_edificio_trabajo(true, 10, 30, 5,, 0.01, true, [1], [4], [25], [1], 0.75)
		def_edificio_base("Taller de Costura", 5, 4, 3000, 1080, [15, 24, 26], [30, 20, 40], 20, 35, 10, false); def_edificio_servicio(); def_edificio_trabajo(true, 6, 40, 5,, 0.02, true, [16, 21], [2, 1], [29], [2], 1.2)
		def_edificio_base("Tejar", 5, 4, 1500, 360, [1, 15, 26], [20, 10, 30], 7, 40, -5, false); def_edificio_servicio(); def_edificio_trabajo(true, 6, 30, 5,, 0.01,,,,,, 4)
		def_edificio_base("Refinería de Plásticos", 7, 8, 10000, 1440, [15, 24, 26], [50, 40, 100], 75, 10, 40, false,,,,,,,,, 130); def_edificio_servicio(); def_edificio_trabajo(true, 12, 20, 5, 1, 0.04, true, [27, 30], [3, 1], [32], [5], 3)
		//40
		def_edificio_base("Pozo Petrolífero", 4, 4, 3000, 730, [15, 26], [60, 30], 20, 20, -20, false,,,,,,,,, 60); def_edificio_servicio(,,,,,,,, true, 40, true, 30); def_edificio_trabajo(true, 4, 30, 5, 1, 0.03,,,,,, 4)
		def_edificio_base("Bomba de Agua", 4, 4, 3500, 1095, [15, 26], [40, 10], 15, 30, -15,, true,,,,,,,, 50); def_edificio_servicio(,,,,,,,,,, true, 30, true); def_edificio_trabajo(true, 4, 20, 4,, 0.01,,,,,, 28)
		def_edificio_base("Planta Termoeléctrica", 6, 3, 6000, 1800, [12, 15, 26], [100, 50, 50], 30, 25, -30,,,,,,,,,, 90); def_edificio_servicio(); def_edificio_trabajo(true, 6, 35, 7, 1, 0.01,,,,,, 28)
		def_edificio_base("Periódico", 4, 3, 1000, 800, [1, 15, 26], [20, 10, 10], 10, 60); def_edificio_servicio(, true,,,, 5, 30, 1); def_edificio_trabajo(true, 6, 50, 7, 2)
		def_edificio_base("Oficina de Bomberos", 4, 4, 1400, 1200, [15, 26], [30, 50], 12); def_edificio_servicio(,,,,,,,, true, 50); def_edificio_trabajo(true, 5, 40, 4, 2, 0.03,,,,,, 1)
		def_edificio_base("Armaría", 5, 4, 6000, 1095, [1, 15, 24, 26], [20, 30, 30, 40], 30, 20, 10, false); def_edificio_servicio(); def_edificio_trabajo(true, 8, 40, 8, 1, 0.05, true, [1, 14, 15], [1, 1, 1], [28], [1], 0.8)
		def_edificio_base("Banco", 6, 4, 2000, 1095, [1, 15, 26], [20, 15, 10], 8, 70,, false); def_edificio_servicio(,,,,,,,,,, true, 20); def_edificio_trabajo(true, 4, 70, 13, 3,,,,,,, 7)
		def_edificio_base("Mansión", 3, 2, 1000, 720, [11, 15, 25, 26], [10, 10, 20, 30], 8, 90,, false,,,,,true, 2, 80, 40, 50); def_edificio_servicio(,,,,,,,, true, 10, true, 10); def_edificio_trabajo(true, 3, 50, 3, 1)
		def_edificio_base("Departamentos", 5, 3, 1200, 1095, [15, 25, 26], [20, 10, 50], 6, 60, 20, false,,,,,true, 10, 50, 6, 100); def_edificio_servicio(,,,,,,,, true, 25, true, 25); def_edificio_trabajo()
		def_edificio_base("Bloque Habitacional", 4, 4, 1500, 1440, [15, 25, 26], [20, 10, 40], 12,, 15, false,,,,,true, 24, 30, 3, 130); def_edificio_servicio(,,,,,,,, true, 30, true, 40); def_edificio_trabajo()
		//50
		def_edificio_base("Planta Química", 5, 6, 10000, 1440, [15, 24, 26], [40, 40, 80], 50, 15, 30, false,,,,,,,,, 70); def_edificio_servicio(,,,,,,,, true, 25, true, 40); def_edificio_trabajo(true, 15, 30, 6, 2, 0.05, true, [10, 12], [1, 1], [30], [3], 1.3)
		def_edificio_base("Fábrica de Vehículos", 8, 6, 10000, 1440, [15, 24, 26], [40, 40, 80], 60, 20, 25, false,,,,,,,,, 110); def_edificio_servicio(,,,,,,,,,, true, 50); def_edificio_trabajo(true, 20, 35, 7, 2, 0.02, true, [15, 21, 24, 30], [3, 1, 1, 1], [31], [1], 0.3)
		def_edificio_base("Conservadora", 5, 4, 5000, 1095, [15, 24, 26], [20, 20, 40], 30, 30, 15, false,,,,,,,,, 50); def_edificio_servicio(,,,,,,,,,, true, 40); def_edificio_trabajo(true, 14, 30, 5,, 0.01, true, [10, 18], [0.1, 1], [34], [1], 0.5)
		def_edificio_base("Teatro", 5, 5, 2200, 1095, [1, 15, 26], [40, 15, 40], 12, 70,, false); def_edificio_servicio(, true,,,, 15, 60, 4); def_edificio_trabajo(true, 10, 50, 8, 1, 0.01)
		def_edificio_base("Cine", 4, 4, 3000, 1095, [1, 15, 24, 26], [40, 15, 10, 40], 15, 50,, false,,,,,,,,, 110); def_edificio_servicio(, true,,,, 25, 40, 1,,, true, 20); def_edificio_trabajo(true, 4, 35, 6)
		def_edificio_base("Cancha de fútbol", 4, 6, 500, 450, [1, 15], [20, 5], 5, 50,, false,,,,,,,,, 90); def_edificio_servicio(, true,,,, 30, 30, 1); def_edificio_trabajo(true, 11, 40, 5,, 0.01)
		def_edificio_base("Discoteca", 3, 3, 1400, 600, [15, 24, 26], [10, 5, 30], 12, 20, 10, false,,,,,,,,, 150); def_edificio_servicio(, true,,,, 10, 60, 1,,, true, 30); def_edificio_trabajo(true, 4, 30, 5,, 0.03)
		def_edificio_base("Antena de Radio", 3, 2, 1200, 730, [15, 24, 26], [15, 10, 15], 10,,,,,,,,,,,, 120); def_edificio_servicio(,,,,,,,,,, true, 30); def_edificio_trabajo(true, 2, 60, 10, 2,,,,,,, 10)
		def_edificio_base("Paneles Solares", 5, 5, 4000, 1800, [15, 26, 33], [20, 10, 20], 25,,,,,,,,,,,, 200); def_edificio_servicio(); def_edificio_trabajo(true, 1, 80, 15, 3)
		def_edificio_base("Prostitución"); def_edificio_servicio(); def_edificio_trabajo(,,10, 2,, 0.05)
		//60
		def_edificio_base("Depósito de Taxis", 3, 3, 2000, 540, [15, 31], [25, 10], 4, 35, 10,,,,,,,,,, 80); def_edificio_servicio(); def_edificio_trabajo(true, 4, 40, 5, 1, 0.02,,,,,, 5)
		def_edificio_base("Biblioteca", 3, 5, 1800, 720, [1, 15], [20, 10], 12, 70); def_edificio_servicio(, true,,,, 20, 50, 3); def_edificio_trabajo(true, 3, 60, 7, 2)
		def_edificio_base("Universidad", 5, 6, 12000, 1440, [1, 15, 24], [50, 30, 20], 25, 80); def_edificio_servicio(,,, true, 4, 20, 80, 3); def_edificio_trabajo(true, 5, 80, 14, 3)
		def_edificio_base("Estudio de Televisión", 3, 4, 2400, 1080, [15, 24, 26], [20, 15, 15], 20,,,,,,,,,,,, 150); def_edificio_servicio(,,,,,,,,,, true, 50); def_edificio_trabajo(true, 6, 50, 8, 2,,,,,,, 15)
		def_edificio_base("Hospital", 4, 4, 4000, 1440, [15, 24, 26], [25, 20, 30], 25, 60,,,,,,,,,,, 110); def_edificio_servicio(true,,,,,30, 70, 30, true, 30, true, 20); def_edificio_trabajo(true, 8, 70, 12, 3,,,,,,, 10)
		def_edificio_base("Prisión", 5, 5, 2200, 1080, [15, 26], [40, 60], 10, 20); def_edificio_servicio(,,,,, 40); def_edificio_trabajo(true, 4, 25, 4,, 0.04,,,,,, 4)
		def_edificio_base("Escuadra Naval", 8, 6, 4800, 1440, [1, 15, 17, 24, 28], [40, 20, 5, 20, 20], 25,,,, true); def_edificio_servicio(,,,,,,,,,,,, true); def_edificio_trabajo(true, 15, 40, 7, 1, 0.03)
	#endregion
	edificio_categoria_nombre = ["Residencial", "Materias Primas", "Servicios", "Entretenimiento", "Infrastructura", "Industria"]
	edificio_categoria = [	[8, 9, 10, 18, 31, 47, 48, 49],
							[4, 5, 14, 15, 27, 38, 40],
							[6, 7, 16, 21, 34, 35, 43, 46, 57, 61, 62, 63, 64, 65, 66],
							[11, 12, 24, 53, 54, 55, 56],
							[13, 20, 22, 41, 42, 44, 58, 60],
							[23, 25, 26, 28, 29, 30, 36, 37, 39, 45, 50, 51, 52]]
	edificio_color = []
	for(a = 0; a < array_length(edificio_nombre); a++){
		var flag = false
		for(b = 0; b < array_length(edificio_categoria); b++){
			for(var c = 0; c < array_length(edificio_categoria[b]); c++)
				if a = edificio_categoria[b, c]{
					array_push(edificio_color, b * 40 + c * 3)
					flag = true
					break
				}
			if flag
				break
		}
		if not flag
			array_push(edificio_color, 0)
		//Evaluación capital industria
		if debug and edificio_es_industria[a]{
			var text = $"{edificio_nombre[a]}: ";
			b = 0
			if edificio_industria_optativo[a]{
				b = infinity
				for(var c = 0; c < array_length(edificio_industria_input_id[a]); c++)
					b = min(b, recurso_precio[edificio_industria_input_id[a, c]] * edificio_industria_input_num[a, c])
			}
			else
				for(var c = 0; c < array_length(edificio_industria_input_id[a]); c++)
					b += recurso_precio[edificio_industria_input_id[a, c]] * edificio_industria_input_num[a, c]
			var d = 0
			for(var c = 0; c < array_length(edificio_industria_output_id[a]); c++)
				d += recurso_precio[edificio_industria_output_id[a, c]] * edificio_industria_output_num[a, c]
			var c = edificio_trabajadores_max[a] * edificio_industria_velocidad[a]
			text += $"Costos: input: ${c * b}, mant: ${edificio_mantenimiento[a]}, mano de obra: ${edificio_trabajadores_max[a] * edificio_trabajo_sueldo[a]} (${c * b + edificio_mantenimiento[a] + edificio_trabajo_sueldo[a] * edificio_trabajadores_max[a]})"
			text += $" -> Ganancia: ${c * d}"
			show_debug_message(text)
		}
		for(b = 0; b < array_length(edificio_recursos_id[a]); b++)
			if not array_contains(recurso_usado_construccion, edificio_recursos_id[a, b])
				array_push(recurso_usado_construccion, edificio_recursos_id[a, b])
	}
	array_set(edificio_color, 17, 88)
	array_set(edificio_color, 18, 88)
	array_set(edificio_color, 19, 88)
	null_edificio = {
		nombre : "NULL",
		familias : [null_familia],
		trabajadores : [null_persona],
		clientes : [null_persona],
		trabajos_cerca : [[]],
		casas_cerca : [],
		iglesias_cerca : [],
		comisaria : undefined,
		x : 0,
		y : 0,
		tipo : 0,
		dia_factura : 0,
		count : 0,
		almacen : [],
		pedido : [],
		eficiencia : 1,
		ahorro : 1,
		agua : false,
		energia : false,
		modo : 0,
		array_complex : [{a : 0, b : 0}],
		paro : false,
		huelga : false,
		huelga_motivo : 0,
		huelga_tiempo : 0,
		exigencia : undefined,
		exigencia_fallida : false,
		privado : false,
		vivienda_calidad : 0,
		vivienda_renta : 0,
		servicio_calidad : 0,
		servicio_max : 0,
		servicio_tarifa : 0,
		escuela_max : 0,
		trabajadores_max : 0,
		trabajadores_max_allow : 0,
		trabajo_calidad : 0,
		trabajo_sueldo : 0,
		trabajo_riesgo : 0,
		trabajo_educacion : 0,
		input_id : [0],
		input_num : [0],
		output_id : [0],
		output_num : [0],
		mantenimiento : 0,
		contaminacion : 0,
		presupuesto : 2,
		mes_creacion : 0,
		ganancia : 0,
		trabajo_mes : 0,
		muelle_cercano : undefined,
		distancia_muelle_cercano : 0,
		width : 0,
		height : 0,
		build_x : 0,
		build_y : 0,
		ladron : null_persona,
		venta : false,
		es_almacen : false,
		seguro_fuego : 0,
		zona_pesca : null_zona_pesca,
		mejoras : [],
		precio : 0,
		carreteras : [null_carretera]
	}
	array_pop(null_edificio.familias)
	array_pop(null_edificio.trabajadores)
	array_pop(null_edificio.clientes)
	array_pop(null_edificio.array_complex)
	array_push(null_edificio.trabajos_cerca[0], null_edificio)
	array_pop(null_edificio.trabajos_cerca[0])
	array_push(null_edificio.casas_cerca, null_edificio)
	array_pop(null_edificio.casas_cerca)
	array_push(null_edificio.iglesias_cerca, null_edificio)
	array_pop(null_edificio.iglesias_cerca)
	array_pop(null_edificio.input_id)
	array_pop(null_edificio.input_num)
	array_pop(null_edificio.output_id)
	array_pop(null_edificio.output_num)
	array_pop(null_edificio.carreteras)
	null_edificio.muelle_cercano = null_edificio
	null_edificio.comisaria = null_edificio
	edificios = [null_edificio]
	array_pop(edificios)
	escuelas = [null_edificio]
	array_pop(escuelas)
	casas = [null_edificio]
	array_pop(casas)
	casas_libres = [null_edificio]
	array_pop(casas_libres)
	trabajos = [null_edificio]
	array_pop(trabajos)
	iglesias = [null_edificio]
	array_pop(iglesias)
	array_push(null_carretera.edificios, null_edificio)
	array_pop(null_carretera.edificios)
	edificios_por_mantenimiento = []
	for(a = 0; a < 21; a++){
		array_push(edificios_por_mantenimiento, [null_edificio])
		array_pop(edificios_por_mantenimiento[a])
	}
	null_persona.trabajo = null_edificio
	null_persona.escuela = null_edificio
	null_persona.medico = null_edificio
	null_persona.ladron = null_edificio
#endregion
#region Mejoras
	mejoras_desbloqueadas = []
	mejoras = []
	null_mejora = def_mejora("null_mejora")
	array_pop(null_mejora.recurso_id)
	array_pop(null_mejora.recurso_num)
	array_pop(mejoras)
	mejora_acero_inoxidable = def_mejora("Acero inoxidable", "Mejora la producción de acero usando niquel", 115, 500, [24], [15],,,,, function(edificio = null_edificio){add_mantenimiento(1, edificio); add_industria_io(edificio, [9, 14], [- 0.5, 0.1], [15], [0.5])}, [15], 0.9)
	mejora_anestesia = def_mejora("Anestesia", "Mejora el servicio y consume químicos", 70, 500, [30], [10],,,,, function(edificio = null_edificio){edificio.ahorro += 0.2; add_mantenimiento(2, edificio); set_calidad_servicio(edificio); add_industria_io(edificio, [30], [0.1])}, [])
	mejora_barcos_a_vapor = def_mejora("Barcos a vapor", "Aumenta la eficiencia y contaminación, consume carbón", 70, 800, [15, 17, 24], [10, 1, 10],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.3; add_mantenimiento(5, edificio); add_contaminacion(10, edificio); add_industria_io(edificio, [9], [0.1])}, [8], 0.9)
	mejora_barcos_factoria = def_mejora("Barcos factoría", "Aumenta la eficiencia y contaminación, consume petróleo", 150, 1000, [17, 31], [2, 5],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.5; add_mantenimiento(3, edificio); add_contaminacion(10, edificio); set_trabajo_educacion(1, edificio); add_trabajo_sueldo(1, edificio); add_industria_io(edificio, [27], [0.5])}, [8], 0.8)
	mejora_bomba_a_vapor = def_mejora("Bomba de vapor", "Aumenta la eficiencia y consume carbón", 20, 400, [15, 24], [10, 10],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.2; add_mantenimiento(2, edificio); add_industria_io(edificio, [9], [0.1])}, [9, 22], 0.9)
	mejora_bomba_rotativa = def_mejora("Bomba rotativa", "Aumenta la producción y consumo de agua y electricidad", 130, 800, [24], [20], true, 10, true, 10, function(edificio = null_edificio){edificio.eficiencia += 0.4; edificio.ahorro += 0.5; add_mantenimiento(5, edificio)}, [27], 0.8)
	mejora_caldera_de_cristalizacion = def_mejora("Calderas de cristalización", "Aumenta la producción y contaminación", 30, 600, [24], [20],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.3; add_mantenimiento(3, edificio)}, [5], 0.8)
	mejora_camiones = def_mejora("Camiones", "Aumenta la eficiencia y contaminación, requiere trabajadores mejor instruidos y consume petróleo", 160, 600, [31], [15],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.4; add_mantenimiento(5, edificio); set_trabajo_educacion(1, edificio); add_trabajo_sueldo(1, edificio); add_industria_io(edificio, [27], [0.3])}, [9, 10, 11, 12, 13], 0.8)
	mejora_canaletas_y_dragas = def_mejora("Canaletas y Dragas", "Aumenta la eficiencia", 50, 300, [24], [10],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.1}, [11], 0.9)
	mejora_cianuracion = def_mejora("Cianuración", "Proceso que mejora la eficiencia y consume químicos", 100, 800, [24, 30], [20, 20],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.3; edificio.ahorro += 0.5; add_mantenimiento(10, edificio); add_industria_io(edificio, [30], [0.1])}, [11], 0.8)
	mejora_computadores = def_mejora("Computadores", "Aumenta la eficiencia y requiere trabajadores más instruidos", 180, 800, [33], [10],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.2; edificio.trabajo_riesgo *= 0.9; add_mantenimiento(1, edificio); set_trabajo_educacion(1, edificio); add_trabajo_sueldo(1, edificio)}, [9, 10, 11, 12, 13, 16, 17, 22, 24, 26, 28, 29, 30, 31, 32], 0.9)
	mejora_contenedores = def_mejora("Contenedores", "Aumenta la eficiencia", 160, 600, [15, 32], [15, 15],,,,, function(edificio = null_edificio){edificio.eficiencia += 1}, [34], 0.95)
	mejora_criptografia = def_mejora("Criptografía", "Aumenta la eficiencia y consumo eléctrico", 210, 500, [33], [10],,, true, 15, function(edificio = null_edificio){edificio.eficiencia += 0.5; add_mantenimiento(5, edificio)}, [])
	mejora_destilacion_fraccionada = def_mejora("Destilacion fraccionada", "Mejora la eficiencia", 30, 600, [24], [15],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.3; add_mantenimiento(2, edificio)}, [22, 23, 27], 0.85)
	mejora_esquiladora_electrica = def_mejora("Esquiladora eléctrica", "Aumental al producción y consumo eléctrico", 150, 500, [24], [10],,, true, 15, function(edificio = null_edificio){edificio.eficiencia += 0.3; add_mantenimiento(2, edificio)}, [20], 0.85)
	mejora_explosivos_mineros = def_mejora("Explosivos mineros", "Aumenta la eficiencia y riesgo, consume armas", 140, 600, [28], [15],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.2; edificio.trabajo_riesgo *= 1.2; add_mantenimiento(1, edificio); add_industria_io(edificio, [28], [0.1])}, [9, 10, 11, 12, 13], 0.9)
	mejora_ferrocarriles = def_mejora("Ferrocarriles", "Mejora le eficiencia general", 110, 800, [1, 15, 24], [20, 20, 10],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.3; add_mantenimiento(5, edificio); set_trabajo_educacion(1, edificio); add_trabajo_sueldo(1, edificio)}, [9, 10, 11, 12, 13, 17], 0.9)
	mejora_fertilizantes_sinteticos = def_mejora("Fertilizantes sintéticos", "Aumenta la eficiencia y la contaminación, consume químicos", 120, 400, [30], [20],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.2; add_mantenimiento(2, edificio); add_industria_io(edificio, [30], [0.1])}, [0, 2, 3, 4, 5, 6, 7], 0.9)
	mejora_filtros_industriales = def_mejora("Filtros industriales", "Disminuye la contaminación pero afecta la producción", 210, 300, [24], [10],,,,, function(edificio = null_edificio){edificio.eficiencia -= 0.2; edificio.ahorro += 0.2; add_mantenimiento(2, edificio); add_contaminacion(-15, edificio)}, [9, 10, 11, 12, 13, 22, 23, 30, 32], 1.1)
	mejora_fracking = def_mejora("Fracking", "Aumenta la producción, consumo de agua y contaminación", 145, 1000, [24], [10], true, 30, true, 10, function(edificio = null_edificio){edificio.eficiencia += 0.4; edificio.ahorro += 0.5; add_mantenimiento(5, edificio); add_contaminacion(15, edificio)}, [27], 0.8)
	mejora_frigorificos = def_mejora("Frigoríficos", "Aumenta la eficiencia y consumo eléctrico", 90, 500, [24], [10],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.3; add_mantenimiento(5, edificio)}, [2, 8, 18, 21, 30, 34], 0.85)
	mejora_gruas_a_vapor = def_mejora("Grúas a vapor", "Aumenta la eficiencia y consume carbón", 100, 1000, [24], [20],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.5; add_mantenimiento(8, edificio); add_industria_io(edificio, [9], [0.2])}, [17], 0.8)
	mejora_gruas_electricas = def_mejora("Grúas eléctricas", "Aumenta la eficiencia y consumo eléctrico", 140, 1000, [24], [15],,, true, 20, function(edificio = null_edificio){edificio.trabajo_riesgo *= 0.5; edificio.eficiencia += 0.5; add_mantenimiento(5, edificio); add_industria_io(edificio, [9], [-0.2])}, [17, 31], 0.8)
	mejora_horno_de_arco_electrico = def_mejora("Horno de arco eléctrico", "Aumenta la eficiencia y consumo eléctrico", 105, 1000, [24], [20],,, true, 30, function(edificio = null_edificio){edificio.eficiencia += 0.3; add_mantenimiento(-5, edificio)}, [15], 0.85)
	mejora_internet = def_mejora("Internet", "Aumenta la eficiencia", 195, 500, [33], [10],,, true, 5, function(edificio = null_edificio){edificio.ahorro += 0.2; edificio.eficiencia += 0.2; add_mantenimiento(-5, edificio); set_calidad_servicio(edificio); set_trabajo_educacion(1, edificio); add_trabajo_sueldo(1, edificio)}, [])
	mejora_latas_de_aluminio = def_mejora("Latas de aluminio", "Eemplaza el consumo de hierro por aluminio", 90, 400, [], [],,, true, 10, function(edificio = null_edificio){add_mantenimiento(-4, edificio); add_industria_io(edificio, [10, 13], [-0.1, 0.1])}, [34], 0.9)
	mejora_linea_de_montaje = def_mejora("Línea de montaje", "Aumenta la eficiencia y trabajadores", 140, 1000, [25], [20],,, true, 15, function(edificio = null_edificio){edificio.eficiencia += 0.3; set_trabajo_educacion(1, edificio); set_trabajadores_max(floor(edificio.trabajadores_max * 1.5), edificio); add_mantenimiento(10, edificio)}, [16, 24, 25, 28, 29, 30, 31, 32, 34], 0.8)
	mejora_maquina_desmotadora = def_mejora("Máquina desmotadora", "Mejora la eficiencia", 0, 400, [24], [10],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.4; add_mantenimiento(3, edificio)}, [3], 0.85)
	mejora_maquina_enroladora = def_mejora("Máquina enroladora", "Mejora la eficiencia", 80, 500, [24], [10],,, true, 15, function(edificio = null_edificio){edificio.eficiencia += 0.3; add_mantenimiento(3, edificio)}, [4], 0.9)
	mejora_maquinas_de_escribir = def_mejora("Máquinas de escribir", "Aumenta la eficiencia", 70, 500, [24], [10],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.4; add_mantenimiento(1, edificio); add_trabajo_sueldo(1, edificio)}, [])
	mejora_maquinas_de_escribir_electricas = def_mejora("Máquinas de escribir eléctricas", "Aumenta la eficiecia y consumo eléctrico", 150, 800, [24], [10],,, true, 5, function(edificio = null_edificio){edificio.eficiencia += 0.2; add_mantenimiento(1, edificio)}, [])
	mejora_maquinas_de_coser = def_mejora("Máquinas de coser", "Aumenta la eficiencia", 60, 600, [24], [15],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.5; set_trabajo_educacion(1, edificio); add_mantenimiento(3, edificio); add_trabajo_sueldo(1, edificio)}, [16, 29], 0.8)
	mejora_mineria_a_cielo_abierto = def_mejora("Minería a cielo abierto", "Aumenta la eficiencia y contaminación", 150, 500,,,,,,, function(edificio = null_edificio){edificio.eficiencia += 0.3; add_mantenimiento(-1, edificio); add_contaminacion(10, edificio)}, [9], 0.85)
	mejora_motor_de_diesel = def_mejora("Motor de diesel", "Reemplaza los motores de carbón por petróleo y mejora la eficiencia", 100, 600, [24], [15],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.2; add_industria_io(edificio, [9, 27], [-1, 0.1])}, [27], 1.1)
	mejora_motosierra = def_mejora("Motosierras", "Aumenta la producción y consumo eléctrico", 140, 400, [24], [10],,, true, 15, function(edificio = null_edificio){edificio.eficiencia += 0.3; add_mantenimiento(2, edificio); add_contaminacion(-5, edificio)}, [1, 25], 0.9)
	mejora_ordena_automatica = def_mejora("Ordeña automática", "Aumenta la producción y consumo eléctrico", 160, 500, [24], [10],,, true, 10, function(edificio = null_edificio){edificio.eficiencia += 0.4; set_trabajadores_max(floor(edificio.trabajadores_max * 0.6), edificio); add_mantenimiento(5, edificio)}, [19], 0.8)
	mejora_parlantes = def_mejora("Parlantes", "Aumenta la calidad de servicio", 120, 400, [24], [5],,, true, 10, function(edificio = null_edificio){edificio.eficiencia += 0.2; add_mantenimiento(1, edificio)})
	mejora_pasteurizacion = def_mejora("Pasteurización", "Mejora la producción", 130, 600, [24], [15],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.4; add_mantenimiento(5, edificio)}, [19, 23, 34], 0.8)
	mejora_penicilina = def_mejora("Penicilina", "Mejora el servicio", 110, 500, [30], [10],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.5; edificio.ahorro += 0.1; add_mantenimiento(2, edificio); set_calidad_servicio(edificio)}, [])
	mejora_pesca_por_arrastre = def_mejora("Pesca por arrastre", "Aumenta la eficiencia y contaminación", 50, 500, [7], [40],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.5; add_contaminacion(5, edificio)}, [8], 0.8)
	mejora_pestisidas = def_mejora("Pestisidas", "Aumenta la eficiencia y contaminación, consume químicos", 165, 400, [30], [20],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.2; add_mantenimiento(1, edificio); add_contaminacion(10, edificio); add_industria_io(edificio, [30], [0.1])}, [0, 2, 3, 4, 5, 6, 7], 0.9)
	mejora_prensadora_a_vapor = def_mejora("Prensadora a vapor", "Aumenta la producción y consume carbón", 50, 800, [24], [15], true, 10,,, function(edificio = null_edificio){edificio.eficiencia += 0.4; add_mantenimiento(3, edificio); add_industria_io(edificio, [9], [0.2])}, [24, 26, 28], 0.8)
	mejora_proceso_bassemer = def_mejora("Proceso Bassemer", "Aumenta la eficiencia", 60, 1000, [24], [20],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.5; add_mantenimiento(-5, edificio)}, [15], 0.75)
	mejora_proceso_electrolitico = def_mejora("Proceso electrolítico", "Aumenta la eficiencia y consumo eléctrico", 130, 800, [24], [20], true, 10, true, 20, function(edificio = null_edificio){edificio.eficiencia += 0.1; add_mantenimiento(5, edificio); add_contaminacion(-10, edificio)}, [12, 30], 0.9)
	mejora_purificacion_con_cal_viva = def_mejora("Purificación con cal viva", "Mejora la producción", 50, 200,,,,,,, function(edificio = null_edificio){edificio.eficiencia += 0.1; add_mantenimiento(1, edificio)}, [5], 0.9)
	mejora_reciclaje_de_materiales = def_mejora("Reciclaje de materiales", "Reduce el impacto medioambiental", 160, 400,,,,,,, function(edificio = null_edificio){edificio.ahorro += 0.5; add_mantenimiento(-5, edificio); add_contaminacion(-10, edificio)}, [12, 13, 26, 29, 30, 32], 1.1)
	mejora_riego_por_goteo = def_mejora("Riego por goteo", "Mejora la eficiencia y cuidado mediambiental", 200, 200,,, true,,,, function(edificio = null_edificio){add_mantenimiento(-2, edificio); add_contaminacion(-10, edificio)}, [0, 2, 3, 4, 5, 6, 7], 1)
	mejora_segadora = def_mejora("Segadora", "Mejora la eficiencia", 70, 400, [24], [10],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.2; add_mantenimiento(1, edificio)}, [0], 0.9)
	mejora_sierras_a_vapor = def_mejora("Sierras a vapor", "Aumenta la producción y consume carbón", 80, 800, [15, 24], [10, 10],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.4; add_mantenimiento(5, edificio); add_contaminacion(-10, edificio); add_industria_io(edificio, [9], [0.2])}, [1], 0.85)
	mejora_tractores = def_mejora("Tractores", "Aumenta mucho la eficiencia, requiere menos trabajadores más instruidos y consume petróleo", 130, 700, [31], [5],,,,, function(edificio = null_edificio){edificio.eficiencia += 1; edificio.trabajo_sueldo += 2; set_trabajo_educacion(1, edificio); set_trabajadores_max(floor(edificio.trabajadores_max * 0.5), edificio); add_trabajo_sueldo(1, edificio); add_mantenimiento(-5, edificio); add_industria_io(edificio, [27], [0.2])}, [0, 1, 2, 3, 4, 5, 6, 7], 0.8)
	mejora_trapiche_hidraulico = def_mejora("Trapiche hidráulico", "Mejora la eficiencia", 20, 400, [24], [10],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.3; add_mantenimiento(1, edificio)}, [3, 4, 5], 0.85)
	mejora_trilladora = def_mejora("Trilladora", "Mejora la eficiencia", 100, 400, [24], [15],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.3; add_mantenimiento(2, edificio)}, [0], 0.85)
	mejora_uso_de_drones = def_mejora("Uso de drones", "Aumenta el rendimiento y requiere menos trabajdores más instruidos", 220, 400, [24, 33], [10, 15],,, true, 5, function(edificio = null_edificio){edificio.eficiencia += 1; add_mantenimiento(1, edificio); set_trabajo_educacion(2, edificio); set_trabajadores_max(floor(edificio.trabajadores_max * 0.5), edificio); add_trabajo_sueldo(4, edificio)}, [0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 24, 27, 31, 32], 0.8)
	mejora_vacunas = def_mejora("Vacunas", "Mejora la eficiencia y consume químicos", 140, 500, [30], [10],,,,, function(edificio = null_edificio){edificio.eficiencia += 0.2; add_mantenimiento(2, edificio); add_industria_io(edificio, [30], [0.1])}, [18, 19, 20, 21], 0.9)
	for(a = 0; a < array_length(mejoras); a++){
		var mejora = mejoras[a]
		for(b = 0; b < array_length(mejora.recurso_id); b++)
			if not array_contains(recurso_usado_mejoras, mejora.recurso_id[b])
				array_push(recurso_usado_mejoras, mejora.recurso_id[b])
	}
#endregion
#region Empresas
	null_empresa = {
		jefe : null_persona,
		dinero : 0,
		edificios : [null_edificio],
		nacional : false,
		nombre : "",
		quiebra : false,
		dia_factura : irandom(29),
		terreno : [{a : 0, b : 0}],
		ventas : [],
		construcciones : undefined
	}
	array_pop(null_empresa.edificios)
	array_pop(null_empresa.terreno)
	null_persona.empresa = null_empresa
	empresas = [null_empresa]
	array_pop(empresas)
	for(a = 0; a < 30; a++){
		dia_empresas[a] = [null_empresa]
		array_pop(dia_empresas[a])
	}
	empresa_comprado = null_empresa
	null_construccion = add_construccion(true)
	null_empresa.construcciones = [null_construccion]
	array_pop(null_empresa.construcciones)
	cola_construccion = [null_construccion]
	array_pop(cola_construccion)
	null_venta = {
		edificio : null_edificio,
		precio : 0,
		width : 0,
		height : 0,
		estatal : true,
		empresa : null_empresa
	}
	array_push(null_empresa.ventas, null_venta)
	array_pop(null_empresa.ventas)
	edificios_a_la_venta = [null_venta]
	array_pop(edificios_a_la_venta)
	for(a = 0; a < array_length(educacion_nombre); a++)
		array_set(null_edificio.trabajos_cerca, a, [])
	for(a = 0; a < 30; a++){
		dia_trabajo[a] = [null_edificio]
		array_pop(dia_trabajo[a])
	}
	for(a = 0; a < array_length(recurso_nombre); a++){
		array_push(null_edificio.almacen, 0)
		array_push(null_edificio.pedido, 0)
		recurso_banda[a] = false
		recurso_banda_min[a] = 0
		recurso_banda_max[a] = 0
	}
	current_mes = 0
	null_terreno = {
		x : 0,
		y : 0,
		width : 0,
		height : 0,
		privado : false,
		empresa : null_empresa
	}
	terrenos_venta = [null_terreno]
	array_pop(terrenos_venta)
#endregion
#region Exigenicas
	exigencia_nombre = [
		"Abre un nuevo edificio médico",
		"Abre un nuevo edificio educativo",
		"Que nadie muera de inanición en 3 meses",
		"Abre un nuevo edificio de ocio",
		"Abre un nuevo edificio religioso",
		"Trata a todos los enfermos",
		"Aumenta la felicidad alimenticia a 50"]
	exigencia_siguiente = [5, 1, 6, 3, 4, 5, 6]
	null_exigencia = {
		index : 0,
		expiracion : 0,
		value : 0,
		edificios : [null_edificio]
	}
	for(a = 0; a < array_length(exigencia_nombre); a++){
		exigencia_pedida[a] = false
		exigencia[a] = null_exigencia
		exigencia_cumplida[a] = false
		exigencia_cumplida_time[a] = 0
	}
	array_pop(null_exigencia.edificios)
	null_edificio.exigencia = null_exigencia
	felicidad_minima = 20
#endregion
#region Edificios ficticios
	edificios_ocio_index = []
	edificio_almacen_index = []
	edificio_experiencia = []
	for(a = 0; a < array_length(edificio_nombre); a++){
		if edificio_es_ocio[a]{
			null_persona.ocios[a] = 0
			array_push(edificios_ocio_index, a)
		}
		if edificio_es_almacen[a]
			array_push(edificio_almacen_index, a)
		edificio_count[a] = [null_edificio]
		edificio_number[a] = 0
		array_pop(edificio_count[a])
		almacenes[a] = [null_edificio]
		array_pop(almacenes[a])
		array_push(edificio_experiencia, 1)
	}
	for(a = 0; a < array_length(recurso_cultivo); a++)
		edificio_number_granja[a] = 0
	for(a = 0; a < array_length(recurso_mineral); a++)
		edificio_number_mina[a] = 0
	for(a = 0; a < array_length(ganado_nombre); a++)
		edificio_number_rancho[a] = 0
	jubilado = add_edificio(0, 0, 1, false)
	desausiado = add_edificio(0, 0, 2, false)
	medicos = [desausiado]
	homeless = add_edificio(0, 0, 3, false)
	null_familia.casa = homeless
	delincuente = add_edificio(0, 0, 33, false)
	prostituta = add_edificio(0, 0, 59, false)
#endregion
//Settings
#region Diseño del mundo
	xsize = 240 / (1 + debug)
	ysize = 240 / (1 + debug)
	for(a = 0; a < array_length(recurso_cultivo); a++)
		cultivo[a] = perlin(xsize, ysize, 1, false, 6)
	var mineral_grid
	for(a = 0; a < array_length(recurso_mineral); a++)
		mineral_grid[a] = perlin(xsize, ysize, 1, false, 6)
	var grid = perlin(xsize, ysize, 1, false), grid_petroleo = perlin(xsize, ysize, 1, false)
	altura = perlin(xsize, ysize, 1, false)
	for(a = 0; a < xsize / 2; a += 3)
		ds_grid_add_disk(altura, floor(xsize / 2), floor(ysize / 2), a, 0.05)
	a = ds_grid_get_max(altura, 0, 0, xsize, ysize)
	ds_grid_multiply_region(altura, 0, 0, xsize, ysize, 1 / a)
	var mar_checked, land_checked, land_matrix, mares = [[{a : 0, b : 0}]], prev_mar = mares[0], prev_mar_bool = true, temp_mar, temp_array = [true]
	for(a = 1; a < array_length(edificio_categoria_nombre); a++)
		array_push(temp_array, false)
	var temp_array_length = array_length(temp_array)
	array_pop(mares[0])
	var temp_color_array = [c_red, c_red, c_red, c_red, c_red, c_red, c_red]
	calle = ds_grid_create(xsize, ysize)
	ds_grid_clear(calle, false)
	calle_sprite = ds_grid_create(xsize, ysize)
	ds_grid_clear(calle_sprite, 0)
	calle_carretera = ds_grid_create(xsize, ysize)
	ds_grid_clear(calle_carretera, null_carretera)
	bool_edificio = ds_grid_create(xsize, ysize)
	ds_grid_clear(bool_edificio, false)
	bosque_venta = ds_grid_create(xsize, ysize)
	ds_grid_clear(bosque_venta, false)
	id_edificio = ds_grid_create(xsize, ysize)
	ds_grid_clear(id_edificio, null_edificio)
	escombros = ds_grid_create(xsize, ysize)
	ds_grid_clear(escombros, false)
	bool_draw_edificio = ds_grid_create(xsize, ysize)
	ds_grid_clear(bool_draw_edificio, false)
	construccion_reservada = ds_grid_create(xsize, ysize)
	ds_grid_clear(construccion_reservada, false)
	bool_draw_construccion = ds_grid_create(xsize, ysize)
	ds_grid_clear(bool_draw_construccion, false)
	draw_edificio = ds_grid_create(xsize, ysize)
	ds_grid_clear(draw_edificio, null_edificio)
	draw_construccion = ds_grid_create(xsize, ysize)
	ds_grid_clear(draw_construccion, null_construccion)
	draw_edificio_flip = ds_grid_create(xsize, ysize)
	ds_grid_clear(draw_edificio_flip, false)
	bosque = ds_grid_create(xsize, ysize)
	ds_grid_clear(bosque, false)
	contaminacion = ds_grid_create(xsize, ysize)
	ds_grid_clear(contaminacion, 0)
	zona_privada = ds_grid_create(xsize, ysize)
	ds_grid_clear(zona_privada, false)
	zona_empresa = ds_grid_create(xsize, ysize)
	ds_grid_clear(zona_empresa, null_empresa)
	zona_privada_venta = ds_grid_create(xsize, ysize)
	ds_grid_clear(zona_privada_venta, false)
	petroleo = ds_grid_create(xsize, ysize)
	ds_grid_clear(petroleo, 0)
	zona_privada_permisos = ds_grid_create(xsize, ysize)
	ds_grid_clear(zona_privada_permisos, [false, false, false, false, false, false])
	zona_privada_venta_terreno = ds_grid_create(xsize, ysize)
	ds_grid_clear(zona_privada_venta_terreno, null_terreno)
	zona_pesca_num = ds_grid_create(xsize, ysize)
	ds_grid_clear(zona_pesca_num, 0)
	//Ciclo principal
	for(a = 0; a < xsize; a++)
		for(b = 0; b < ysize; b++){
			var c = altura[# a, b], temp_bosque = grid[# a, b], temp_petroleo = grid_petroleo[# a, b]
			if brandom()
				ds_grid_set(draw_edificio_flip, a, b, true)
			cultivo_color[a, b] = temp_color_array
			if c > 0.62 and temp_bosque > 0.7{
				ds_grid_set(bosque, a, b, true)
				var d = floor(350 * temp_bosque)
				bosque_madera[a, b] = d
				bosque_max[a, b] = d
			}
			mar[a, b] = false
			if c < 0.5{
				if not prev_mar_bool{
					if a > 0 and mar[a - 1, b]
						prev_mar = temp_mar[a - 1, b]
					else{
						prev_mar = [{a : a, b : b}]
						array_push(mares, prev_mar)
					}
				}
				else if a > 0 and mar[a - 1, b] and temp_mar[a - 1, b] != prev_mar{
					if array_length(temp_mar[a - 1, b]) > array_length(prev_mar)
						var new_array = temp_mar[a - 1, b]
					else{
						new_array = prev_mar
						prev_mar = temp_mar[a - 1, b]
					}
					while array_length(prev_mar) > 0{
						var complex = array_shift(prev_mar)
						temp_mar[complex.a, complex.b] = new_array
						array_push(new_array, complex)
					}
					array_remove(mares, prev_mar)
					prev_mar = new_array
				}
				array_set(mar[a], b, true)
				temp_mar[a, b] = prev_mar
				array_push(prev_mar, {a : a, b : b})
				prev_mar_bool = true
			}
			else
				prev_mar_bool = false
			altura_color[a, b] = c_gray
			if mar[a, b]
				altura_color[a, b] = make_color_rgb(63 * c, 63 * c, 255 * c)
			else if c < 0.6
				altura_color[a, b] = make_color_rgb(255 / 0.65 * (1.1 - c), 255 / 0.65 * (1.1 - c), 127)
			else
				altura_color[a, b] = make_color_rgb(31 + 96 * c, 127, 31 + 96 * c)
			if not mar[a, b]{
				var e = 0, f = 0, temp_color_array_2 = []
				for(var d = 0; d < array_length(recurso_cultivo); d++){
					var temp_altura_minima = cultivo_altura_minima[d], temp_cultivo = cultivo[d]
					if c < temp_altura_minima
						ds_grid_set(temp_cultivo, a, b, 0)
					else if c < temp_altura_minima + 0.05
						ds_grid_multiply(temp_cultivo, a, b, 20 * (c - temp_altura_minima))
					var g = temp_cultivo[# a, b]
					array_push(temp_color_array_2, make_color_rgb(255 * (1 - g), 255 * g, 0))
					if e < temp_cultivo[# a, b]{
						e = max(e, temp_cultivo[# a, b])
						f = d
					}
				}
				array_set(cultivo_color[a], b, temp_color_array_2)
				cultivo_max[a, b] = f
			}
			for(var d = 0; d < array_length(recurso_mineral); d++){
				var temp_mineral = mineral_grid[d][# a, b], bool_a = (temp_mineral > recurso_mineral_rareza[d])
				mineral[d][a, b] = bool_a
				if bool_a
					mineral_cantidad[d][a, b] = round(750 * temp_mineral * temp_mineral * temp_mineral)
			}
			belleza[a, b] = 50 + floor(100 * (0.6 - min(0.6, c)))
			if temp_petroleo > 0.85
				ds_grid_set(petroleo, a, b, floor(10000 * (temp_petroleo - 0.85)))
			mar_checked[a, b] = false
			land_checked[a, b] = false
			land_matrix[a, b] = false
		}
	world_update = true
	for(a = 0; a < xsize / 16; a++)
		for(b = 0; b < ysize / 16; b++){
			chunk[a, b] = spr_null_chunk
			chunk_update[a, b] = true
		}
	for(a = 1; a < array_length(mares); a++)
		for(b = 0; b < array_length(mares[a]); b++){
			var complex = mares[a, b], c = complex.a, d = complex.b, e = 0.45 + altura[# c, d] / 10
			array_set(mar[c], d, false)
			ds_grid_set(altura, c, d, e)
			array_set(altura_color[c], d, make_color_rgb(255 / 0.65 * (1.1 - e), 255 / 0.65 * (1.1 - e), 127))
			array_set(cultivo_color[c], d,
			temp_color_array)
		}
	mares[0] = array_shuffle(mares[0])
	var yes_land = [{a : floor(xsize / 2), b : floor(ysize / 2)}]
	array_set(land_checked[floor(xsize / 2)], floor(ysize / 2), true)
	array_set(land_matrix[floor(xsize / 2)], floor(ysize / 2), true)
	while array_length(yes_land) > 0{
		var complex = array_shift(yes_land)
		a = complex.a
		b = complex.b
		array_set(land_matrix[a], b, true)
		var a1 = max(0, a - 1), b1 = max(0, b - 1), a2 = min(xsize - 1, a + 1), b2 = min(ysize - 1, b + 1)
		if not mar[a1, b] and not land_checked[a1, b]{
			array_set(land_checked[a1], b, true)
			array_push(yes_land, {a : a1, b : b})
		}
		if not mar[a, b1] and not land_checked[a, b1]{
			array_set(land_checked[a], b1, true)
			array_push(yes_land, {a : a, b : b1})
		}
		if not mar[a2, b] and not land_checked[a2, b]{
			array_set(land_checked[a2], b, true)
			array_push(yes_land, {a : a2, b : b})
		}
		if not mar[a, b2] and not land_checked[a, b2]{
			array_set(land_checked[a], b2, true)
			array_push(yes_land, {a : a, b : b2})
		}
	}
	zonas_pesca = []
	repeat(min(floor(xsize * ysize / 1600), 100)){
		while array_length(mares[0]) > 0{
			temp_complex = array_shift(mares[0])
			a = temp_complex.a
			b = temp_complex.b
			if zona_pesca_num[# a, b] = 0
				break
		}
		if array_length(mares[0]) = 0
			break
		var c = floor(random_range(1500, 3000) / max(0.3, altura[# a, b]))
		array_push(zonas_pesca, {
			a : a,
			b : b,
			cantidad : c,
			cantidad_max : c
		})
		ds_grid_add_region(zona_pesca_num, max(0, a - 5), max(0, b - 5), min(xsize - 1, a + 4), min(ysize - 1, b + 4), 1)
	}
#endregion
#region Setings
	draw_set_font(font_normal)
	sel_info = false
	sel_edificio = null_edificio
	sel_familia = null_familia
	sel_persona = null_persona
	sel_construccion = null_construccion
	sel_terreno = null_terreno
	sel_carretera = null_carretera
	sel_tipo = 0
	sel_build = false
	sel_modo = false
	sel_cerca = false
	sel_comisaria = false
	build_sel = false
	build_index = 0
	build_type = 0
	subministerio = 0
	build_x = 0
	build_y = 0
	build_pressed = false
	build_terreno = false
	build_terreno_permisos = temp_array
	build_calle = false
	last_width = 0
	last_height = 0
	show_grid = false
	show_scroll = 0
	tile_width = 32
	tile_height = 16
	menu = false
	menu_principal = true
	iniciado = false
	draw_set_halign(fa_center)
	cursor = cr_arrow
	tutorial_bool = false
	tutorial_complete = false
	tutorial = 0
	tutorial_enter = [true, true, true, true, false, true, true, false, false, false, false, true, false, false, false, false, true, false, false, true, false, true, true]
	tutorial_camara = [false, false, true, true, false, false, false, false, true, true, false, false, true, true, true, true, true, true, true, false, false, false, false]
	tutorial_xbox =  [0, 0, 0, 0, 0, 100, 100, 100, 0, 0, 0, room_width - 300, 0, 0, 0, 0, 0, 0, 0, 100, 100, 100, 0]
	tutorial_ybox = [0, 0, 0, 0, 0, 80, room_height - 100, 100, 0, 0, 0, 0, 80, 80, 80, 80, 80, 80, 80, 100, room_height - 100, 100, 110]
	tutorial_wbox = [0, 0, 0, 0, room_width, room_width - 100, room_width - 100, 240, room_width, room_width, 0, room_width, room_width, room_width, room_width, room_width, room_width, room_width, room_width, 350, room_width - 100, room_width - 100, room_width]
	tutorial_hbox = [0, 0, 0, 0, room_height, 100, room_height - 80, 120, room_height, room_height, 0, room_height, room_height, room_height, room_height, room_height, room_height, room_height, room_height, room_height - 100, room_height - 80, room_height - 100, room_height]
	tutorial_xtext = [room_width / 2, 0, room_width / 2, room_width / 2, room_width / 2, room_width / 2, room_width / 2, room_width / 2, room_width / 2, room_width / 2, room_width / 2, room_width / 4, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200]
	tutorial_ytext = [200, 0, 400, 400, 400, 200, 500, 400, 400, 400, 400, 400, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	tutorial_text = [	"Bienvenido a tu propio paraíso tropical\n Aquí aprederás lo básico para manejar tu país",
						"Primero lo importante, aquí verás la fecha, la población y tu dinero disponible",
						"Mueve la cámara arrastrando el mouse cerca del borde",
						"Haz zoom con [Control] + [la rueda del mouse]",
						"Abramos el menú de construcciones y ministros\nHaz [clic derecho]",
						"Aquí encontrarás los edificios disponibles\nordenados por categorias",
						"Aquí están tus ministros, donde puedes\nconsultar información sobre la isla",
						"Vamos a construir una Chabola",
						"Selecciona algún lugar disponible",
						"Ahora espera a que se construya\nMientras tanto, estos son los controles del tiempo\nAdemás puedes adelantar días manteniendo [Espacio]",
						//10
						"Listo! Ahora selecciona la Chabola con [clic izquierdo]\npara ver su información detallada",
						"Aquí se encuentra la información del edificio\n  Las familias que viven aquí\n  Los trabajadores que trabajan aquí\n  Los recursos que tiene almacenado\n  Y mucho más",
						"Ahora construye una granja\nLa granja la encontrarás en el panel de Materias primas",
						"Las granjas necesitan un suelo adecuando para funcionar\nBusca un lugar donde su eficiciencia sea alta (verde) para construirla\nPresiona [clic izquierdo] y arrastra para elegir su tamaño",
						"Bien hecho, los ciudadanos necesitarán comida y podrán producirla en la granja\nAhora construye un aserradero para empezar a exportar recursos",
						"Los aserraderos necesitan árboles cerca para ser construidos\nMientras más árboles tenga, más madera podrá extraer",
						"Bien hecho, el aserradero extraerá madera cuando tenga trabajadores\n2 veces al año esta madera se exportará en el muelle",
						"Ahora, otra cosa importante para tu isla es satisfacer las demandas de la población\nConstruye una escuela para mejorar la felicidad de la gente\nLa escuela está en el panel de Servicios",
						"Bien.  Los ciudadanos tienes ciertas necesidades que hay que cumplir\nLo más importante es alimentación y salud, no quieres que mueran tus votantes\nRevísalas en el Ministerio de Población [clic derecho]",
						"Aquí puedes revisar el flujo de población, edades y felicidades\nSi haces [clic izquierdo] en Felicidad podrás ver el detalle\nSi los ciudadanos son muy infelices, podrá emigrar y protestar",
						//20
						"Otro ministerio importante es el de Economía",
						"Aquí podrás ver como la isla gana y pierde dinero\nAdemás podrás controlar las importaciones y exportaciones",
						"Felicidades, eso es todo por ahora\nHay montones más de cosas y detalles en tu isla, pero tendrás que descubrirlas tú\n¡Larga vida al presidente!"]
	tutorial_keys = [[], [], [], [vk_lcontrol], [], [vk_escape], [vk_escape], [vk_escape], [vk_lcontrol], [vk_space], [], [], [], [vk_space, vk_lcontrol], [], [vk_space, vk_lcontrol], [], [vk_space, vk_lcontrol], [], [], [], [vk_lcontrol], []]
	tutorial_mouse = [[], [], [], [], [mb_right], [], [], [mb_left], [mb_left], [mb_left], [mb_left], [], [mb_left, mb_right], [mb_left, mb_right], [mb_left, mb_right], [mb_left, mb_right], [], [mb_left, mb_right], [mb_left, mb_right], [mb_left, mb_right], [mb_left, mb_right], [mb_left, mb_right], []]
	var cursed_keys = [vk_space, vk_lcontrol]
	var cursed_mouse = [mb_left, mb_right]
	for(a = 0; a < array_length(tutorial_text); a++){
		for(b = 0; b < array_length(cursed_mouse); b++){
			if array_contains(tutorial_mouse[a], cursed_mouse[b])
				array_remove(tutorial_mouse[a], cursed_mouse[b])
			else
				array_push(tutorial_mouse[a], cursed_mouse[b])
		}
		for(b = 0; b < array_length(cursed_keys); b++){
			if array_contains(tutorial_keys[a], cursed_keys[b])
				array_remove(tutorial_keys[a], cursed_keys[b])
			else
				array_push(tutorial_keys[a], cursed_keys[b])
		}
		if tutorial_enter[a]
			if a = array_length(tutorial_text) - 1
				tutorial_text[a] += "\n[Enter] para terminar"
			else
				tutorial_text[a] += "\n[Enter] para continuar"
	}
	step = 0
	velocidad = 1
	rotado = false
	impuesto_empresa_fijo = 0
	impuesto_empresa = 10
	impuesto_maderero = 0.2
	impuesto_minero = 0.2
	impuesto_petrolifero = 0.2
	impuesto_trabajador = 0
	impuesto_pesquero = 0.1
	valor_terreno = 10
	agua_input = 0
	agua_output = 0
	energia_input = 0
	energia_output = 0
	for(a = 0; a < 12; a++){
		mes_muertos_enfermos[a] = 0
		mes_emigrantes[a]  = 0
		mes_muertos_viejos[a] = 0
		mes_muertos_accidentes[a] = 0
		mes_muertos_asesinados[a] = 0
		mes_muertos_inanicion[a] = 0
		mes_inmigrantes[a] = 0
		mes_nacimientos[a] = 0
		mes_renta[a] = 0
		mes_mantenimiento[a] = 0
		mes_sueldos[a] = 0
		mes_exportaciones[a] = 0
		mes_herencia[a] = 0
		mes_construccion[a] = 0
		mes_tarifas[a] = 0
		mes_importaciones[a] = 0
		mes_compra_interna[a] = 0
		mes_venta_interna[a] = 0
		mes_estatizacion[a] = 0
		mes_privatizacion[a] = 0
		mes_impuestos[a] = 0
		mes_accidentes[a] = 0
		mes_investigacion[a] = 0
		mes_venta_comida[a] = 0
		mes_entrada_micelaneo[a] = 0
		mes_salida_micelaneo[a] = 0
		mes_comida_privada[a] = 0
		for(b = 0; b < array_length(recurso_nombre); b++){
			mes_exportaciones_recurso[a, b] = 0
			mes_exportaciones_recurso_num[a, b] = 0
			mes_importaciones_recurso[a, b] = 0
			mes_importaciones_recurso_num[a, b] = 0
			mes_compra_recurso[a, b] = 0
			mes_compra_recurso_num[a, b] = 0
			mes_venta_recurso[a, b] = 0
			mes_venta_recurso_num[a, b] = 0
		}
	}
	for(a = 0; a < array_length(edificio_nombre) * 2; a++)
		show[a] = false
	show_noticia = -1
	getstring = false
	getstring_title = ""
	getstring_default = ""
	getstring_function = function(a, b){}
	getstring_param = []
	show_string = ""
	mouse_string = ""
	felicidad_total = felicidad_minima
	dinero = 20000
	inversion_privada = 0
	dinero_privado = 0
	prev_beneficio_privado = 0
	credibilidad_financiera = 3
	tratados_num = 0
	tratados_max = 2
	mejora_requiere_agua = false
	mejora_requiere_energia = false
	pos = 0
	wpos = 0
	deuda = false
	deuda_dia = 0
	var_total_comida = 360
	esperanza_de_vida_sum = 0
	esperanza_de_vida_num = 0
	radioemisoras = 0
	television = 0
	dia_radioemisoras = []
	dia_television = []
	dia_energia = []
	dia_agua = []
	dia_naval = []
	repeat(30){
		array_push(dia_radioemisoras, 0)
		array_push(dia_television, 0)
		array_push(dia_energia, 0)
		array_push(dia_agua, 0)
		array_push(null_carretera.dia_taxis, 0)
		array_push(dia_naval, 0)
	}
	probabilidad_hijos = 0
	adoctrinamiento = 1
	adoctrinamiento_escuelas = true
	adoctrinamiento_biblioteca = false
	adoctrinamiento_universidades = false
	adoctrinamiento_periodico = true
	adoctrinamiento_prision = true
	pirateria = 50
	naval = 0
	null_encargo = {
		recurso : 0,
		cantidad : 0,
		edificio : null_edificio
	}
	encargos = [null_encargo]
	array_pop(encargos)
	anno_felicidad = [felicidad_total]
	repeat(10)
		generar_tratado()
	repeat(10)
		add_empresa(power(10, random_range(3, 4.2)))
	while array_length(personas) < 80
		add_familia(pais_tropico)
	personas = array_shuffle(personas)
#endregion
#region Edificios iniciales
	#region Puerto principal
		var c = xsize - edificio_width[13], d = ysize - edificio_height[13]
		do{
			a = irandom(c)
			b = irandom(d)
		}
		until land_matrix[a, b] and edificio_valid_place(a, b, 13)
		null_edificio.muelle_cercano = add_edificio(a, b, 13)
		edificios[0].almacen[0] = irandom_range(1000, 1500)
		recurso_exportado[0] = false
	#endregion
	xpos = (a - b) * tile_width - room_width / 2
	ypos = (a + b) * tile_height - room_height / 2
	min_camx = max(0, floor((xpos / tile_width + ypos / tile_height) / 2))
	min_camy = max(0, floor((ypos / tile_height - (xpos + room_width) / tile_width) / 2))
	max_camx = min(xsize, ceil(((room_width + xpos) / tile_width + (room_height + ypos) / tile_height) / 2))
	max_camy = min(ysize, ceil(((room_height + ypos) / tile_height - xpos / tile_width) / 2))
	var coord, checked = [], e = max(0, edificios[0].y - 15)
	c = min(xsize - 1, edificios[0].x + 15)
	d = min(ysize - 1, edificios[0].y + 15)
	for(a = max(0, edificios[0].x - 15); a < c; a++)
		for(b = e; b < d; b++){
			coord = {x : a, y : b}
			array_push(checked, coord)
		}
	checked = array_shuffle(checked)
	spawn_build(checked, 14)
	checked = []
	for(a = max(0, edificios[0].x - 15); a < c; a++)
		for(b = e; b < d; b++)
			if land_matrix[a, b]{
				coord = {x : a, y : b}
				array_push(checked, coord)
			}
	checked  = array_shuffle(checked)
	spawn_build(checked, 17)
	spawn_build(checked, 20)
	spawn_build(checked, 8, 5)
	spawn_build(checked, 9, 3)
	spawn_build(checked, 6)
	spawn_build(checked, 11)
	for(a = 0; a < array_length(personas); a++){
		var persona = personas[a]
		if not persona.es_hijo{
			buscar_trabajo(persona)
			buscar_casa(persona)
		}
		else
			buscar_escuela(persona)
	}
#endregion
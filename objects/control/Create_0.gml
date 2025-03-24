randomize()
var a, b
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
#region Definiciones independientes
	pais_nombre = ["Trópico", "Cuba", "México", "El Salvador", "Costa Rica", "Honduras", "Panamá", "Guatemala", "Haití", "República Dominicana", "Venezuela", "Colombia", "Brasil", "Belice", "Jamaica", "Nicaragua", "Bahamas", "Estados Unidos"]
	pais_religion = [92, 59, 95, 88, 91, 88, 93, 95, 87, 88, 90, 92, 88, 88, 77, 86, 96, 78]
	pais_idioma = [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 2, 3, 3, 0, 3, 3]
	idioma_nombre = ["Español", "Francés", "Portugués", "Inglés"]
	pais_relacion = []
	for(a = 0; a < array_length(pais_nombre); a++)
		array_push(pais_relacion, 0)
	ley_nombre = ["Legalizar divorcios", "Aceptar inmigrantes", "Trabajo infantil", "Jubilación", "Comida gratis", "Aceptar emigración", "Trabajo temporal", "Legalizar tomas"]
	ley_eneabled = [false, true, false, true, true, true, false, true]
	ley_descripcion = [	"Permite a los ciudadanos separarse legalmente, molestará a los ciudadanos religiosos",
						"Permite la entrada de inmigrantes a la isla",
						"Permite trabajar a los niños mayores de 12 años, molestará a todo ciudadano con hijos",
						"Permite jubilarse a los ciudadanos mayores de 65 años entregando una pensión mínima",
						"La comida es gratis, le permite a todos los habitantes acceder a ella",
						"Le permite a los ciudadanos molestos irse del país si lo desean",
						"Despide automáticamente a los trabajadores de las constructoras cuando no hay proyectos pendientes",
						"Permite que los ciudadanos construyan tomas cuando no logran encontrar un hogar"]
	ministerio_nombre = ["Población", "Vivienda", "Trabajo", "Salud", "Educación", "Economía", "Exterior", "Propiedad privada", "Leyes"]
	ministerio = -1
		null_construccion = {
		x : 0,
		y : 0,
		id : 0,
		tipo : 0,
		tiempo : 0,
		altura : 0,
		rotado : false,
		width : 0,
		height : 0
	}
	cola_construccion = [null_construccion]
	array_delete(cola_construccion, 0, 1)
#endregion
//Personas
#region Personas
	null_relacion = {
		padre : undefined,
		madre : undefined,
		hijos : [],
		vivo : false,
		persona : undefined,
		nombre : "VOID",
		sexo : false
	}
	null_relacion.padre = null_relacion
	null_relacion.madre = null_relacion
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
		educacion : 0,
		escuela : undefined,
		medico : undefined,
		ocios : [undefined],
		es_hijo : false,
		nacionalidad : 0,
		religion : true,
		relacion : null_relacion,
		ladron : undefined,
		preso : false,
		empresa : undefined
	}
	null_persona.pareja = null_persona
	null_relacion.persona = null_persona
	personas = [null_persona]
	array_pop(personas)
	for(a = 0; a < 365; a++){
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
//Familias
#region familias
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
		index : familia_count
	}
	array_pop(null_familia.hijos)
	familias = [null_familia]
	array_pop(familias)
	null_persona.familia = null_familia
#endregion
//Recursos
#region recursos
	recurso_nombre = ["Cereales", "Madera", "Plátanos", "Algodón", "Tabaco", "Azucar", "Soya", "Cañamo", "Pescado", "Carbón", "Hierro", "Oro", "Cobre", "Aluminio", "Níquel", "Acero", "Tela", "Barcos", "Carne", "Leche", "Lana", "Cuero", "Ron", "Queso", "Herramientas", "Muebles", "Ladrillos"]
	recurso_precio = [1.5, 1.2, 1.6, 1.8, 2.2, 1.4, 1.2, 2.8, 1.6, 2.5, 3.5, 5, 3, 2.2, 4, 12, 7, 400, 2.2, 1.2, 1.4, 2.2, 12, 8, 15, 10, 0.6]
	recurso_cultivo = [0, 2, 3, 4, 5, 6, 7]
	cultivo_altura_minima = [0.6, 0.55, 0.65, 0.6, 0.55, 0.65, 0.55]
	recurso_comida = [0, 2, 6, 8, 18, 19, 23]
	recurso_lujo = [4, 22, 25]
	recurso_mineral = [9, 10, 11, 12, 13, 14]
	recurso_mineral_color = [c_black, c_gray, c_yellow, c_orange, c_ltgray, c_dkgray]
	recurso_mineral_rareza = [0.8, 0.85, 0.95, 0.75, 0.85, 0.9]
	ganado_nombre = ["Vacas", "Cabras", "Ovejas", "Cerdos"]
	ganado_produccion = [[18, 21], [19], [20], [18]]
	null_tratado = {
		pais : 0,
		recurso : 0,
		cantidad : 0,
		factor : 1,
		tiempo : 0
	}
	tratados_ofertas = [null_tratado]
	array_pop(tratados_ofertas)
	for(a = 0; a < array_length(recurso_nombre); a++){
		recurso_importado[a] = 0
		recurso_exportado[a] = true
		recurso_importado_fijo[a] = 0
		recurso_tratados[a] = [null_tratado]
		recurso_construccion[a] = 0
		array_pop(recurso_tratados[a])
		for(b = 0; b < 24; b++)
			recurso_historial[a, b] = recurso_precio[a]
	}
#endregion
//Edificios
#region edificios
	edificio_descripcion = ["", "", "", "",
		"Produce diversos cultivos dependiendo de la fertilidad del terreno",
		"Corta áboles cercanos para extraer madera",
		"Entrega educación media a los niños que viven cerca",
		"Entrega atención médica a los habitantes que viven cerca",
		"Vivienda precaria pero barata, es mejor que vivir en la calle",
		"Mejor que una chabola",
		"Excelente vivienda con gran jardín, solo los habitantes más adinerados pueden costearselo",
		"Sirve alcohol a cualquiera que tenga edad suficiente para trabajar, mejora el humor de los habitantes",
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
		"Consume algodón, cañamo o lana y produce tela",
		"Fabrica barcos a partir de bastante madera, cañamo, cobre y tela",
		"Reproduce animales para obtener recursos de estos",
		"Consume azúcar para producir ron",
		"Consume leche para producir queso",
		"Usa madera y acero para producir herramientas",
		"Vivienda urbana por excelencia",
		"Vivienda anarquista por excelencia, se construirán automáticamente si no hay casas disponibles",
		"",
		"Reduce el crimen al encerrar a los delincuentes cercanos por un tiempo",
		"Vende comida y bienes de lujo",
		"Utiliza madera para producir muebles",
		"Fábrica a vapor que requiere combustible y lana o algodón para producir tela a una gran velocidad.",
		"Aquí mismo se extrae la arcilla y se cosen ladrillos"]
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
		edificio_clientes_max = []
		edificio_clientes_calidad = []
		edificio_clientes_tarifa = []
		edificio_es_trabajo = []
		edificio_trabajadores_max = []
		edificio_trabajo_calidad = []
		edificio_trabajo_sueldo = []
		edificio_trabajo_educacion = []
		edificio_es_industria = []
		edificio_industria_input_id = []
		edificio_industria_input_num = []
		edificio_industria_output_id = []
		edificio_industria_output_num = []
		edificio_industria_velocidad = []
		edificio_industria_optativo = []
		edificio_industria_vapor = []
	#endregion
	#region funciones de definición
	function def_edificio_base(nombre, width = 0, height = 0, precio = 0, tiempo = 0, recur_id = [0], recur_num = [0], mantenimiento = 0, belleza = 50, contaminacion = 0, estatal = true, es_costero = false, es_almacen = false, sprite = false, sprite_id = spr_1x1, es_casa = false, fam_max = 0, fam_cal = 0, fam_ren = 0, anno = 0){
		array_push(edificio_nombre, string(nombre))
		array_push(edificio_width, width)
		array_push(edificio_height, height)
		array_push(edificio_precio, precio)
		array_push(edificio_construccion_tiempo, tiempo)
		array_push(edificio_recursos_id, recur_id)
		array_push(edificio_recursos_num, recur_num)
		array_push(edificio_mantenimiento, mantenimiento)
		array_push(edificio_belleza, belleza)
		array_push(edificio_contaminacion, contaminacion)
		array_push(edificio_estatal, estatal)
		array_push(edificio_es_costero, es_costero)
		array_push(edificio_es_almacen, es_almacen)
		array_push(edificio_sprite, sprite)
		array_push(edificio_sprite_id, sprite_id)
		array_push(edificio_es_casa, es_casa)
		array_push(edificio_familias_max, fam_max)
		array_push(edificio_familias_calidad, fam_cal)
		array_push(edificio_familias_renta, fam_ren)
		array_push(edificio_anno, anno)
		var index = array_length(edificio_nombre)
	}
	function def_edificio_servicio(es_medico = false, es_ocio = false, es_iglesia = false, es_escuela = false, escuela_max = 0, cli_max = 0, cli_cal = 0, cli_tar = 0){
		array_push(edificio_es_medico, es_medico)
		array_push(edificio_es_ocio, es_ocio)
		array_push(edificio_es_iglesia, es_iglesia)
		array_push(edificio_es_escuela, es_escuela)
		array_push(edificio_escuela_max, escuela_max)
		array_push(edificio_clientes_max, cli_max)
		array_push(edificio_clientes_calidad, cli_cal)
		array_push(edificio_clientes_tarifa, cli_tar)
		var index = array_length(edificio_es_medico)
	}
	function def_edificio_trabajo(es_trabajo = false, trab_max = 0, trab_cal = 0, trab_sue = 0, trab_edu = 0, es_industria = false, ind_in_id = [0], ind_in_num = [0], ind_out_id = [0], ind_out_num = [0], ind_vel = 0, ind_opt = false, ind_vap = false){
		array_push(edificio_es_trabajo, es_trabajo)
		array_push(edificio_trabajadores_max, trab_max)
		array_push(edificio_trabajo_calidad, trab_cal)
		array_push(edificio_trabajo_sueldo, trab_sue)
		array_push(edificio_trabajo_educacion, trab_edu)
		array_push(edificio_es_industria, es_industria)
		array_push(edificio_industria_input_id, ind_in_id)
		array_push(edificio_industria_input_num, ind_in_num)
		array_push(edificio_industria_output_id, ind_out_id)
		array_push(edificio_industria_output_num, ind_out_num)
		array_push(edificio_industria_velocidad, ind_vel)
		array_push(edificio_industria_optativo, ind_opt)
		array_push(edificio_industria_vapor, ind_vap)
		var index = array_length(edificio_es_trabajo)
	}
	#endregion
	#region definición
		def_edificio_base("Sin trabajo"); def_edificio_servicio(); def_edificio_trabajo()
		def_edificio_base("Jubilado"); def_edificio_servicio(); def_edificio_trabajo(, 0, 15, 2)
		def_edificio_base("Sin atención médica"); def_edificio_servicio(true); def_edificio_trabajo()
		def_edificio_base("Homeless",,,,,,,,,,,,,,,true); def_edificio_servicio(); def_edificio_trabajo()
		def_edificio_base("Granja", 6, 3, 300, 180, [1, 10, 26], [10, 2, 10], 4, 40, -10, false,,true); def_edificio_servicio(); def_edificio_trabajo(true, 10, 25, 4)
		def_edificio_base("Aserradero", 3, 2, 650, 240, [1, 10], [8, 2], 5, 30, 10, false); def_edificio_servicio(); def_edificio_trabajo(true, 10, 30, 5)
		def_edificio_base("Escuela", 3, 3, 800, 640, [1, 10, 26], [30, 5, 25], 6, 40); def_edificio_servicio(,,,true, 2, 20, 50); def_edificio_trabajo(true, 4, 50, 8, 2)
		def_edificio_base("Consultorio", 2, 3, 1200, 720, [1, 10, 24, 26], [25, 5, 5, 20], 15, 55); def_edificio_servicio(true,,,,,20, 60); def_edificio_trabajo(true, 3, 65, 11, 3)
		def_edificio_base("Chabola", 2, 2, 200, 300, [1, 10, 26], [10, 2, 15], 3, 40, 10, false,,,,,true, 5, 30, 4); def_edificio_servicio(); def_edificio_trabajo()
		def_edificio_base("Cabaña", 2, 1, 250, 200, [1, 10, 25], [6, 1, 6], 2, 55, 10, false,,,,,true, 2, 45, 6); def_edificio_servicio(); def_edificio_trabajo()
		def_edificio_base("Parcela", 3, 2, 400, 360, [1, 10, 25, 26], [15, 3, 10, 30], 10, 75, 10, false,,,,,true, 2, 65, 12); def_edificio_servicio(); def_edificio_trabajo(true, 1, 40, 4)
		def_edificio_base("Taberna", 2, 1, 200, 240, [1, 10, 26], [10, 2, 20], 3, 30,, false); def_edificio_servicio(, true,,,, 5, 25, 1); def_edificio_trabajo(true, 2, 35, 5)
		def_edificio_base("Circo", 4, 4, 500, 240, [1, 16], [10, 20], 6, 30,, false); def_edificio_servicio(, true,,,, 16, 20, 1); def_edificio_trabajo(true, 8, 25, 4)
		def_edificio_base("Muelle", 6, 6, 2200, 1080, [1, 10, 24, 26], [40, 40, 10, 40], 10, 30, 15,, true, true); def_edificio_servicio(); def_edificio_trabajo(true, 6, 30, 6, 1)
		def_edificio_base("Pescadería", 5, 5, 800, 360, [1, 10], [20, 10], 6, 25, 10, false, true, true); def_edificio_servicio(); def_edificio_trabajo(true, 6, 25, 5)
		def_edificio_base("Mina", 4, 3, 800, 720, [1, 10, 26], [20, 10, 10], 10, 25, 15, false); def_edificio_servicio(); def_edificio_trabajo(true, 8, 20, 5)
		def_edificio_base("Capilla", 4, 3, 1100, 600, [1, 10, 26], [20, 5, 30], 10, 65); def_edificio_servicio(,, true,,, 12, 40); def_edificio_trabajo(true, 2, 60, 6, 1)
		def_edificio_base("Hospicio", 4, 3, 1500, 1080, [1, 10, 24, 26], [20, 5, 5, 30], 15, 50); def_edificio_servicio(true,, true,,, 10, 30); def_edificio_trabajo(true, 5, 60, 8, 2)
		def_edificio_base("Albergue", 4, 3, 1300, 600, [1, 10, 26], [20, 5, 30], 12, 40,,,,,,, true, 10, 25); def_edificio_servicio(,, true,,, 10, 30); def_edificio_trabajo(true, 3, 50, 5, 1)
		def_edificio_base("Escuela parroquial", 4, 3, 1300, 720, [1, 10, 26], [20, 5, 30], 12, 45); def_edificio_servicio(,, true, true, 1, 10, 30); def_edificio_trabajo(true, 5, 60, 6, 2)
		def_edificio_base("Oficina de Construcción", 3, 2, 1000, 600, [1, 10, 24, 26], [10, 5, 10, 20], 8, 35); def_edificio_servicio(); def_edificio_trabajo(true, 6, 35, 5, 1)
		def_edificio_base("Plaza", 2, 2, 200, 180, [1, 26], [5, 15], 4, 70, -15); def_edificio_servicio(, true,,,, 5, 10); def_edificio_trabajo()
		def_edificio_base("Oficina de Transporte", 3, 2, 800, 600, [1, 10, 26], [10, 5, 20], 6, 35); def_edificio_servicio(); def_edificio_trabajo(true, 6, 30, 4)
		def_edificio_base("Forja", 5, 4, 2500, 1080, [1, 15, 24, 26], [30, 20, 20, 40], 25, 25, 20, false); def_edificio_servicio(); def_edificio_trabajo(true, 15, 30, 6,, true, [9, 10], [2, 3], [15], [1], 1)
		def_edificio_base("Cabaret", 4, 3, 700, 450, [1, 10, 26], [20, 5, 20], 6, 30,, false); def_edificio_servicio(, true,,,, 6, 40, 3); def_edificio_trabajo(true, 4, 35, 6)
		def_edificio_base("Taller Textil", 5, 4, 3000, 900, [1, 10, 24, 26], [30, 10, 20, 40], 20, 30, 10, false); def_edificio_servicio(); def_edificio_trabajo(true, 15, 25, 5,, true, [3, 7, 20], [3, 2, 3], [16], [1], 2, true)
		def_edificio_base("Astillero", 9, 6, 6200, 1800, [1, 10, 15, 24, 26], [50, 30, 10, 20, 40], 40, 40, 10, false, true); def_edificio_servicio(); def_edificio_trabajo(true, 30, 35, 4,, true, [1, 7, 12, 16], [5, 1, 1, 1], [17], [0.1], 0.3)
		def_edificio_base("Rancho", 8, 8, 500, 300, [1], [30], 5, 45, -10, false,,true); def_edificio_servicio(); def_edificio_trabajo(true, 4, 40, 4)
		def_edificio_base("Taller de Destilado", 5, 4, 3500, 900, [1, 10, 24, 26], [25, 10, 25, 40], 20, 40, 5, false); def_edificio_servicio(); def_edificio_trabajo(true, 12, 40, 5,, true, [5], [3], [22], [1], 1)
		def_edificio_base("Quesería Artesanal", 5, 4, 2500, 720, [1, 10, 24, 26], [25, 10, 25, 40], 15, 40, 5, false,, true); def_edificio_servicio(); def_edificio_trabajo(true, 8, 40, 5,, true, [19], [2], [23], [1], 0.5)
		def_edificio_base("Herrería", 5, 4, 3500, 1080, [1, 10, 15, 24, 26], [25, 10, 20, 20, 40], 20, 30, 15, false); def_edificio_servicio(); def_edificio_trabajo(true, 10, 30, 5,, true, [1, 15], [2, 1], [24], [1], 0.5)
		def_edificio_base("Vecindad", 3, 3, 1000, 720, [1, 15, 25, 26], [10, 10, 10, 30], 4,, 15, false,,,,,true, 8, 40, 5, 20); def_edificio_servicio(); def_edificio_trabajo()
		def_edificio_base("Toma", 1, 1,,,,,, 20, 5,,,,true ,, true, 1, 15); def_edificio_servicio(); def_edificio_trabajo()
		def_edificio_base("Delincuente"); def_edificio_servicio(); def_edificio_trabajo(,,10)
		def_edificio_base("Comisaría", 4, 2, 900, 720, [1, 10, 15, 26], [20, 5, 20, 25], 12, 40); def_edificio_servicio(,,,,, 4); def_edificio_trabajo(true, 4, 40, 7)
		def_edificio_base("Mercado", 4, 4, 600, 360, [1, 10, 16, 26], [20, 5, 20, 20], 10, 40, 10); def_edificio_servicio(); def_edificio_trabajo(true, 15, 35, 4)
		def_edificio_base("Mueblería", 5, 4, 2500, 720, [1, 10, 24, 26], [25, 10, 20, 40], 20, 40, 5, false); def_edificio_servicio(); def_edificio_trabajo(true, 10, 30, 5,, true, [1], [4], [25], [1], 1)
		def_edificio_base("Fábrica Textil", 8, 6, 9000, 2400, [1, 10, 15, 24, 26], [50, 20, 30, 50, 60], 40, 25, 30, false,,,,,,,,, 30); def_edificio_servicio(); def_edificio_trabajo(true, 30, 20, 4,, true, [3, 20], [2, 2], [16], [1], 3, true, true)
		def_edificio_base("Tejar", 5, 4, 1500, 360, [1, 10, 26], [20, 10, 30], 7, 40, -5, false); def_edificio_servicio(); def_edificio_trabajo(true, 6, 30, 5)
	#endregion
	edificio_categoria_nombre = ["Residencial", "Meterias Primas", "Servicios", "Infrastructura", "Industria"]
	edificio_categoria = [[8, 9, 10, 31], [4, 5, 14, 15, 27, 38], [6, 7, 11, 12, 16, 21, 24, 34, 35], [13, 20, 22], [23, 25, 26, 28, 29, 30, 36, 37]]
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
		x : 0,
		y : 0,
		tipo : 0,
		dia_factura : 0,
		count : 0,
		almacen : [],
		pedido : [],
		eficiencia : 1,
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
		trabajadores_max : 0,
		trabajo_calidad : 0,
		trabajo_sueldo : 0,
		mantenimiento : 0,
		presupuesto : 2,
		mes_creacion : 0,
		ganancia : 0,
		trabajo_mes : 0,
		muelle_cercano : undefined,
		distancia_muelle_cercano : 0,
		rotado : false,
		width : 0,
		height : 0,
		ladron : null_persona,
		venta : false,
		es_almacen : false
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
	null_edificio.muelle_cercano = null_edificio
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
	null_persona.trabajo = null_edificio
	null_persona.escuela = null_edificio
	null_persona.medico = null_edificio
	null_persona.ladron = null_edificio
	null_empresa = {
		jefe : null_persona,
		dinero : 0,
		edificios : [null_edificio],
		nacional : false,
		nombre : "",
		quiebra : false,
		dia_factura : irandom(27),
		terreno : [{a : 0, b : 0}],
		ventas : []
	}
	array_pop(null_empresa.edificios)
	array_pop(null_empresa.terreno)
	null_persona.empresa = null_empresa
	empresas = [null_empresa]
	array_pop(empresas)
	for(a = 0; a < 28; a++){
		dia_empresas[a] = [null_empresa]
		array_pop(dia_empresas[a])
	}
	empresa_comprado = null_empresa
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
	for(a = 0; a < 28; a++){
		dia_trabajo[a] = [null_edificio]
		array_pop(dia_trabajo[a])
	}
	for(a = 0; a < array_length(recurso_nombre); a++){
		array_push(null_edificio.almacen, 0)
		array_push(null_edificio.pedido, 0)
	}
	current_mes = 0
#endregion
//Exigencia
#region exigenicas
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
	felicidad_minima = 17
#endregion
#region edificios ficticios
	edificios_ocio_index = []
	edificio_almacen_index = []
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
	}
	jubilado = add_edificio(0, 0, 1, false)
	desausiado = add_edificio(0, 0, 2, false)
	medicos = [desausiado]
	homeless = add_edificio(0, 0, 3, false)
	null_familia.casa = homeless
	delincuente = add_edificio(0, 0, 33, false)
#endregion
//Settings
#region diseño del mundo
	dia = 1
	xsize = 240
	ysize = 240
	for(a = 0; a < array_length(recurso_cultivo); a++)
		cultivo[a] = perlin(xsize, ysize, 1, false, 6)
	var mineral_grid
	for(a = 0; a < array_length(recurso_mineral); a++)
		mineral_grid[a] = perlin(xsize, ysize, 1, false, 6)
	var grid = perlin(xsize, ysize, 1, false)
	altura = perlin(xsize, ysize, 1, false)
	for(a = 0; a < xsize / 2; a += 3)
		ds_grid_add_disk(altura, floor(xsize / 2), floor(ysize / 2), a, 0.05)
	a = ds_grid_get_max(altura, 0, 0, xsize, ysize)
	ds_grid_multiply_region(altura, 0, 0, xsize, ysize, 1 / a)
	//Matriz del mundo
	var mar_checked, land_checked, land_matrix
	for(a = 0; a < xsize; a++)
		for(b = 0; b < ysize; b++){
			var c = altura[# a, b]
			bool_edificio[a, b] = false
			id_edificio[a, b] = null_edificio
			construccion_reservada[a, b] = false
			bool_draw_edificio[a, b] = false
			draw_edificio[a, b] = null_edificio
			bool_draw_construccion[a, b] = false
			draw_construccion[a, b] = null_construccion
			draw_edificio_flip[a, b] = brandom()
			bosque[a, b] = grid[# a, b] > 0.6 and c > 0.62
			if bosque[a, b]{
				bosque_madera[a, b] = floor(200 * grid[# a, b])
				bosque_alpha[a, b] = 0.5 + bosque_madera[a, b] / 400
				bosque_max[a, b] = bosque_madera[a, b]
			}
			mar[a, b] = c < 0.5
			#region altura color
			if mar[a, b]
				altura_color[a, b] = make_color_rgb(63 * c, 63 * c, 255 * c)
			else if c < 0.6
				altura_color[a, b] = make_color_rgb(255 / 0.6 * (1.1 - c), 255 / 0.6 * (1.1 - c), 127)
			else
				altura_color[a, b] = make_color_rgb(31 + 96 * c, 127, 31 + 96 * c)
			#endregion
			if not mar[a, b]
				for(var d = 0; d < array_length(recurso_cultivo); d++)
					if c < cultivo_altura_minima[d]
						ds_grid_set(cultivo[d], a, b, 0)
					else if c < cultivo_altura_minima[d] + 0.05
						ds_grid_multiply(cultivo[d], a, b, 20 * (c - cultivo_altura_minima[d]))
			for(var d = 0; d < array_length(recurso_mineral); d++){
				mineral[d][a, b] = (mineral_grid[d][# a, b] > recurso_mineral_rareza[d])
				mineral_cantidad[d][a, b] = round(400 * power(mineral_grid[d][# a, b], 3))
			}
			belleza[a, b] = 50 + floor(100 * (0.6 - min(0.6, c)))
			contaminacion[a, b] = 0
			zona_privada[a, b] = false
			zona_empresa[a, b]= null_empresa
			mar_checked[a, b] = false
			land_checked[a, b] = false
			land_matrix[a, b] = false
		}
	world_update = true
	for(a = 0; a < xsize / 16; a++)
		for(b = 0; b < ysize / 16; b++){
			chunk[a, b] = spr_arbol
			chunk_update[a, b] = true
		}
	var not_mar = [], yes_mar = [{a : 0, b : 0}], yes_land = [{a : floor(xsize / 2), b : floor(ysize / 2)}]
	array_set(mar_checked[0], 0, true)
	array_set(land_checked[floor(xsize / 2)], floor(ysize / 2), true)
	array_set(land_matrix[floor(xsize / 2)], floor(ysize / 2), true)
	while array_length(yes_mar) > 0{
		var complex = array_shift(yes_mar)
		a = complex.a
		b = complex.b
		var a1 = max(0, a - 1), b1 = max(0, b - 1), a2 = min(xsize - 1, a + 1), b2 = min(ysize - 1, b + 1)
		if mar[a1, b] and not mar_checked[a1, b]{
			array_set(mar_checked[a1], b, true)
			array_push(yes_mar, {a : a1, b : b})
		}
		if mar[a, b1] and not mar_checked[a, b1]{
			array_set(mar_checked[a], b1, true)
			array_push(yes_mar, {a : a, b : b1})
		}
		if mar[a, b2] and not mar_checked[a, b2]{
			array_set(mar_checked[a], b2, true)
			array_push(yes_mar, {a : a, b : b2})
		}
		if mar[a2, b] and not mar_checked[a2, b]{
			array_set(mar_checked[a2], b, true)
			array_push(yes_mar, {a : a2, b : b})
		}
	}
	for(a = 0; a < xsize; a++)
		for(b = 0; b < ysize; b++)
			if mar[a, b] and not mar_checked[a, b]
				array_push(not_mar, {a : a, b : b})
	while array_length(not_mar) > 0{
		var complex = array_shift(not_mar)
		array_set(mar[complex.a], complex.b, false)
		ds_grid_set(altura, complex.a, complex.b, 0.5)
		array_set(altura_color[complex.a], complex.b, make_color_rgb(255, 255 ,127))
	}
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
#endregion
#region setings
	draw_set_font(Font1)
	sel_info = false
	sel_edificio = null_edificio
	sel_familia = null_familia
	sel_persona = null_persona
	sel_tipo = 0
	sel_build = false
	sel_modo = false
	sel_cerca = false
	build_sel = false
	build_index = 0
	build_type = 0
	build_categoria = 0
	last_width = 0
	last_height = 0
	show_grid = false
	show_scroll = 0
	tile_width = 32
	tile_height = 16
	menu = false
	menu_principal = true
	draw_set_halign(fa_center)
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
						"Aquí se encuentra la información del edificio\n  Las familias que vivne aquí\n  Los trabajadores que trabajan aquí\n  Los recursos que tiene almacenado\n  Y mucho más",
						"Ahora construye una granja\nLa granja la encontrarás en el panel de Materias primas",
						"Las granjas necesitan un suelo adecuando para funcionar\nBusca un lugar donde su eficiciencia sea alta (verde) para construirla\nPuedes rotar el edificio con [R] si lo deseas",
						"Bien hecho, los ciudadanos necesitarán comida y podrán producirla en la granja\nAhora construye un aserradero para empezar a exportar recursos",
						"Los aserraderos necesitan árboles cerca para ser construidos\nMientras más árboles tenga, más madera podrá extraer",
						"Bien hecho, el aserradero extraerá madera cuando tenga trabajadores\n2 veces al año esta madera se exportará en el muelle",
						"Ahora, otra cosa importante para tu isla es satisfacer las demandas de la población\nConstruye una escuela para mejorar la felicidad de la gente\nLa escuela está en el panel de Servicios",
						"Bien.  Los ciudadanos tienes ciertas necesidades que hay que cumplir\nLo más importante es alimentación y salud, no quieres que mueran tus votantes\nRevísalas en el Ministerio de Población [clic derecho]",
						"Aquí puedes revisar el flujo de población, edades y felicidades\nSi haces [clic izquierdo] en Felicidad podrás ver el detalle\nSi los ciudadanos son muy infelices, podrá emigrar y protestar",
						//20
						"Otro ministerio importante es el de economía",
						"Aquí podrás ver cómo gana dinero la isla y en qué se va\nAdemás podrás controlar las importaciones y exportaciones",
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
	impuesto_forestal = 0.2
	impuesto_minero = 0.2
	for(a = 0; a < 12; a++){
		mes_enfermos[a] = 0
		mes_emigrantes[a]  = 0
		mes_muertos[a] = 0
		mes_inanicion[a] = 0
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
		for(b = 0; b < array_length(recurso_nombre); b++){
			mes_exportaciones_recurso[a, b] = 0
			mes_importaciones_recurso[a, b] = 0
		}
	}
	for(a = 0; a < array_length(edificio_nombre) * 2; a++)
		show[a] = false
	felicidad_total = 50
	dinero = 20000
	inversion_privada = 0
	dinero_privado = 0
	prev_beneficio_privado = 0
	credibilidad_financiera = 3
	pos = 0
	deuda = false
	deuda_dia = 0
	null_encargo = {
		recurso : 0,
		cantidad : 0,
		edificio : null_edificio}
	encargos = [null_encargo]
	array_pop(encargos)
	repeat(10)
		add_tratado_oferta()
	repeat(10)
		add_empresa(irandom_range(1000, 2000))
	while array_length(personas) < 50
		add_familia(0)
#endregion
#region edificios iniciales
	#region Puerto principal
		do{
			a = irandom(xsize - edificio_width[13])
			b = irandom(ysize - edificio_height[13])
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
	var coord, checked = [], c = edificios[0].x - 15, d = edificios[0].x + 15, e = edificios[0].y - 15, f = edificios[0].y + 15
	for(a = c; a < d; a++)
		for(b = e; b < f; b++){
			coord = {x : a, y : b}
			array_push(checked, coord)
		}
	checked = array_shuffle(checked)
	spawn_build(checked, 14)
	checked = []
	for(a = c; a < d; a++)
		for(b = e; b < f; b++)
			if land_matrix[a, b]{
				coord = {x : a, y : b}
				array_push(checked, coord)
			}
	checked  = array_shuffle(checked)
	spawn_build(checked, 17)
	spawn_build(checked, 20)
	spawn_build(checked, 8, 3)
	spawn_build(checked, 9, 3)
	for(a = 0; a < array_length(personas); a++){
		var persona = personas[a]
		if not persona.es_hijo{
			buscar_trabajo(persona)
			buscar_casa(persona)
		}
	}
#endregion
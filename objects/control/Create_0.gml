randomize()
var a, b
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
	educacion : 0,
	escuela : undefined,
	medico : undefined,
	ocios : [undefined],
	es_hijo : false,
	nacionalidad : 0,
	religion : true,
	relacion : null_relacion
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
//Edificios
#region edificios
edificio_nombre = ["Sin trabajo", "Jubilado", "Sin atención médica", "Homeless", "Granja", "Aserradero", "Escuela", "Consultorio", "Chabola", "Cabaña", "Mansión", "Taberna", "Circo", "Muelle", "Pescadería", "Mina", "Capilla", "Hospicio", "Albergue", "Escuela parroquial", "Oficina de Construcción", "Plaza", "Oficina de Transporte", "Planta Siderúrgica"]
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
	"Consume hierro y carbón para producir acero, contamina bastante"]
edificio_trabajadores_max = [0, 0, 0, 0, 10, 5, 4, 3, 0, 0, 2, 2, 8, 5, 6, 5, 4, 8, 4, 5, 8, 0, 4, 20]
edificio_trabajo_calidad = [0, 10, 0, 0, 25, 30, 50, 60, 0, 0, 40, 40, 25, 25, 30, 25, 45, 40, 40, 45, 30, 0, 35, 30]
edificio_trabajo_sueldo = [0, 2, 0, 0, 4, 5, 8, 11, 0, 0, 4, 5, 3, 7, 6, 5, 6, 6, 5, 6, 6, 0, 5, 4]
edificio_trabajo_educacion = [0, 0, 0, 0, 0, 0, 2, 3, 0, 0, 0, 0, 0, 1, 0, 0, 1, 2, 1, 2, 1, 0, 0, 0]
edificio_es_casa = [false, false, false, true, false, false, false, false, true, true, true, false, false, false, false, false, false, false, true, false, false, false, false, false]
edificio_es_trabajo = [false, false, false, false, true, true, true, true, false, false, true, true, true, true, true, true, true, true, true, true, true, false, true, true]
edificio_es_escuela = [false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false]
edificio_es_medico = [false, false, true, false, false, false, false, true, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false]
edificio_es_ocio = [false, false, true, false, false, false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, false, true, false, false]
edificio_es_iglesia = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, false, false, false, false]
edificio_es_costero = [false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, false, false]
edificio_es_almacen = [false, false, false, false, true, false, false, false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, false, false]
edificio_clientes_max = [0, 0, 0, 0, 0, 0, 20, 25, 0, 0, 0, 5, 16, 0, 0, 0, 20, 10, 10, 10, 0, 4, 0, 0]
edificio_clientes_calidad = [0, 0, 0, 0, 0, 0, 50, 60, 0, 0, 0, 25, 20, 0, 0, 0, 50, 30, 30, 30, 0, 10, 0, 0]
edificio_clientes_tarifa = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
edificio_familias_max = [0, 0, 0, 0, 0, 0, 0, 0, 5, 2, 1, 0, 0, 0, 0, 0, 0, 0, 15, 0, 0, 0, 0, 0]
edificio_familias_calidad = [0, 0, 0, 0, 0, 0, 0, 0, 30, 40, 65, 0, 0, 0, 0, 0, 0, 0, 15, 0, 0, 0, 0, 0]
edificio_familias_renta = [0, 0, 0, 0, 0, 0, 0, 0, 4, 6, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
edificio_width = [0, 0, 0, 0, 6, 3, 3, 1, 2, 2, 3, 1, 4, 6, 5, 3, 3, 3, 3, 3, 3, 2, 2, 6]
edificio_height = [0, 0, 0, 0, 3, 2, 3, 3, 2, 1, 2, 2, 4, 6, 5, 4, 5, 5, 5, 5, 2, 2, 3, 4]
edificio_color = [0, 0, 0, 0, 0, 10, 25, -10, 167, 177, 187, -15, 35, 80, -5, 30, 40, 45, 50, 55, 60, 65, 70, 0]
edificio_precio = [0, 0, 0, 0, 400, 650, 300, 1500, 300, 200, 500, 250, 450, 2500, 800, 1000, 1500, 1800, 1200, 1400, 700, 200, 650, 4500]
edificio_mantenimiento = [0, 0, 0, 0, 4, 5, 6, 10, 3, 2, 10, 3, 6, 2, 8, 10, 12, 15, 10, 12, 5, 2, 5, 25]
edificio_estatal = [true, true, true, true, false, false, true, true, false, false, false, false, false, true, false, false, true, true, true, true, true, true, true, false]
edificio_belleza = [0, 0, 0, 0, 40, 30, 40, 50, 40, 55, 75, 30, 30, 30, 20, 25, 60, 50, 50, 50, 40, 80, 40, 25]
edificio_construccion_tiempo = [0, 0, 0, 0, 180, 240, 720, 640, 300, 180, 720, 240, 240, 1080, 240, 480, 720, 720, 720, 720, 600, 180, 720, 1800]
edificio_contaminacion = [0, 0, 0, 0, -10, 10, 0, 0, 15, 5, 10, 0, 0, 20, 10, 30, 0, 10, 0, 0, 0, -10, 10, -30]
edificio_categoria_nombre = ["Residencial", "Producción", "Servicios", "Infrastructura"]
edificio_categoria = [[8, 9, 10], [4, 5, 14, 15, 23], [6, 7, 11, 12, 16, 21], [13, 20, 22]]
null_edificio = {
	familias : [null_familia],
	trabajadores : [null_persona],
	clientes : [null_persona],
	edificios_cerca : [],
	trabajos_cerca : [],
	casas_cerca : [],
	iglesias_cerca : [],
	x : 0,
	y : 0,
	tipo : 0,
	dia_factura : 0,
	count : 0,
	almacen : undefined,
	pedido : undefined,
	eficiencia : 1,
	modo : 0,
	array_real_1 : [],
	array_real_2 : [],
	paro : false,
	paro_motivo : 0,
	paro_tiempo : 0,
	exigencia : undefined,
	exigencia_fallida : false,
	privado : false,
	vivienda_calidad : 0,
	trabajo_calidad : 0,
	trabajo_sueldo : 0,
	presupuesto : 2
}
array_pop(null_edificio.familias)
array_pop(null_edificio.trabajadores)
array_pop(null_edificio.clientes)
array_push(null_edificio.edificios_cerca, null_edificio)
null_edificio.edificios_cerca = []
array_push(null_edificio.trabajos_cerca, null_edificio)
null_edificio.trabajos_cerca = []
array_push(null_edificio.casas_cerca, null_edificio)
null_edificio.casas_cerca = []
array_push(null_edificio.iglesias_cerca, null_edificio)
null_edificio.iglesias_cerca = []
edificios = [null_edificio]
array_pop(edificios)
escuelas = [null_edificio]
array_pop(escuelas)
casas = [null_edificio]
array_pop(casas)
trabajos = [null_edificio]
array_pop(trabajos)
iglesias = [null_edificio]
array_pop(iglesias)
null_persona.trabajo = null_edificio
null_persona.escuela = null_edificio
null_persona.medico = null_edificio
for(a = 0; a < 28; a++){
	dia_trabajo[a] = [null_edificio]
	array_pop(dia_trabajo[a])
}
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
#endregion
#region edificios
jubilado = add_edificio(0, 0, 1, false)
desausiado = add_edificio(0, 0, 2, false)
medicos = [desausiado]
homeless = add_edificio(0, 0, 3, false)
null_familia.casa = homeless
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
	array_pop(edificio_count[a])
}
cola_construccion = [{x : 0, y : 0, id : 0, tipo : 0, tiempo : 0}]
array_delete(cola_construccion, 0, 1)
#endregion
//Recursos
#region recursos
recurso_nombre = ["Cereales", "Madera", "Plátanos", "Algodón", "Tabaco", "Azucar", "Soya", "Cañamo", "Pescado", "Carbón", "Hierro", "Oro", "Cobre", "Aluminio", "Níquel", "Acero"]
recurso_precio = [1.2, 0.8, 1.4, 1.2, 1.6, 0.9, 0.8, 1.8, 1.3, 1.4, 2.2, 3.0, 2.0, 1.6, 1.8, 8]
recurso_cultivo = [0, 2, 3, 4, 5, 6, 7]
cultivo_altura_minima = [0.6, 0.55, 0.65, 0.6, 0.55, 0.65, 0.55]
recurso_comida = [0, 2, 6, 8]
recurso_mineral = [9, 10, 11, 12, 13, 14]
recurso_mineral_color = [c_black, c_gray, c_yellow, c_orange, c_ltgray, c_dkgray]
recurso_mineral_rareza = [0.8, 0.85, 0.95, 0.75, 0.85, 0.9]
null_tratado = {pais : 0, recurso : 0, cantidad : 0, factor : 1, tiempo : 0}
tratados_ofertas = [null_tratado]
array_pop(tratados_ofertas)
for(a = 0; a < array_length(recurso_nombre); a++){
	null_edificio.almacen[a] = 0
	null_edificio.pedido[a] = 0
	jubilado.almacen[a] = 0
	jubilado.pedido[a] = 0
	desausiado.almacen[a] = 0
	desausiado.pedido[a] = 0
	homeless.almacen[a] = 0
	homeless.pedido[a] = 0
	recurso_importado[a] = 0
	recurso_exportado[a] = true
	recurso_tratados[a] = [null_tratado]
	array_pop(recurso_tratados[a])
}
#endregion
//Settings
#region diseño del mundo
dia = 0
xsize = 160
ysize = 160
for(a = 0; a < array_length(recurso_cultivo); a++)
	cultivo[a] = perlin(xsize, ysize, 1, false, 6)
var mineral_grid
for(a = 0; a < array_length(recurso_mineral); a++)
	mineral_grid[a] = perlin(xsize, ysize, 1, false, 6)
var grid = perlin(xsize, ysize, 1, false)
altura = perlin(xsize, ysize, 1, false)
for(a = 0; a < xsize / 2; a += 3)
	ds_grid_add_disk(altura, floor(xsize / 2), floor(ysize / 2), a, 0.1)
a = ds_grid_get_max(altura, 0, 0, xsize, ysize)
ds_grid_multiply_region(altura, 0, 0, xsize, ysize, 1 / a)
for(a = 0; a < xsize; a++)
	for(b = 0; b < ysize; b++){
		bool_edificio[a, b] = false
		id_edificio[a, b] = null_edificio
		construccion_reservada[a, b] = false
		bosque[a, b] = grid[# a, b] > 0.6 and altura[# a, b] > 0.6
		if bosque[a, b]
			bosque_madera[a, b] = floor(160 * grid[# a, b])
		mar[a, b] = altura[# a, b] < 0.5
		for(var c = 0; c < array_length(recurso_cultivo); c++)
			if altura[# a, b] < cultivo_altura_minima[c]
				ds_grid_set(cultivo[c], a, b, 0)
			else if altura[# a, b] < cultivo_altura_minima[c] + 0.05
				ds_grid_multiply(cultivo[c], a, b, 20 * (altura[# a, b] - cultivo_altura_minima[c]))
		for(var c = 0; c < array_length(recurso_mineral); c++){
			mineral[c][a, b] = (mineral_grid[c][# a, b] > recurso_mineral_rareza[c])
			mineral_cantidad[c][a, b] = round(320 * power(mineral_grid[c][# a, b], 3))
		}
		belleza[a, b] = 50 + floor(100 * (0.6 - min(0.6, altura[# a, b])))
		contaminacion[a, b] = 0
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
current_mes = 0
educacion_nombre = ["Analfabeto", "Educación Básica", "Educación Media", "Educación Técnica", "Educación Profesional"]
ministerio_nombre = ["Población", "Vivienda", "Trabajo", "Salud", "Educación", "Economía", "Exterior", "Leyes"]
ministerio = -1
felicidad_total = 50
ley_nombre = ["Legalizar divorcios", "Aceptar inmigrantes", "Trabajo infantil", "Jubilación", "Comida gratis", "Aceptar emigración", "Trabajo temporal"]
ley_eneabled = [false, true, false, true, true, true, false]
ley_descripcion = [	"Permite a los ciudadanos separarse legalmente, molestará a los religiosos y agradará a los liberales",
					"Permite la entrada de inmigrantes a Trópico, molestará a los nacionalistas",
					"Permite trabajar a los niños mayores de 12 años, molestará a todo ciudadano con hijos",
					"Permite jubilarse a los mayores de 65 años, mejora su condición de vida pero cuesta dinero",
					"La comida es gratis, le permite a todos los habitantes acceder a alimentación",
					"Le permite a los ciudadanos molestos irse del país si lo desean (y les alcanza)",
					"Despide automáticamente a los trabajadores de las constructoras cuando no hay proyectos pendientes"]
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
	for(b = 0; b < array_length(recurso_nombre); b++){
		mes_exportaciones_recurso[a, b] = 0
		mes_importaciones_recurso[a, b] = 0
	}
}
for(a = 0; a < array_length(edificio_nombre); a++)
	show[a] = false
dinero = 10000
pos = 0
deuda = false
deuda_dia = 0
encargos = [{recurso : 0, cantidad : 0, edificio : null_edificio}]
array_pop(encargos)
pais_nombre = ["Trópico", "Cuba", "México", "El Salvador", "Costa Rica", "Honduras", "Panamá", "Guatemala", "Haití", "República Dominicana", "Venezuela", "Colombia", "Brasil", "Belice", "Jamaica", "Nicaragua", "Bahamas", "Estados Unidos"]
pais_religion = [92, 59, 95, 88, 91, 88, 93, 95, 87, 88, 90, 92, 88, 88, 77, 86, 96, 78]
pais_idioma = [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 2, 3, 3, 0, 3, 3]
idioma_nombre = ["Español", "Francés", "Portugués", "Inglés"]
pais_relacion = []
for(a = 0; a < array_length(pais_nombre); a++)
	array_push(pais_relacion, 0)
repeat(10)
	add_tratado_oferta()
while array_length(personas) < 50
	add_familia(0)
#endregion
#region edificios iniciales
#region Puerto principal
do{
	a = irandom(xsize - edificio_width[13])
	b = irandom(ysize - edificio_height[13])
}
until edificio_valid_place(a, b, 13)
add_edificio(a, b, 13)
edificios[0].almacen[0] = irandom_range(1000, 1500)
recurso_exportado[0] = false
#endregion
xpos = min(max(0, 16 * a - room_width / 2), xsize * 16 - room_width)
ypos = min(max(0, 16 * b - room_height / 2), ysize * 16 - room_height)
var checked = [], coord;
for(a = edificios[0].x - 15; a < edificios[0].x + 15; a++)
	for(b = edificios[0].y - 15; b < edificios[0].y + 15; b++){
		coord = {x : a, y : b}
		array_push(checked, coord)
	}
checked = array_shuffle(checked)
#region Pescadería
do
	coord = array_shift(checked)
until edificio_valid_place(coord.x, coord.y, 14) or array_length(checked) = 0
add_edificio(coord.x, coord.y, 14)
#endregion
#region Oficina de Transporte
do
	coord = array_shift(checked)
until edificio_valid_place(coord.x, coord.y, 22) or array_length(checked) = 0
add_edificio(coord.x, coord.y, 22)
#endregion
#region Hospicio
do
	coord = array_shift(checked)
until edificio_valid_place(coord.x, coord.y, 17) or array_length(checked) = 0
add_edificio(coord.x, coord.y, 17)
#endregion
#region Oficina de construcción
do
	coord = array_shift(checked)
until edificio_valid_place(coord.x, coord.y, 20) or array_length(checked) = 0
add_edificio(coord.x, coord.y, 20)
#endregion
#region Chabolas
repeat(3){
	do
		coord = array_shift(checked)
	until edificio_valid_place(coord.x, coord.y, 8) or array_length(checked) = 0
	add_edificio(coord.x, coord.y, 8)
}
#endregion
#region Cabañas
repeat(3){
	do
		coord = array_shift(checked)
	until edificio_valid_place(coord.x, coord.y, 9) or array_length(checked) = 0
	add_edificio(coord.x, coord.y, 9)
}
#endregion
for(a = 0; a < array_length(personas); a++){
	var persona = personas[a]
	if not persona.es_hijo{
		buscar_trabajo(persona)
		buscar_casa(persona)
	}
}
#endregion
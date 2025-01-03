d3 = false
randomize()
draw_set_font(Font1)
var a, b
//Personas
null_relacion = {
	padre : undefined,
	madre : undefined,
	hijos : [],
	vivo : false,
	nombre : "VOID"
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
//Familias
null_familia = {
	padre : null_persona,
	madre : null_persona,
	hijos : [null_persona],
	casa : undefined,
	sueldo : 0,
	felicidad_vivienda : 0,
	felicidad_alimento : 0,
	riqueza : 0
}
array_pop(null_familia.hijos)
familias = [null_familia]
array_pop(familias)
null_persona.familia = null_familia
//Trabajos
null_edificio = {
	familias : [null_familia],
	trabajadores : [null_persona],
	clientes : [null_persona],
	edificios_cerca : [],
	trabajos_cerca : [],
	casas_cerca : [],
	iglesias_cerca : [],
	almacen_cerca : [],
	x : 0,
	y : 0,
	tipo : 0,
	dia_factura : 0,
	count : 0,
	almacen : undefined,
	eficiencia : 1,
	modo : 0,
	array_real_1 : [],
	array_real_2 : []
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
array_push(null_edificio.almacen_cerca, null_edificio)
null_edificio.almacen_cerca = []
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
jubilado = add_edificio(0, 0, 1, false)
desausiado = add_edificio(0, 0, 2, false)
medicos = [desausiado]
homeless = add_edificio(0, 0, 3, false)
null_familia.casa = homeless
edificio_nombre = ["Sin trabajo", "Jubilado", "Sin atención médica", "Homeless", "Granja", "Aserradero", "Escuela", "Consultorio", "Chabola", "Cabaña", "Mansión", "Taberna", "Circo", "Muelle", "Pescadería", "Mina", "Capilla"]
edificio_trabajadores_max = [0, 0, 0, 0, 10, 5, 4, 2, 0, 0, 2, 2, 8, 10, 6, 5, 4]
edificio_trabajo_calidad = [0, 10, 0, 0, 25, 30, 50, 60, 0, 0, 40, 40, 25, 25, 30, 25, 45]
edificio_trabajo_sueldo = [0, 2, 0, 0, 4, 5, 8, 11, 0, 0, 4, 5, 3, 7, 6, 5, 6]
edificio_trabajo_educacion = [0, 0, 0, 0, 0, 0, 2, 3, 0, 0, 0, 0, 0, 0, 1, 0, 1]
edificio_es_casa = [false, false, false, true, false, false, false, false, true, true, true, false, false, false, false, false, false]
edificio_es_trabajo = [false, false, false, false, true, true, true, true, false, false, true, true, true, true, true, true, true]
edificio_es_escuela = [false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false]
edificio_es_medico = [false, false, true, false, false, false, false, true, false, false, false, false, false, false, false, false, false]
edificio_es_ocio = [false, false, true, false, false, false, false, false, false, false, false, true, true, false, false, false, false]
edificio_es_iglesia = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true]
edificio_es_costero = [false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, false, false]
edificio_es_almacen = [false, false, false, false, true, false, false, false, false, false, false, false, false, true, true, false, false]
edificio_clientes_max = [0, 0, 0, 0, 0, 0, 20, 25, 0, 0, 0, 5, 16, 0, 0, 0, 20]
edificio_clientes_calidad = [0, 0, 0, 0, 0, 0, 30, 60, 0, 0, 0, 25, 20, 0, 0, 0, 50]
edificio_clientes_tarifa = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0]
edificio_familias_max = [0, 0, 0, 0, 0, 0, 0, 0, 5, 2, 1, 0, 0, 0, 0, 0, 0]
edificio_familias_calidad = [0, 0, 0, 0, 0, 0, 0, 0, 30, 40, 65, 0, 0, 0, 0, 0, 0]
edificio_familias_renta = [0, 0, 0, 0, 0, 0, 0, 0, 4, 6, 16, 0, 0, 0, 0, 0, 0]
edificio_width = [0, 0, 0, 0, 6, 3, 3, 1, 2, 2, 3, 1, 4, 6, 5, 3, 3]
edificio_height = [0, 0, 0, 0, 3, 2, 3, 3, 2, 1, 2, 2, 4, 6, 5, 4, 5]
edificio_color = [0, 0, 0, 0, 0, 10, 25, -10, 167, 177, 187, -15, 35, 80, 90, 30, 40]
edificio_precio = [0, 0, 0, 0, 400, 650, 300, 700, 300, 200, 500, 250, 450, 2500, 800, 1000, 1500]
edificio_mantenimiento = [0, 0, 0, 0, 4, 5, 6, 10, 3, 2, 10, 3, 6, 2, 8, 10, 12]
edificio_categoria_nombre = ["Residencial", "Producción", "Servicios", "Infrastructura"]
edificio_categoria = [[8, 9, 10], [4, 5, 14, 15], [6, 7, 11, 12, 16], [13]]
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
//Recursos
recurso_nombre = ["Cereales", "Madera", "Plátanos", "Algodón", "Tabaco", "Azucar", "Soya", "Cañamo", "Pescado", "Carbón", "Hierro", "Oro", "Cobre", "Aluminio", "Níquel"]
recurso_precio = [1.2, 0.8, 1.4, 1.2, 1.6, 0.9, 0.8, 1.8, 1.3, 1.6, 1.8, 3.0, 2.0, 1.6, 1.8]
recurso_cultivo = [0, 2, 3, 4, 5, 6, 7]
cultivo_altura_minima = [0.6, 0.55, 0.65, 0.6, 0.55, 0.65, 0.55]
recurso_comida = [0, 2, 6, 8]
recurso_mineral = [9, 10, 11, 12, 13, 14]
recurso_mineral_color = [c_black, c_gray, c_yellow, c_orange, c_ltgray, c_dkgray]
recurso_mineral_rareza = [0.8, 0.85, 0.95, 0.75, 0.85, 0.9]
for(a = 0; a < array_length(recurso_nombre); a++){
	null_edificio.almacen[a] = 0
	jubilado.almacen[a] = 0
	desausiado.almacen[a] = 0
	homeless.almacen[a] = 0
}
//Settings
dia = 0
xsize = 160
ysize = 160
for(a = 0; a < array_length(recurso_cultivo); a++)
	cultivo[a] = perlin(xsize, ysize, 1, false, 6)
var mineral_grid
for(a = 0; a < array_length(recurso_mineral); a++)
	mineral_grid[a] = perlin(xsize, ysize, 1, false, 6)
var grid = perlin(xsize, ysize, 1, false)
if not d3{
	altura = perlin(xsize, ysize, 1, false)
	for(a = 0; a < xsize / 2; a += 3)
		ds_grid_add_disk(altura, floor(xsize / 2), floor(ysize / 2), a, 0.1)
	a = ds_grid_get_max(altura, 0, 0, xsize, ysize)
	ds_grid_multiply_region(altura, 0, 0, xsize, ysize, 1 / a)
	for(a = 0; a < xsize; a++)
		for(b = 0; b < ysize; b++){
			bool_edificio[a, b] = false
			id_edificio[a, b] = null_edificio
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
		}
}
else{
	altura = perlin(xsize, ysize, 14, true)
	for(a = 0; a < xsize / 2; a += 3)
		ds_grid_add_disk(altura, floor(xsize / 2), floor(ysize / 2), a, 1)
	a = ds_grid_get_max(altura, 0, 0, xsize, ysize)
	ds_grid_multiply_region(altura, 0, 0, xsize, ysize, 14 / a)
	ds_grid_add_region(altura, 0, 0, xsize, ysize, -4)
	for(a = 0; a < xsize; a++)
		for(b = 0; b < ysize; b++){
			var h = altura[# a, b]
			bool_edificio[a, b] = false
			id_edificio[a, b] = null_edificio
			mar[a, b] = (h <= 0)
			bosque[a, b] = grid[# a, b] > 0.6 and h > 2
			if bosque[a, b]
				bosque_madera[a, b] = floor(160 * grid[# a, b])
			for(var c = 0; c < array_length(recurso_cultivo); c++)
				if (h + 4) / 14 < cultivo_altura_minima[c]
					ds_grid_set(cultivo[c], a, b, 0)
				else if (h + 4) / 14 < cultivo_altura_minima[c] + 0.05
					ds_grid_multiply(cultivo[c], a, b, 20 * ((h + 4) / 14 - cultivo_altura_minima[c]))
			for(var c = 0; c < array_length(recurso_mineral); c++){
				mineral[c][a, b] = (mineral_grid[c][# a, b] > recurso_mineral_rareza[c])
				mineral_cantidad[c][a, b] = round(320 * power(mineral_grid[c][# a, b], 3))
			}
		}
}
var gg = mineral[0]
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
educacion_nombre = ["Analfabeto", "Educación Básica", "Educación Media", "Educación Técnica", "Educación Profesional"]
pais_nombre = ["Trópico", "Cuba", "México", "El Salvador", "Costa Rica", "Honduras", "Panamá", "Guatemala", "Haití", "República Dominicana", "Venezuela", "Colombia", "Brasil", "Belice", "Jamaica", "Nicaragua", "Bahamas", "Estados Unidos"]
pais_idioma = [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 2, 3, 3, 0, 3, 3]
pais_religion = [92, 59, 95, 88, 91, 88, 93, 95, 87, 88, 90, 92, 88, 88, 77, 86, 96, 78]
idioma_nombre = ["Español", "Francés", "Portugués", "Inglés"]
ministerio_nombre = ["Población", "Vivienda", "Trabajo", "Salud", "Educación", "Economía"]
ministerio = -1
felicidad_total = 50
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
}
for(a = 0; a < array_length(edificio_nombre); a++)
	show[a] = false
dinero = 10000
pos = 0
deuda = false
deuda_dia = 0
repeat(10)
	add_familia(0)
do{
	a = irandom(xsize - edificio_width[13])
	b = irandom(ysize - edificio_height[13])
}
until edificio_valid_place(a, b, 13)
add_edificio(a, b, 13)
edificios[0].almacen[0] = irandom_range(1000, 1500)
xpos = min(max(0, 16 * a - room_width / 2), xsize * 16 - room_width)
ypos = min(max(0, 16 * b - room_height / 2), ysize * 16 - room_height)
last_width = 0
last_height = 0
current_mes = 0
if d3{
	vern_x = undefined;	vern_y = undefined
	vers_x = undefined;	vers_y = undefined
	vere_x = undefined; vere_y = undefined
	vero_x = undefined; vero_y = undefined
	zoom = 1
	for(var c = 0; c < xsize / 40; c++)
		for(var d = 0; d < ysize / 40; d++)
			background[c, d] = spr_arbol
}
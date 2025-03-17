function gen_nombre(sexo){
	if sexo
		return choose("Amanda", "Beatriz", "Carla", "Dominga", "Eleonora", "Fabiola", "Gabriela", "Helena", "Isidora", "Josefina", "Karina", "Luisa", "Martina", "Noelia", "Opal", "Paulina", "Rosa", "Samanta", "Tamara", "Valeria", "Ximena", "Zara")
	else
		return choose("Armando", "Bruno", "Clemente", "Darío", "Esteban", "Francismo", "Gustavo", "Henrique", "Ignacio", "Juan", "Leonardo", "Mario", "Nicolas", "Osvaldo", "Pedro", "Ricardo", "Simón", "Tomas", "Valentín", "Xavier")
}
function gen_apellido(){
	return choose("Alvares", "Acuña", "Benides", "Bolivar", "Carrasco", "Casablanca", "Donoso", "Durán", "Escobar", "Espinoza", "Fernandez", "Flores", "Gonzales", "Guerrero", "Hernandez", "Hormazábal", "Irarrazaval", "Iturra", "Jimenez", "Larraín", "Lozana", "Meneses", "Marín", "Nuñez", "Noriega", "Ortiz", "Polanco", "Peña", "Quevedo", "Quezada", "Ramirez", "Román", "Sandoval", "Saavedra", "Tapia", "Troncoso", "Ugarte", "Urquiza", "Velasquez", "Vicuña", "Yañez", "Zamora", "Zuñiga")
}
function gen_nombre_empresa(){
	return choose(gen_apellido(), control.pais_nombre[irandom(array_length(control.pais_nombre) - 1)]) + " " + choose("Ldta.", "S.A.", "Hmns.", "Corp.", "Asociados")
}
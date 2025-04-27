function gen_nombre(sexo, idioma = 0){
	if idioma = 0{
		if sexo
			return choose("Amanda", "Beatriz", "Carla", "Dominga", "Eleonora", "Fabiola", "Gabriela", "Helena", "Isidora", "Josefina", "Karina", "Luisa", "Martina", "Noelia", "Opal", "Paulina", "Rosa", "Samanta", "Tamara", "Valeria", "Ximena", "Zara")
		else
			return choose("Armando", "Bruno", "Clemente", "Darío", "Esteban", "Francisco", "Gustavo", "Henrique", "Ignacio", "Juan", "Leonardo", "Mario", "Nicolas", "Osvaldo", "Pedro", "Ricardo", "Simón", "Tomas", "Valentín", "Xavier")
	}
	else if idioma = 1{
		if sexo
			return choose("Adrianne", "Antoine", "Amélie", "Camille", "Dominique", "Jade", "Emma", "Marie", "Françoise")
		else
			return choose("Pierre", "Rêmi", "Jacques", "Jean", "Renaud", "Gerard", "Alphonse", "Louis", "André")
	}
	else if idioma = 2{
		if sexo
			return choose("Margarida", "Rita", "Sofia", "Ana", "Maria", "Isabel")
		else
			return choose("Jean", "Joâo", "Fernando", "Paulo", "António", "Manuel")
	}
	else if idioma = 3{
		if sexo
			return choose("Mary", "Juliet", "Catherine", "Elizabeth", "Sarah", "Alice")
		else
			return choose("John", "Paul", "Brian", "Michael", "Henry", "Richard", "George", "William")
	}
	else if idioma = 4{
		if sexo
			return choose("Katharina", "Johanna", "Hedwig", "Ingrid", "Anneliese", "Gudrum")
		else
			return choose("Otto", "Swen", "Stefan", "Friedich", "Karl", "Ernst", "Franz")
	}
	else if idioma = 5{
		if sexo
			return choose("Tatiana", "Svetlana", "Valentina", "Irina", "Larisa", "Olga")
		else
			return choose("Dmitri", "Yuri", "Alexei", "Sergei", "Vladimir", "Nikolai")
	}
	else if idioma = 6{
		if sexo
			return choose("Mei", "Lan", "Xiu", "Fang", "Ling", "Hua")
		else
			return choose("Wei", "Jun", "Ming", "Hao", "Qiang", "Zhen")
	}
}
function gen_apellido(idioma = 0){
	if idioma = 0
		return choose("Alvares", "Acuña", "Benides", "Bolivar", "Carrasco", "Casablanca", "Donoso", "Durán", "Escobar", "Espinoza", "Fernandez", "Flores", "Gonzales", "Guerrero", "Hernandez", "Hormazábal", "Irarrazaval", "Iturra", "Jimenez", "Larraín", "Lozana", "Meneses", "Marín", "Nuñez", "Noriega", "Ortiz", "Polanco", "Peña", "Quevedo", "Quezada", "Ramirez", "Román", "Sandoval", "Saavedra", "Tapia", "Troncoso", "Ugarte", "Urquiza", "Velasquez", "Vicuña", "Yañez", "Zamora", "Zuñiga")
	else if idioma = 1
		return choose("Dupont", "Durand", "Moreau", "Lefebvre", "Laurent", "Martin", "Bernard", "Petit", "Roux", "Girard")
	else if idioma = 2
		return choose("Silva", "Santos", "Oliveira", "Pereira", "Costa", "Ferreira", "Sousa", "Lima", "Carvalho", "Rocha")
	else if idioma = 3
		return choose("Smith", "Brown", "Johnson", "Taylor", "Wilson", "Clark", "Wright", "Hall", "Baker", "Harris")
	else if idioma = 4
		return choose("Müler", "Schimdt", "Schneider", "Fischer", "Weber", "Meyer", "Wagner", "Becker", "Hoffmann", "Schäfer")
	else if idioma = 5
		return choose("Ivanov", "Petrov", "Sokolov", "Morozov", "Smirnov", "Volkov", "Kalashnikov")
	else if idioma = 6
		return choose("Li", "Wang", "Zhang", "Chen", "Yang", "Zhao", "Wu", "Sun")
}
function gen_nombre_empresa(){
	with control{
		return choose(gen_apellido(), pais_nombre[array_pick(pais_current)]) + " " + choose("Ldta.", "S.A.", "Hmns.", "Corp.", "Asociados")
	}
}
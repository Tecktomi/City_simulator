function def_guerra(nombre = "guerra", inicio = 0, fin = 0, bando_a = [0], bando_b = [0]){
	with control{
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
}
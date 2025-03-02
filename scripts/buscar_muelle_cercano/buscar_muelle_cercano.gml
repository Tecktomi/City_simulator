function buscar_muelle_cercano(edificio = control.null_edificio){
	with control{
		var b = 9999, c = null_edificio, d = 0
		for(var a = 0; a < array_length(edificio_count[13]); a++){
			var muelle = edificio_count[13, a]
			d = distancia(edificio, muelle)
			if d < b{
				b = d
				c = muelle
				if d = 0
					break
			}
		}
		edificio.muelle_cercano = c
		edificio.distancia_muelle_cercano = b
	}
}
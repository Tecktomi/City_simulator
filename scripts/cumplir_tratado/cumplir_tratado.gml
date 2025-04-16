function cumplir_tratado(tratado = control.null_tratado){
	with control{
		if debug
			show_debug_message($"{fecha(dia)} Has cumplido el tratado de {tratado.tipo ? "exportación" : "importación"} {recurso_nombre[tratado.recurso]} con {pais_nombre[tratado.pais]}")
		pais_relacion[tratado.pais]++
		for(var e = 0; e < array_length(pais_guerras[tratado.pais]); e++){
			var guerra = pais_guerras[tratado.pais, e]
			if array_contains(guerra.bando_a, tratado.pais){
				for(var f = 0; f < array_length(guerra.bando_a); f++)
					pais_relacion[guerra.bando_a[f]] += 0.5
				for(var f = 0; f < array_length(guerra.bando_b); f++)
					pais_relacion[guerra.bando_b[f]] -= 0.5
			}
			else{
				for(var f = 0; f < array_length(guerra.bando_a); f++)
					pais_relacion[guerra.bando_a[f]] -= 0.5
				for(var f = 0; f < array_length(guerra.bando_b); f++)
					pais_relacion[guerra.bando_b[f]] += 0.5
			}
		}
		if tratado.tipo
			array_shift(recurso_tratados_venta[tratado.recurso])
		else
			array_shift(recurso_tratados_compra[tratado.recurso])
		credibilidad_financiera = clamp(credibilidad_financiera + 1, 1, 10)
	}
}
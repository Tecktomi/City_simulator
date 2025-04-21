function cumplir_tratado(tratado = control.null_tratado){
	with control{
		add_noticia("Tratado cumplido", $"Has cumplido el tratado de {tratado.tipo ? "exportación" : "importación"} {recurso_nombre[tratado.recurso]} con {pais_nombre[tratado.pais]}")
		var factor = 1
		if tratado.recurso = 28 and array_length(pais_guerras[tratado.pais]) > 0
			factor = 2
		pais_relacion[tratado.pais] += factor
		for(var e = 0; e < array_length(pais_guerras[tratado.pais]); e++){
			var guerra = pais_guerras[tratado.pais, e]
			if array_contains(guerra.bando_a, tratado.pais){
				for(var f = 0; f < array_length(guerra.bando_a); f++)
					pais_relacion[guerra.bando_a[f]] += 0.5 * factor
				for(var f = 0; f < array_length(guerra.bando_b); f++)
					pais_relacion[guerra.bando_b[f]] -= 0.5 * factor
			}
			else{
				for(var f = 0; f < array_length(guerra.bando_a); f++)
					pais_relacion[guerra.bando_a[f]] -= 0.5 * factor
				for(var f = 0; f < array_length(guerra.bando_b); f++)
					pais_relacion[guerra.bando_b[f]] += 0.5 * factor
			}
		}
		if tratado.tipo
			array_shift(recurso_tratados_venta[tratado.recurso])
		else
			array_shift(recurso_tratados_compra[tratado.recurso])
		credibilidad_financiera = clamp(credibilidad_financiera + 1, 1, 10)
		tratados_num--
	}
}
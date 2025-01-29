function fallar_exigencia(index){
	with control{
		var temp_exigencia = exigencia[index]
		show_debug_message("Has fallado en " + exigencia_nombre[temp_exigencia.index])
		for(var a = 0; a < array_length(temp_exigencia.edificios); a++){
			var edificio = temp_exigencia.edificios[a]
			edificio.paro = true
			edificio.paro_tiempo = 24 + 6 * array_length(temp_exigencia.edificios)
			edificio.paro_motivo = exigencia_siguiente[edificio.paro_motivo]
			edificio.exigencia = null_exigencia
			edificio.exigencia_fallida = true
		}
		exigencia_pedida[index] = false
		exigencia[index] = null_exigencia
	}
}
function cumplir_exigencia(index){
	with control{
		if exigencia_pedida[index]{
			var temp_exigencia = exigencia[index]
			for(var a = 0; a < array_length(temp_exigencia.edificios); a++){
				var edificio = temp_exigencia.edificios[a]
				edificio.exigencia = null_exigencia
				edificio.paro = false
				edificio.exigencia_fallida = false
			}
			exigencia_pedida[index] = false
			exigencia[index] = null_exigencia
			exigencia_cumplida[index] = true
			exigencia_cumplida_time[index] = 24
			show_debug_message("Has cumplido con " + exigencia_nombre[index])
		}
	}
}
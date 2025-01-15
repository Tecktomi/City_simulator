function add_paro(motivo, edificio = control.null_edificio){
	with control{
		if not exigencia_pedida[motivo]{
			edificio.paro = true
			edificio.paro_motivo = motivo
			edificio.paro_tiempo = 6
			for(var a = 0; a < array_length(edificios); a++)
				if edificios[a].paro and edificios[a].paro_motivo = motivo
					edificios[a].paro_tiempo += 12
		}
		else if exigencia_pedida[motivo]{
			array_push(exigencia[motivo].edificios, edificio)
			break
		}
	}
}
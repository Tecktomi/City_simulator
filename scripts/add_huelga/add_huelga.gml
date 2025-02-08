function add_huelga(motivo, edificio = control.null_edificio){
	with control{
		if not exigencia_pedida[motivo]{
			set_paro(true, edificio)
			edificio.huelga = true
			edificio.huelga_motivo = motivo
			edificio.huelga_tiempo = 6
			for(var a = 0; a < array_length(edificios); a++)
				if edificios[a].huelga and edificios[a].huelga_motivo = motivo
					edificios[a].huelga_tiempo += 12
		}
		else if exigencia_pedida[motivo]
			array_push(exigencia[motivo].edificios, edificio)
	}
}
function buscar_zona_pesca(edificio = control.null_edificio){
	with control{
		var closer = -1, closer_dis = infinity
		for(var c = 0; c < array_length(zonas_pesca); c++){
			var zona_pesca = zonas_pesca[c], a = zona_pesca.a, b = zona_pesca.b, closer_current = sqrt(sqr(a - edificio.x) + sqr(b - edificio.y))
			if closer_current < closer_dis and (not ley_eneabled[13] or zona_pesca.cantidad > 1250){
				closer_dis = closer_current
				closer = c
			}
		}
		if closer != -1{
			edificio.zona_pesca = zonas_pesca[closer]
			edificio.eficiencia = 30 / (20 + closer_dis)
			return true
		}
		else{
			edificio.zona_pesca = null_zona_pesca
			edificio.eficiencia = 0
			return false
		}
	}
}
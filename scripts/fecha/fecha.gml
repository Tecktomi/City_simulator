function fecha(dia, anno = true){
	var mes = floor(dia / 30) mod 12, mes_name = ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"]
	if anno
		return $"{mes_name[mes]}, {1800 + floor(dia / 360)}"
	else
		return mes_name[mes]
}
function dia_mes(dia){
	return dia mod 30
}
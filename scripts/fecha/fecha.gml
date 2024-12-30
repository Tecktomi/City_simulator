function fecha(dia, anno = true){
	var day = dia mod 365, text
	if day < 31
		text = string(day) + " de enero"
	else if day < 59
		text = string(day - 30) + " de febrero"
	else if day < 90
		text = string(day - 58) + " de marzo"
	else if day < 120
		text = string(day - 89) + " de abril"
	else if day < 151
		text = string(day - 119) + " de mayo"
	else if day < 181
		text = string(day - 150) + " de junio"
	else if day < 212
		text = string(day - 180) + " de julio"
	else if day < 243
		text = string(day - 211) + " de agosto"
	else if day < 273
		text = string(day - 242) + " de septiembre"
	else if day < 304
		text = string(day - 272) + " de octubre"
	else if day < 334
		text = string(day - 303) + " de noviembre"
	else
		text = string(day - 333) + " de diciembre"
	if anno
		return text + ", " + string(floor(dia / 365))
	else
		return text
}
function mes(dia){
	var day = dia mod 365
	if day < 31
		return 0
	else if day < 59
		return 1
	else if day < 90
		return 2
	else if day < 120
		return 3
	else if day < 151
		return 4
	else if day < 181
		return 5
	else if day < 212
		return 6
	else if day < 243
		return 7
	else if day < 273
		return 8
	else if day < 304
		return 9
	else if day < 334
		return 10
	else
		return 11
}
function dia_mes(dia){
	var day = dia mod 365
	if day < 31
		return day
	else if day < 59
		return day - 31
	else if day < 90
		return day - 59
	else if day < 120
		return day - 90
	else if day < 151
		return day - 120
	else if day < 181
		return day - 151
	else if day < 212
		return day - 181
	else if day < 243
		return day - 212
	else if day < 273
		return day - 243
	else if day < 304
		return day - 273
	else if day < 334
		return day - 304
	else
		return day - 334
}
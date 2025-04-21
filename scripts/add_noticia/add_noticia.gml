function add_noticia(titulo, descripcion = ""){
	with control{
		var noticia = {
			dia : dia,
			titulo : string(titulo),
			descripcion : descripcion
		}
		array_push(noticias, noticia)
		if debug
			show_debug_message($"{fecha(dia)} {titulo}{descripcion = "" ? ":\n" + descripcion : ""}")
		return noticia
	}
}
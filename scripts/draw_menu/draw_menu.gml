function draw_menu(x, y, text, menu, borde = false, close = true){
	with control{
		if draw_boton(x, y, $"{show[real(menu)] ? "< " : "> "} {text}", borde){
			if close{
				close_show()
				show[real(menu)] = true
			}
			else
				show[real(menu)] = not show[real(menu)]
		}
		return show[real(menu)]
	}
}
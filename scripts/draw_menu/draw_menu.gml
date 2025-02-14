function draw_menu(x, y, text, menu, borde = false, close = false){
	with control{
		if draw_boton(x, y, $"{show[real(menu)] ? "< " : "> "} {text}", borde){
			if close{
				var flag = show[real(menu)]
				close_show()
				show[real(menu)] = not flag
			}
			else
				show[real(menu)] = not show[real(menu)]
		}
		return show[real(menu)]
	}
}
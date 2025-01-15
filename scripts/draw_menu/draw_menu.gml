function draw_menu(x, y, text, menu, borde = false, close = true){
	if draw_boton(x, y, text, borde){
		if close{
			close_show()
			control.show[real(menu)] = true
		}
		else
			control.show[real(menu)] = not control.show[real(menu)]
	}
	return control.show[real(menu)]
}
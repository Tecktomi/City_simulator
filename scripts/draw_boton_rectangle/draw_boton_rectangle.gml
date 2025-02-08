function draw_boton_rectangle(x1, y1, x2, y2, menu){
	draw_rectangle(x1, y1, x2, y2, not menu)
	if mouse_x > x1 and mouse_y > y1 and mouse_x < x2 and mouse_y < y2{
		window_set_cursor(cr_handpoint)
		if mouse_check_button_pressed(mb_left){
			mouse_clear(mb_left)
			return not menu
		}
	}
	return menu
}
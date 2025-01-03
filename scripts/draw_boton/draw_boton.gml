function draw_boton(x, y, text, borde = false){
	var c = draw_get_color()
	var d = draw_get_halign()
	if borde{
		draw_set_color(c_ltgray)
		if d = fa_left
			draw_rectangle(x, y, x + string_width(text), y + string_height(text), false)
		else
			draw_rectangle(x, y, x - string_width(text), y + string_height(text), false)
		draw_set_color(c_black)
		if d = fa_left
			draw_rectangle(x, y, x + string_width(text), y + string_height(text), true)
		else
			draw_rectangle(x, y, x - string_width(text), y + string_height(text), true)
	}
	draw_text(x, y, text)
	control.last_width = string_width(text)
	control.last_height = string_height(text)
	control.pos += last_height
	if d = fa_left{
		if mouse_x > x and mouse_y > y and mouse_x < x + string_width(text) and mouse_y < y + string_height(text){
			window_set_cursor(cr_handpoint)
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				return true
			}
			else
				return false
		}
		else
			return false
	}
	else{
		if mouse_x > x - string_width(text) and mouse_y > y and mouse_x < x and mouse_y < y + string_height(text){
			window_set_cursor(cr_handpoint)
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				return true
			}
			else
				return false
		}
		else
			return false
	}
}
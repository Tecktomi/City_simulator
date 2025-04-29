function draw_boton_color(x, y, text, borde = false, able = true, display = undefined, display_arguments = undefined, pressed = true, vertical = true, right = false){
	with control{
		var c = draw_get_color(), d = draw_get_halign(), e = (d = fa_left ? 1 : (d = fa_center ? 0.5 : 0))
		var f = draw_get_valign(), g = (f = fa_top ? 1 : (f = fa_middle ? 0.5 : 0)), width = string_width(text), height = string_height(text)
		if borde{
			draw_set_color(c_ltgray)
			draw_rectangle(x + (e - 1) * width, y + (1 - g) * height, x + e * width, y + g * height, false)
			draw_set_color(c_black)
			draw_rectangle(x + (e - 1) * width, y + (1 - g) * height, x + e * width, y + g * height, true)
		}
		draw_text_pos_color(x, y, text)
		pos -= last_height
		last_width = width
		last_height = height
		if vertical
			pos += (2 * g - 1) * height
		else
			wpos += (2 * e - 1) * width
		if able{
			if mouse_x > x + (e - 1) * width and mouse_y > y + (1 - g) * height and mouse_x < x + e * width and mouse_y < y + g * height{
				cursor = cr_handpoint
				if display != undefined
					display(display_arguments)
				if (mouse_check_button_pressed(mb_left) or (not pressed and mouse_check_button(mb_left))) or (right and (mouse_check_button_pressed(mb_right) or (not pressed and mouse_check_button(mb_right)))){
					if pressed{
						mouse_clear(mb_left)
						if right
							mouse_clear(mb_right)
					}
					return true
				}
			}
		}
		return false
	}
}
function show_tutorial(x, y, text, enter = true, xbox = 0, ybox = 0, wbox = 0, hbox = 0){
	with control{
		draw_set_color(c_black)
		draw_set_alpha(0.5)
		draw_rectangle(0, 0, xbox, room_height, false)
		draw_rectangle(xbox + 1, 0, room_width, ybox, false)
		draw_rectangle(xbox + 1, hbox, room_width, room_height, false)
		draw_rectangle(wbox, ybox + 1, room_width, hbox - 1, false)
		draw_set_color(c_white)
		draw_set_alpha(1)
		if enter
			if tutorial = tutorial_max - 1
				text += "\n(Enter para terminar)"
			else
				text += "\n(Enter para continuar)"
		draw_set_font(font_big)
		draw_text(x, y, text)
		draw_set_font(Font1)
		if mouse_check_button_pressed(mb_left) and not (mouse_x > xbox and mouse_y > ybox and mouse_x < wbox and mouse_y < hbox)
			mouse_clear(mb_left)
		if (enter and keyboard_check_pressed(vk_enter)) or tutorial_complete{
			keyboard_clear(vk_enter)
			tutorial = (tutorial + 1) mod tutorial_max
			tutorial_complete = false
			return true
		}
		return false
	}
}
function draw_sprite_boton(sprite, subsprite, x, y, w, h){
	draw_sprite_stretched(sprite, subsprite, x, y, w, h)
	if mouse_x > x and mouse_y > y and mouse_x < x + w and mouse_y < y + h{
		window_set_cursor(cr_handpoint)
		if mouse_check_button_pressed(mb_left){
			mouse_clear(mb_left)
			return true
		}
	}
	return false
}
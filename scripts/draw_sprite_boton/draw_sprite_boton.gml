function draw_sprite_boton(sprite, subsprite, x, y, w = 0, h = 0){
	if w = 0
		w = sprite_get_width(sprite)
	if h = 0
		h = sprite_get_height(sprite)
	draw_sprite_stretched(sprite, subsprite, x, y, w, h)
	if mouse_x > x and mouse_y > y and mouse_x < x + w and mouse_y < y + h{
		cursor = cr_handpoint
		if mouse_check_button_pressed(mb_left){
			show_debug_message("mouse draw_sprite_boton")
			mouse_clear(mb_left)
			return true
		}
	}
	return false
}
function draw_sprite_boton(sprite, subsprite, x, y, w = 0, h = 0, right = false, display = ""){
	if w = 0 or h = 0{
		draw_sprite(sprite, subsprite, x, y)
		w = sprite_get_width(sprite)
		h = sprite_get_height(sprite)
	}
	else
		draw_sprite_stretched(sprite, subsprite, x, y, w, h)
	if mouse_x > x and mouse_y > y and mouse_x < x + w and mouse_y < y + h{
		cursor = cr_handpoint
		if display != ""
			mouse_string += display
		if mouse_check_button_pressed(mb_left){
			mouse_clear(mb_left)
			return true
		}
		if right and mouse_check_button_pressed(mb_right){
			mouse_clear(mb_right)
			return true
		}
	}
	return false
}
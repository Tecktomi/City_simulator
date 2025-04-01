function draw_relacion(xx, yy, relacion = null_relacion, iter = 0){
	if iter = 5
		return
	draw_sprite(spr_icono, relacion.sexo, xx, yy)
	if not relacion.vivo
		draw_set_color(c_black)
	else
		if relacion.sexo
			draw_set_color(c_fuchsia)
		else
			draw_set_color(c_aqua)
	draw_circle(xx, yy, 8, false)
	draw_set_color(c_black)
	if mouse_x > xx - 10 and mouse_y > yy - 10 and mouse_x < xx + 10 and mouse_y < yy + 10{
		draw_text(mouse_x, mouse_y, relacion.nombre)
		cursor = cr_handpoint
		if mouse_check_button_pressed(mb_left){
			mouse_clear(mb_left)
			if relacion.vivo
				sel_persona = relacion.persona
		}
	}
	if relacion.padre != null_relacion
		draw_relacion(xx - 15 * (4 - iter), yy - 30, relacion.padre, iter + 1)
	if relacion.madre != null_relacion
		draw_relacion(xx + 15 * (4 - iter), yy - 30, relacion.madre, iter + 1)
}
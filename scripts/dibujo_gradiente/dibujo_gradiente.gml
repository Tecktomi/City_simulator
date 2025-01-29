function dibujo_gradiente(tipo, modo){
	if modo = 0{
		for(var a = 0; a < control.xsize; a++)
			for(var b = 0; b < control.ysize; b++)
				if not control.bosque[a, b] and not control.mar[a, b]{
					draw_set_color(make_color_rgb(255 * (1 - control.cultivo[tipo][# a, b]), 255 * control.cultivo[tipo][# a, b], 0))
					draw_circle(a * 16 + 8 - control.xpos, b * 16 + 8 - control.ypos, 6, false)
				}
		draw_set_color(c_white)
		draw_text(0, 0, control.recurso_nombre[control.recurso_cultivo[tipo]])
	}
	if modo = 1{
		draw_set_color(control.recurso_mineral_color[tipo])
		for(var a = 0; a < control.xsize; a++)
			for(var b = 0; b < control.ysize; b++)
				if control.mineral[tipo][a, b]
					draw_circle(a * 16 + 8 - control.xpos, b * 16 + 8 - control.ypos, 6, false)
		draw_set_color(c_white)
		draw_text(0, 0, control.recurso_nombre[control.recurso_mineral[tipo]])
	}
	if modo = 2{
		draw_set_alpha(0.5)
		for(var a = 0; a < control.xsize; a++)
			for(var b = 0; b < control.ysize; b++){
				draw_set_color(make_color_rgb(2.55 * (100 - control.belleza[a, b]), 2.55 * control.belleza[a, b], 0))
				draw_rectangle(a * 16 - control.xpos, b * 16 - control.ypos, a * 16 + 15 - control.xpos, b * 16 + 15 - control.ypos, false)
			}
		draw_set_alpha(1)
		draw_set_color(c_white)
		draw_text(0, 0, "Belleza")
		if mouse_x > 0 and mouse_y > 0 and mouse_x < room_width and mouse_y < room_height{
			draw_text(0, 20, control.belleza[floor((mouse_x + control.xpos) / 16), floor((mouse_y + control.ypos) / 16)])
		}
	}
}
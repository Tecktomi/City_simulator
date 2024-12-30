function dibujo_gradiente(tipo, cultivo){
	if cultivo{
		for(var a = 0; a < control.xsize; a++)
			for(var b = 0; b < control.ysize; b++)
				if not control.bosque[a, b] and not control.mar[a, b]{
					draw_set_color(make_color_rgb(255 * (1 - control.cultivo[tipo][# a, b]), 255 * control.cultivo[tipo][# a, b], 0))
					draw_circle(a * 16 + 8 - control.xpos, b * 16 + 8 - control.ypos, 6, false)
				}
		draw_set_color(c_white)
		draw_text(0, 0, control.recurso_nombre[control.recurso_cultivo[tipo]])
	}
	if not cultivo{
		draw_set_color(control.recurso_mineral_color[tipo])
		for(var a = 0; a < control.xsize; a++)
			for(var b = 0; b < control.ysize; b++)
				if control.mineral[tipo][a, b]
					draw_circle(a * 16 + 8 - control.xpos, b * 16 + 8 - control.ypos, 6, false)
		draw_set_color(c_white)
		draw_text(0, 0, control.recurso_nombre[control.recurso_mineral[tipo]])
	}
}
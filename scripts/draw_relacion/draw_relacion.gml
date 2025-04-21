function draw_relacion(xx, yy, relacion = control.null_relacion){
	with control{
		var a = xx, color = draw_get_color()
		if relacion.pareja != null_relacion{
			a -= 20
			draw_line(a + 10, yy + 10, a + 50, yy + 10)
			if draw_sprite_boton(spr_icono, relacion.pareja.sexo, a + 40, yy) and relacion.pareja.vivo
				sel_persona = relacion.pareja.persona
		}
		draw_set_color(c_red)
		draw_set_alpha(0.5)
		draw_circle(a + 10, yy + 10, 12, false)
		draw_set_color(color)
		draw_set_alpha(1)
		draw_sprite(spr_icono, relacion.sexo, a, yy)
		if relacion.padre != null_relacion and draw_sprite_boton(spr_icono, relacion.padre.sexo, a - 20, yy - 40) and relacion.padre.vivo
			sel_persona = relacion.padre.persona
		if relacion.madre != null_relacion and draw_sprite_boton(spr_icono, relacion.madre.sexo, a + 20, yy - 40) and relacion.madre.vivo
			sel_persona = relacion.madre.persona
		for(var b = 0; b < array_length(relacion.hijos); b++)
			if draw_sprite_boton(spr_icono, relacion.hijos[b].sexo, a - 20 * array_length(relacion.hijos) + b * 40, yy + 40) and relacion.hijos[b].vivo
				sel_persona = relacion.hijos[b].persona
	}
}
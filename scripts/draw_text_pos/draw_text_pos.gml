function draw_text_pos(x, y, text){
	draw_text(x, y, text)
	control.last_width = string_width(text)
	control.last_height = string_height(text)
	if draw_get_valign() = fa_top
		control.pos += control.last_height
	else
		control.pos -= control.last_height
}
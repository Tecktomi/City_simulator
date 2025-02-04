function draw_text_pos(x, y, text){
	with control{
		draw_text(x, y, text)
		last_width = string_width(text)
		last_height = string_height(text)
		if draw_get_valign() = fa_top
			pos += last_height
		else
			pos -= last_height
	}
}
function draw_text_pos(x, y, text, vertical = true){
	with control{
		draw_text(x, y, text)
		last_width = string_width(text)
		last_height = string_height(text)
		if vertical{
			if draw_get_valign() = fa_top
				pos += last_height
			else
				pos -= last_height
		}
		else if draw_get_halign() = fa_left
			wpos += last_width
		else
			wpos -= last_width
	}
}
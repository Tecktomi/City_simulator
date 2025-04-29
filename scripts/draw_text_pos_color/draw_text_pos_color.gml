function draw_text_pos_color(x, y, text, vertical = true){
	with control{
		for(var a = 1; a <= string_length(text); a++){
			var char = string_char_at(text, a)
			if char = "#"{
				var temp_text = ""
				for(var b = 1; b < 7; b++)
					temp_text += string_char_at(text, a + b)
				draw_set_color(real("0x" + temp_text))
				text = string_delete(text, a--, 7)
			}
			else{
				draw_text(x, y, char)
				x += string_width(char)
			}
		}
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
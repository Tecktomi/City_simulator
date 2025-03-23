function tutorial_set(id, x = -1, y = -1, text = "", enter = true, xbox = 0, ybox = 0, wbox = 0, hbox = 0){
	with control{
		if tutorial = id{
			tutorial_xbox[id] = xbox
			tutorial_ybox[id] = ybox
			tutorial_wbox[id] = wbox
			tutorial_hbox[id] = hbox
			if x != -1
				tutorial_xtext[id] = x
			if y != -1
				tutorial_ytext[id] = y
			if text != ""
				tutorial_text[id] = text
		}
	}
}
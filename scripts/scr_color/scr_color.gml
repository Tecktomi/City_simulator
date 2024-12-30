function scr_color(altura_1, altura_2){
	if altura_1 > 0{
	    if altura_2 <= 0
	        return(make_color_rgb(127, 127, 63))
	    else
	        if altura_1 < 9
	            return(make_color_rgb(16 * altura_1, 127, 16 * altura_1))
	        else
	            return(c_white)
	}
	else{
	    if altura_2 > 0
	        return(make_color_rgb(127, 127, 63))
	    else
	        return(make_color_rgb(63 + 8 * altura_1, 63 + 8 * altura_1, 127 + 16 * altura_1))
	}
}
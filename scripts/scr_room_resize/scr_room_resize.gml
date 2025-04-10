function scr_room_resize(width, height){
	window_set_size(width, height)
	window_center()
	ini_open(roaming + "config.txt")
	ini_write_real("MAIN", "view_width", width)
	ini_write_real("MAIN", "view_height", height)
	ini_close()
}
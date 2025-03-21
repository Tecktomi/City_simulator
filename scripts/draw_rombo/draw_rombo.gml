function draw_rombo(xn, yn, xw, yw, xs, ys, xe, ye, outline){
	if outline{
		draw_line(xn, yn, xw, yw)
		draw_line(xw, yw, xs, ys)
		draw_line(xs, ys, xe, ye)
		draw_line(xe, ye, xn, yn)
	}
	else{
		draw_triangle(xn, yn, xw, yw, xs, ys, false)
		draw_triangle(xn, yn, xe, ye, xs, ys, false)
	}
}
function draw_rombo_coord(a, b, width, height, outline){
	with control
		draw_rombo(	(a - b) * tile_width - xpos, (a + b) * tile_height - ypos,
					(a - b - height) * tile_width - xpos, (a + b + height) * tile_height - ypos,
					(a - b + width - height) * tile_width - xpos, (a + b + width + height) * tile_height - ypos,
					(a - b + width) * tile_width - xpos, (a + b + width) * tile_height - ypos, outline)
}
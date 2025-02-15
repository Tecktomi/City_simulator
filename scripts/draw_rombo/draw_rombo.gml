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
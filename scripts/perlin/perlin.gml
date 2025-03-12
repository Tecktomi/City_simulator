function perlin(xsize, ysize, maximo, integer = false, s = 4){
	var a, b, c, grid, d = xsize / s + 1, e = ysize / s + 1
	grid = ds_grid_create(xsize, ysize)
	for(a = 0; a <= d; a++)
	    for(b = 0; b <= e; b++)
	        c[a, b] = random(1)
	for(a = 0; a < xsize; a++)
	    for(b = 0; b < ysize; b++){
			d = floor(a / s)
			e = floor(b / s)
			var f = a mod s, g = b mod s;
	        ds_grid_set(grid, a, b, c[d, e] * (s - f) * (s - g) + c[d + 1, e] * f * (s - g) +  c[d, e + 1] * (s - f) * g + c[d + 1, e + 1] * f * g)}
	c = maximo / ds_grid_get_max(grid, 0, 0, xsize, ysize)
	if integer{
		for(a = 0; a < xsize; a++)
		    for(b = 0; b < ysize; b++){
				ds_grid_multiply(grid, a, b, c)
				ds_grid_set(grid, a, b, min(floor(grid[# a, b]), maximo - 1))
			}
	}
	else
		for(a = 0; a < xsize; a++)
		    for(b = 0; b < ysize; b++)
		        ds_grid_multiply(grid, a, b, c)
	return grid
}
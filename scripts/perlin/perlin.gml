function perlin(xsize, ysize, maximo, integer = false, s = 4){
	var a, b, c, grid, d = ceil(xsize / s) + 1, e = ceil(ysize / s) + 1
	grid = ds_grid_create(xsize, ysize)
	for(a = 0; a <= d; a++)
	    for(b = 0; b <= e; b++)
	        c[a, b] = random(1)
	for(a = 0; a < xsize; a++){
		d = floor(a / s)
		var f = a mod s, h = s - f
	    for(b = 0; b < ysize; b++){
			e = floor(b / s)
			var g = b mod s, i = s - g, j = d + 1, k = e + 1
	        ds_grid_set(grid, a, b, c[d, e] * h * i + c[j, e] * f * i +  c[d, k] * h * g + c[j, k] * f * g)
		}
	}
	d = maximo / ds_grid_get_max(grid, 0, 0, xsize, ysize)
	if integer{
		for(a = 0; a < xsize; a++)
		    for(b = 0; b < ysize; b++){
				ds_grid_multiply(grid, a, b, d)
				ds_grid_set(grid, a, b, min(floor(grid[# a, b]), maximo - 1))
			}
	}
	else
		for(a = 0; a < xsize; a++)
		    for(b = 0; b < ysize; b++)
		        ds_grid_multiply(grid, a, b, d)
	return grid
}
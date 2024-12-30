function perlin(xsize, ysize, maximo, integer = false, s = 4){
	var a, b, c, grid;
	grid = ds_grid_create(xsize, ysize)
	for(a=0; a<=xsize/s+1; a++)
	    for(b=0; b<=ysize/s+1; b++)
	        c[a, b] = random(1)
	for(a=0; a<xsize; a++)
	    for(b=0; b<ysize; b++){
	        ds_grid_set(grid, a, b, c[floor(a/s), floor(b/s)]*(s-(a mod s))*(s-(b mod s)) +
	                                c[floor(a/s)+1, floor(b/s)]*(a mod s)*(s-(b mod s)) +
	                                c[floor(a/s), floor(b/s)+1]*(s-(a mod s))*(b mod s) +
	                                c[floor(a/s)+1, floor(b/s)+1]*(a mod s)*(b mod s))}
	c = maximo / ds_grid_get_max(grid, 0, 0, ds_grid_width(grid), ds_grid_height(grid))
	for(a=0; a<xsize; a++)
	    for(b=0; b<ysize; b++)
	        ds_grid_multiply(grid, a, b, c)
	if integer
		for(a=0; a<xsize; a++)
		    for(b=0; b<ysize; b++){
				if grid[# a, b] = maximo
					ds_grid_set(grid, a, b, maximo - 1)
				else
					ds_grid_set(grid, a, b, floor(grid[# a, b]))
			}
	return grid
}
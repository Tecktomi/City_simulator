function set_calle(x, y, crear){
	with control{
		var a = 0
		array_set(calle[x], y, crear)
		array_set(chunk_update[floor(x / 16)], floor(y / 16), true)
		world_update = true
		if crear{
			if x > 0 and calle[x - 1, y]{
				a += 2
				array_set(calle_sprite[x - 1], y, calle_sprite[x - 1, y] + 8)
				array_set(chunk_update[floor((x - 1) / 16)], floor(y / 16), true)
			}
			if y > 0 and calle[x, y - 1]{
				a += 1
				array_set(calle_sprite[x], y - 1, calle_sprite[x, y - 1] + 4)
				array_set(chunk_update[floor(x / 16)], floor((y - 1) / 16), true)
			}
			if x < xsize - 1 and calle[x + 1, y]{
				a += 8
				array_set(calle_sprite[x + 1], y, calle_sprite[x + 1, y] + 2)
				array_set(chunk_update[floor((x + 1) / 16)], floor(y / 16), true)
			}
			if y < ysize - 1 and calle[x, y + 1]{
				a += 4
				array_set(calle_sprite[x], y + 1, calle_sprite[x, y + 1] + 1)
				array_set(chunk_update[floor(x / 16)], floor((y + 1) / 16), true)
			}
			array_set(calle_sprite[x], y, a)
			var stack_calles = ds_stack_create()
			ds_stack_push(stack_calles, {a : x, b : y})
			while ds_stack_size(stack_calles){
				var temp_calle = ds_stack_pop(stack_calles), b = temp_calle.b
				a = temp_calle.a
			}
			ds_stack_destroy(stack_calles)
		}
		else{
			if x > 0 and calle[x - 1, y]{
				array_set(calle_sprite[x - 1], y, calle_sprite[x - 1, y] - 8)
				array_set(chunk_update[floor((x - 1) / 16)], floor(y / 16), true)
			}
			if y > 0 and calle[x, y - 1]{
				array_set(calle_sprite[x], y - 1, calle_sprite[x, y - 1] - 4)
				array_set(chunk_update[floor(x / 16)], floor((y - 1) / 16), true)
			}
			if x < xsize - 1 and calle[x + 1, y]{
				array_set(calle_sprite[x + 1], y, calle_sprite[x + 1, y] - 2)
				array_set(chunk_update[floor((x + 1) / 16)], floor(y / 16), true)
			}
			if y < ysize - 1 and calle[x, y + 1]{
				array_set(calle_sprite[x], y + 1, calle_sprite[x, y + 1] - 1)
				array_set(chunk_update[floor(x / 16)], floor((y + 1) / 16), true)
			}
			array_set(calle_sprite[x], y, 0)
		}
	}
}
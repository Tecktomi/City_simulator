function def_mejora(nombre, descripcion = "", anno = 0, precio = 0, recurso_id = [0], recurso_num = [0], bool_agua = false, agua = 0, bool_energia = false, energia = 0, efecto = function(edificio = control.null_edificio){}){
	with control{
		var mejora = {
			nombre : string(nombre),
			descripcion : descripcion,
			anno : anno,
			precio : precio,
			recurso_id : recurso_id,
			recurso_num : recurso_num,
			bool_agua : bool_agua,
			agua : agua,
			bool_energia : bool_energia,
			energia : energia,
			efecto : efecto
		}
		array_push(mejoras, mejora)
		return mejora
	}
}
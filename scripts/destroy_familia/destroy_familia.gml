function destroy_familia(familia = control.null_familia, muerte = true){
	with control{
		cambiar_casa(familia, homeless)
		array_remove(homeless.familias, familia, "eliminar familias de homeless")
		if muerte and familia.riqueza > 0{
			dinero += familia.riqueza
			mes_herencia[current_mes] += familia.riqueza
		}
		array_remove(familias, familia, "eliminar familia")
	}
}
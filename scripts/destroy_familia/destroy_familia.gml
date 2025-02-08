function destroy_familia(familia = control.null_familia, muerte = true){
	with control{
		array_remove(familia.casa.familias, familia)
		if muerte and familia.riqueza > 0{
			dinero += familia.riqueza
			mes_herencia[mes(dia)] += familia.riqueza
		}
		array_remove(familias, familia)
	}
}
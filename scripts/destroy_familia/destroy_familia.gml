function destroy_familia(familia = control.null_familia, muerte = true){
	array_remove(familia.casa.familias, familia)
	if muerte and familia.riqueza > 0{
		control.dinero += familia.riqueza
		control.mes_herencia[mes(control.dia)] += familia.riqueza
	}
	array_remove(control.familias, familia)
}
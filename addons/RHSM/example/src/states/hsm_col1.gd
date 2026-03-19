extends HSMNode


func enter_state(_act : Node, _ctx : HSMContext) -> void:
	print("Entered Col 1")
func exit_state(_act : Node, _ctx : HSMContext) -> void:
	print("Exited Col 1")

extends HSMNode


var _tween : Tween

func enter_state(act : Node, _ctx : HSMContext) -> void:
	print("Entered MakeTransparent")
	if _tween:
		_tween.kill()
	
	_tween = create_tween()
	_tween.tween_property(
		act as HBoxContainer, "modulate:a", 0.3, 0.5
	)
func exit_state(act : Node, _ctx : HSMContext) -> void:
	print("Exited MakeTransparent")
	if _tween:
		_tween.kill()
	
	_tween = create_tween()
	_tween.tween_property(
		act as HBoxContainer, "modulate:a", 1.0, 0.5
	)

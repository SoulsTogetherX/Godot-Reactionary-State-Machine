extends RHSMNode


@export var col_1_state : RHSMNode
@export var col_2_state : RHSMNode


var _tween : Tween


func enter_state(act : Node, _ctx : RHSMContext) -> void:
	print("Entered MakeTransparent")
	if _tween:
		_tween.kill()
	
	_tween = create_tween()
	_tween.tween_property(
		act as HBoxContainer, "modulate:a", 0.3, 0.5
	)
func exit_state(act : Node, _ctx : RHSMContext) -> void:
	print("Exited MakeTransparent")
	if _tween:
		_tween.kill()
	
	_tween = create_tween()
	_tween.tween_property(
		act as HBoxContainer, "modulate:a", 1.0, 0.5
	)


func passthrough_state(act : Node, ctx : RHSMContext) -> RHSMNode:
	if ctx.get_value(&"column") == 1:
		return col_1_state
	return col_2_state
	

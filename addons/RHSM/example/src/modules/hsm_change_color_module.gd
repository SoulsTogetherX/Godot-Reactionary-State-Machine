extends RHSMModule

@export var color : Color
var _origin_color : Color


func enter_module(act : Node, ctx : RHSMContext) -> void:
	print("Entered Color Change Module")
	_origin_color = act.modulate
	act.modulate = Color(color, act.modulate.a)
func exit_module(act : Node, _ctx : RHSMContext) -> void:
	print("Exited Color Change Module")
	act.modulate = Color(_origin_color, act.modulate.a)

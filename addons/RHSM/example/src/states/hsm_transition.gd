extends RHSMNode

@export var col_3_state : RHSMNode
@export var fade_transparent : RHSMNode



func value_changed(value_name : StringName, val : Variant) -> void:
	match value_name:
		&"column":
			if val == 3:
				change_state(col_3_state)
				return
			change_state(fade_transparent)

func _get_process_requirements() -> PackedInt32Array:
	return [
		PROCESS_REQUIREMENTS.VALUE_CHANGED
	]


func enter_state(_act : Node, _ctx : RHSMContext) -> void:
	print("Entered Transition")
func exit_state(_act : Node, _ctx : RHSMContext) -> void:
	print("Exited Transition")

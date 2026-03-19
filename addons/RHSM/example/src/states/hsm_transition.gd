extends HSMNode

@export var col_1_state : HSMNode
@export var col_2_state : HSMNode
@export var col_3_state : HSMNode



func value_changed(value_name : StringName, val : Variant) -> void:
	match value_name:
		&"column":
			match val as int:
				1:
					change_state(col_1_state)
				2:
					change_state(col_2_state)
				3:
					change_state(col_3_state)

func _get_process_requirements() -> PackedInt32Array:
	return [
		PROCESS_REQUIREMENTS.VALUE_CHANGED
	]


func enter_state(_act : Node, _ctx : HSMContext) -> void:
	print("Entered Transition")
func exit_state(_act : Node, _ctx : HSMContext) -> void:
	print("Exited Transition")

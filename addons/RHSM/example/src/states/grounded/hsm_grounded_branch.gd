extends RHSMNode

#region External Variables
@export var jump_state : RHSMNode

@export var running_state : RHSMNode
@export var stationary_state : RHSMNode
#endregion



#region Public Methods (State Change)
func passthrough_state(act : Node, ctx : RHSMContext) -> RHSMNode:
	if Input.get_axis("ui_left", "ui_right") != 0:
		ctx.set_action("is_running", true)
		return running_state
	return stationary_state
#endregion


#region Process Methods
func process_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_up"):
		change_state(jump_state)
		return
	
	var ctx := get_context()
	if Input.get_axis("ui_left", "ui_right") != 0:
		if ctx.get_action("is_running"):
			return
		ctx.set_action("is_running", true)
		change_state(running_state)
	else:
		if !ctx.get_action("is_running"):
			return
		ctx.set_action("is_running", false)
		change_state(stationary_state)
#endregion


#region Private Virtual Methods
func _get_process_requirements() -> PackedInt32Array:
	return [PROCESS_REQUIREMENTS.PROCESS_INPUT]
#endregion

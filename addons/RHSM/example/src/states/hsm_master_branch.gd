extends RHSMNode

#region External Variables
@export var airborn_state : RHSMNode
@export var grounded_state : RHSMNode
#endregion


#region Private Variables
var _is_grounded : bool = false
#endregion



#region Public Methods (State Change)
func passthrough_state(act : Node, ctx : RHSMContext) -> RHSMNode:
	var character : CharacterBody2D = act
	if character.is_on_floor():
		ctx.set_action(&"is_grounded", true)
		return grounded_state
	return airborn_state
#endregion


#region Process Methods
func process_physics(delta : float) -> void:
	var ctx := get_context()
	if (get_actor() as CharacterBody2D).is_on_floor():
		if ctx.get_action(&"is_grounded"):
			return
		ctx.set_action(&"is_grounded", true)
		change_state(grounded_state)
		return
	else:
		if !ctx.get_action(&"is_grounded"):
			return
		ctx.set_action(&"is_grounded", false)
		change_state(airborn_state)
		return
#endregion


#region Private Virtual Methods
func _get_process_requirements() -> PackedInt32Array:
	return [PROCESS_REQUIREMENTS.PROCESS_PHYSICS]
#endregion

extends RHSMNode

#region Constants
const JUMP_CONSTANT := 1000
const JUMP_CUTTOFF := 0.2
#endregion


#region External Variables
@export var falling_state : RHSMNode
#endregion



#region Public Methods (State Change)
func enter_state(act : Node, ctx : RHSMContext) -> void:
	ctx.set_action(&"is_grounded", false)
	(act as CharacterBody2D).velocity.y = -JUMP_CONSTANT
func exit_state(act : Node, _ctx : RHSMContext) -> void:
	var chara := (act as CharacterBody2D)
	
	if chara.velocity.y > 0:
		chara.velocity.y *= JUMP_CUTTOFF
#endregion



#region Process Methods
func process_input(event: InputEvent) -> void:
	if event.is_action_released("ui_up"):
		change_state(falling_state)
#endregion


#region Private Virtual Methods
func _get_process_requirements() -> PackedInt32Array:
	return [PROCESS_REQUIREMENTS.PROCESS_INPUT]
#endregion

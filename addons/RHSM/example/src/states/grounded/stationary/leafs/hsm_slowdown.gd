extends RHSMNode


#region Constants
const SLOWDOWN_FACTOR := 0.1
#endregion


#region External Variables
@export var idle_state : RHSMNode
#endregion



#region Public Methods (State Change)
func process_physics(_delta : float) -> void:
	var char := (get_actor() as CharacterBody2D)
	
	char.velocity.x *= SLOWDOWN_FACTOR
	if is_zero_approx(char.velocity.x):
		change_state(idle_state)
#endregion


#region Private Virtual Methods
func _get_process_requirements() -> PackedInt32Array:
	return [PROCESS_REQUIREMENTS.PROCESS_PHYSICS]
#endregion

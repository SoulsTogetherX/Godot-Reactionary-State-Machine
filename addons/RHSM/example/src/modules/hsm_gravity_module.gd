extends RHSMModule

#region Constants
const GRAVITY_CONSTANT := 1400
#endregion



#region Process Methods
func process_physics(delta : float) -> void:
	(get_actor() as CharacterBody2D).velocity.y += GRAVITY_CONSTANT * delta
#endregion


#region Private Virtual Methods
func _get_process_requirements() -> PackedInt32Array:
	return [PROCESS_REQUIREMENTS.PROCESS_PHYSICS]
#endregion

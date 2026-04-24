extends RHSMModule


#region Process Methods
func process_physics(delta: float) -> void:
	(get_actor() as CharacterBody2D).move_and_slide()
#endregion


#region Private Virtual Methods
func _get_process_requirements() -> PackedInt32Array:
	return [PROCESS_REQUIREMENTS.PROCESS_PHYSICS]
#endregion

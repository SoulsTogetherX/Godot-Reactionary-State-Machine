extends RHSMModule


#region Constants
const RUNNING_SPEED := 3000
const MAX_RUNNING_SPEED := 1500
#endregion



#region Process Methods
func process_physics(delta : float) -> void:
	var char := (get_actor() as CharacterBody2D)
	
	char.velocity.x = clampf(
		char.velocity.x + (
			Input.get_axis("ui_left", "ui_right") * RUNNING_SPEED * delta
		),
		-MAX_RUNNING_SPEED, MAX_RUNNING_SPEED
	)
#endregion


#region Private Virtual Methods
func _get_process_requirements() -> PackedInt32Array:
	return [PROCESS_REQUIREMENTS.PROCESS_PHYSICS]
#endregion

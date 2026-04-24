extends RHSMNode

#region External Variables
@export var slowdown_state : RHSMNode
@export var idle_state : RHSMNode
#endregion



#region Public Methods (State Change)
func passthrough_state(act : Node, ctx : RHSMContext) -> RHSMNode:
	if is_zero_approx((act as CharacterBody2D).velocity.x):
		return idle_state
	return slowdown_state
#endregion

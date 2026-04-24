extends RHSMNode

#region External Variables
@export var falling_state : RHSMNode
@export var jumping_state : RHSMNode
#endregion



#region Public Methods (State Change)
func passthrough_state(act : Node, ctx : RHSMContext) -> RHSMNode:
	return falling_state
#endregion

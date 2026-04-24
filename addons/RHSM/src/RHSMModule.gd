class_name RHSMModule extends RHSMBranch
## An extra node that will run when it's parent [RHSMNode] is run.
## [br][br]
## Used for repeatable logic to be shared in multiple states.


#region Module Change
## A virtual method that runs the moment AFTER their parent [RHSMNode] node
## is entered via the relevant [RHSMMaster].
## [br][br]
## [param act] is the actor and [ctx] is the context object, both
## defined in [RHSMMaster].
## [br][br]
## [b]NOTE[/b]: In the state machine hierarchy, The topmost [RHSMModule]
## nodes in the tree will be processed first.
func enter_module(act : Node, ctx : RHSMContext) -> void:
	pass
## A virtual method that runs BEFORE the moment their parent [RHSMNode] node
## is exited via the relevant [RHSMMaster].
## [br][br]
## [param act] is the actor and [ctx] is the context object, both
## defined in [RHSMMaster].
## [br][br]
## [b]NOTE[/b]: In the state machine hierarchy, The topmost [RHSMModule]
## nodes in the tree will be processed first.
func exit_module(act : Node, ctx : RHSMContext) -> void:
	pass
#endregion

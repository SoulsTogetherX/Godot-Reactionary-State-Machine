@abstract
class_name RHSMBranch extends RHSMBase
## The basic node for all state and module logic. Must be a child to a
## [RHSMBase] node to work.


#region Private Signals
## A signal emitted after this branch is entered
signal entered
## A signal emitted after this branch is exited
signal exited
#endregion


#region Private Variables
var _context : RHSMContext
var _actor : Node
#endregion



#region Virtual Private Methods
## Implement to return a list of allowed [member RHSMBase.PROCESS_REQUIREMENTS]
## for this nodes.
func _get_process_requirements() -> PackedInt32Array:
	return []
#endregion


#region Public Process Methods
## A virtual method that runs once per process frame, if requested.
## This method is equivalent to [method MainLoop._process], but may be activated
## or deactivated when state changes.
## [br][br]
## [b]NOTE[/b]: In the state machine hierarchy, [RHSMBranch] nodes higher up the
## tree will be processed first.
## [br][br]
## Also see [method _get_process_requirements].
func process_frame(delta : float) -> void:
	pass
## A virtual method that runs once per physics frame, if requested.
## This method is equivalent to [method MainLoop._physics_process], but may
## be activated or deactivated when state changes.
## [br][br]
## [b]NOTE[/b]: In the state machine hierarchy, [RHSMBranch] nodes higher up
## the tree will be processed first.
## [br][br]
## Also see [method _get_process_requirements].
func process_physics(delta : float) -> void:
	pass
## A virtual method that runs once per unhandled input, if requested.
## This method is equivalent to [method MainLoop._unhandled_input], but may
## be activated or deactivated when state changes.
## [br][br]
## [b]NOTE[/b]: In the state machine hierarchy, [RHSMBranch] nodes higher up
## the tree will be processed first.
## [br][br]
## Also see [method _get_process_requirements].
func process_input(event: InputEvent) -> void:
	pass
#endregion


#region Public Context Methods
## A virtual method that runs once when an action, from the connected
## [RHSMContext], is toggled on from an off state.
## [br][br]
## [b]NOTE[/b]: In the state machine hierarchy, [RHSMBranch] nodes higher up
## the tree will be processed first.
## [br][br]
## Also see [method _get_process_requirements] and
## [signal RHSMContext.action_started]
func action_started(action_name : StringName) -> void:
	pass
## A virtual method that runs once when an action, from the connected
## [RHSMContext], is toggled off from an on state.
## [br][br]
## [b]NOTE[/b]: In the state machine hierarchy, [RHSMBranch] nodes higher up
## the tree will be processed first.
## [br][br]
## Also see [method _get_process_requirements] and
## [signal RHSMContext.action_finished]
func action_finished(action_name : StringName) -> void:
	pass

## A virtual method that runs once when an action, from the connected
## [RHSMContext], changed toggle.
## [br][br]
## [b]NOTE[/b]: In the state machine hierarchy, [RHSMBranch] nodes higher up
## the tree will be processed first.
## [br][br]
## Also see [method _get_process_requirements] and
## [signal RHSMContext.action_changed]
func action_changed(action_name : StringName, val : bool) -> void:
	pass
## A virtual method that runs once when a value, from the connected
## [RHSMContext], has it's value changed.
## [br][br]
## [b]NOTE[/b]: In the state machine hierarchy, [RHSMBranch] nodes higher up
## the tree will be processed first.
## [br][br]
## Also see [method _get_process_requirements] and
## [signal RHSMContext.value_changed]
func value_changed(value_name : StringName, val : Variant) -> void:
	pass
#endregion


#region Public Methods (Access)
## Returns the current context of the relevant [RHSMMaster].
## [br][br]
## [b]NOTE[/b]: Attempting to call this when [method is_running] is
## [code]false[/code] will result in undefined behavior.
func get_context() -> RHSMContext:
	return _context
## Returns the current actor of the relevant [RHSMMaster].
## [br][br]
## [b]NOTE[/b]: Attempting to call this when [method is_running] is
## [code]false[/code] will result in undefined behavior.
func get_actor() -> Node:
	return _actor
#endregion

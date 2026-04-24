class_name RHSMNode extends RHSMBranch
## The basic node for all state logic. Must be a child to a [RHSMBase]
## node to work.


#region Private Variables
var _running : bool

var _modules : Array[RHSMModule]
#endregion



#region Virtual Methods
func _init() -> void:
	_settup_private_signals()
#endregion


#region Private Methods (Module)
func _register_modules() -> void:
	for module : Node in get_children():
		if module is RHSMModule:
			module._parent = self
			_modules.append(module)
func _update_modules_info() -> void:
	for module : Node in get_children():
		if module is RHSMModule:
			module._actor = _actor
			module._context = _context

func _enter_modules() -> void:
	for module : RHSMModule in _modules:
		module._actor = _actor
		module._context = _context
		
		module.enter_module(_actor, _context)
		module.entered.emit()
func _exit_modules() -> void:
	for module : RHSMModule in _modules:
		module.exit_module(_actor, _context)
		module.exited.emit()

func _get_modules() -> Array[RHSMModule]:
	return _modules
#endregion



#region Private Methods (Helper)
func _settup_private_signals() -> void:
	if !has_signal(_REQUEST_STATE_CHANGE_SIGNAL_NAME):
		add_user_signal(_REQUEST_STATE_CHANGE_SIGNAL_NAME)
#endregion


#region Public State Change Methods
## A virtual method that runs the moment the relevant [RHSMMaster] changes
## the current state to this or a descendant state. This method will not be
## recalled if the previous state was also a descendant of this node.
## [br][br]
## [param act] is the actor and [ctx] is the context object, both
## defined in [RHSMMaster].
## [br][br]
## [b]NOTE[/b]: In the state machine hierarchy, [RHSMNode] nodes higher up
## the tree will be processed first.
## [br][br]
## Also see [method change_state].
func enter_state(act : Node, ctx : RHSMContext) -> void:
	pass
## A virtual method that runs the moment the relevant [RHSMMaster] changes
## the current state to another that isn't this state or a descendant of
## this node.
## [br][br]
## [param act] is the actor and [ctx] is the context object, both
## defined in [RHSMMaster].
## [br][br]
## [b]NOTE[/b]: In the state machine hierarchy, [RHSMNode] nodes lower
## down the tree will be processed first.
## [br][br]
## Also see [method change_state].
func exit_state(act : Node, ctx : RHSMContext) -> void:
	pass

## A virtual method that is run before the relevant [RHSMMaster]
## changes to this state. If returned [code]false[/code], then
## the state transition is cancled.
## [br][br]
## [b]NOTE[/b]: This method is called only after [method passthrough_state]
## has found an exit state.
## [br][br]
## Also see [method change_state] and [method passthrough_state].
func safe_guard(act : Node, ctx : RHSMContext) -> bool:
	return true
## A virtual method that runs before [method safe_guard] is called
## to the state [RHSMMaster] is attempted to change to.
## [br]
## If [code]null[/code] is returned, then the relevant [RHSMMaster] will change
## to this state as expected. If another [RHSMNode] is returned, then
## [RHSMMaster] will attempt to change to the returned state instead.
## [br][br]
## [param act] is the actor and [ctx] is the context object, both
## defined in [RHSMMaster].
## [br][br]
## [b]NOTE[/b]: If this method eventually returns to this state, and still
## does not return [code]null[/code] afterwards, then an infinite loop is
## assumed and the state change is cancled.
## [br][br]
## Also see [method change_state] and [method safe_guard].
func passthrough_state(act : Node, ctx : RHSMContext) -> RHSMNode:
	return null

## A public method that requests the relevant [RHSMMaster] to change 
## [param state].
## [br][br]
## [b]NOTE[/b]: [param state]'s [method passthrough_state] will be called
## first. If that method returns another [RHSMNode], then [RHSMMaster] to
## change to that state instead.
func change_state(state : RHSMNode) -> void:
	emit_signal(
		_REQUEST_STATE_CHANGE_SIGNAL_NAME, state
	)
#endregion


#region Public Methods (Access)
## Returns if this state is currently running within the relevant [RHSMMaster].
func is_running() -> bool:
	return _running
#endregion

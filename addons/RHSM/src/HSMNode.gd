@abstract
class_name HSMNode extends HSMBranch
## The basic node for all state logic. Must be a child to a [HSMBase]
## node to work.


#region Private Signals
signal entered
signal exited
#endregion


#region Private Signals
var _request_change := Signal()
#endregion


#region Private Variables
var _running : bool

var _modules : Array[HSMModule]
#endregion



#region Private Methods (Module)
func _register_modules() -> void:
	for module : Node in get_children():
		if module is HSMModule:
			module._parent = self
			_modules.append(module)
func _update_modules_info() -> void:
	for module : Node in get_children():
		if module is HSMModule:
			module._actor = _actor
			module._context = _context

func _enter_modules() -> void:
	for module : HSMModule in _modules:
		module._actor = _actor
		module._context = _context
		module.enter_module(_actor, _context)
func _exit_modules() -> void:
	for module : HSMModule in _modules:
		module.exit_module(_actor, _context)

func _get_modules() -> Array[HSMModule]:
	return _modules
#endregion


#region Public State Change Methods
## A virtual method that runs the moment the relevant [HSMMaster] changes
## the current state to this or a descendant state. This method will not be
## recalled if the previous state was also a descendant of this node.
## [br][br]
## [param act] is the actor and [ctx] is the context object, both
## defined in [HSMMaster].
## [br][br]
## [b]NOTE[/b]: In the state machine hierarchy, [HSMNode] nodes higher up
## the tree will be processed first.
## [br][br]
## Also see [method change_state].
func enter_state(act : Node, ctx : HSMContext) -> void:
	pass
## A virtual method that runs the moment the relevant [HSMMaster] changes
## the current state to another that isn't this state or a descendant of
## this node.
## [br][br]
## [param act] is the actor and [ctx] is the context object, both
## defined in [HSMMaster].
## [br][br]
## [b]NOTE[/b]: In the state machine hierarchy, [HSMNode] nodes lower
## down the tree will be processed first.
## [br][br]
## Also see [method change_state].
func exit_state(act : Node, ctx : HSMContext) -> void:
	pass
## A virtual method that runs before [method enter_state] is called
## to the state [HSMMaster] is attempted to change to.
## [br]
## If [code]null[/code] is returned, then the relevant [HSMMaster] will change
## to this state as expected. If another [HSMNode] is returned, then
## [HSMMaster] will attempt to change to the returned state instead.
## [br][br]
## [param act] is the actor and [ctx] is the context object, both
## defined in [HSMMaster].
## [br][br]
## [b]NOTE[/b]: If this method eventually returns to this state, and still
## does not return [code]null[/code] afterwards, then an infinite loop is
## assumed and the state change is cancled.
## [br][br]
## Also see [method change_state].
func passthrough_state(act : Node, ctx : HSMContext) -> HSMNode:
	return null

## A public method that requests the relevant [HSMMaster] to change 
## [param state].
## [br][br]
## [b]NOTE[/b]: [param state]'s [method passthrough_state] will be called
## first. If that method returns another [HSMNode], then [HSMMaster] to
## change to that state instead.
func change_state(state : HSMNode) -> void:
	_request_change.emit(state)
#endregion


#region Public Methods (Access)
## Returns if this state is currently running within the relevant [HSMMaster].
func is_running() -> bool:
	return _running
#endregion

class_name RHSMMaster extends RHSMBase
## The node that uses [HSMNode] and [HSMModule] children in order to
## create a state machine hierarchy.
## [br][br]
## [b]Note[/b]: Editing a State Machine's structure after [Node._ready]
## will result in undefined behavior. Use [method initializes_machine]
## to ensure everything is working fine after tree editing.


#region External Variables
@export_group("Nodes")
## The starting state this state machine will start from.
@export var starting_state : RHSMNode
## The context object that will be provided to all states.
@export var context : RHSMContext:
	set = _set_context
## The actor object that will be provided to all states.
@export var actor : Node:
	set = _set_actor

@export_group("Settings")
## If [code]true[/code], calling [method change_state] will do nothing
## and all attached states will have their processing halted.
@export var disabled : bool:
	set(val):
		if val == disabled:
			return
		disabled = val
		_update_processing()
		_update_contexting()
#endregion


#region Private Variables
# Highest Node in the tree hierarchy
var _top : RHSMBase
# Lowest Node in the tree hierarchy
var _bottom : RHSMBase

var _process_queue : Array[RHSMBranch]
var _physic_queue : Array[RHSMBranch]
var _input_queue : Array[RHSMBranch]

var _action_started_queue : Array[RHSMBranch]
var _action_finished_queue : Array[RHSMBranch]

var _action_changed_queue : Array[RHSMBranch]
var _value_changed_queue : Array[RHSMBranch]

var _swapped_hault : bool = false
#endregion



#region Virtual Methods
func _ready() -> void:
	initializes_machine(starting_state)
#endregion


#region Action Methods
func _process(delta: float) -> void:
	for state : RHSMBranch in _process_queue:
		state.process_frame(delta)
func _physics_process(delta: float) -> void:
	for state : RHSMBranch in _physic_queue:
		state.process_physics(delta)
func _unhandled_input(event: InputEvent) -> void:
	for state : RHSMBranch in _input_queue:
		state.process_input(event)

func _action_started(action_name : StringName) -> void:
	for state : RHSMBranch in _action_started_queue:
		state.action_started(action_name)
func _action_finished(action_name : StringName) -> void:
	for state : RHSMBranch in _action_finished_queue:
		state.action_finished(action_name)

func _action_changed(action_name : StringName, val : bool) -> void:
	for state : RHSMBranch in _action_changed_queue:
		state.action_changed(action_name, val)
func _value_changed(value_name : StringName, val : Variant) -> void:
	for state : RHSMBranch in _value_changed_queue:
		state.value_changed(value_name, val)
#endregion


#region Private Methods (Helper)
func _set_context(val : RHSMContext) -> void:
	if val == context:
		return
	if val == null:
		val = RHSMContext.new()
	if context != null:
		_set_action_started(false)
		_set_action_finished(false)
		_set_value_changed(false)
	
	context = val
	_update_contexting()
	if is_node_ready():
		_propagate_info(self)
func _set_actor(val : Node) -> void:
	if val == actor:
		return
	actor = val
	if is_node_ready():
		_propagate_info(self)


func _set_action_started(toggle : bool) -> void:
	if toggle:
		if !context.action_started.is_connected(_action_started):
			context.action_started.connect(_action_started)
		return
	if context.action_started.is_connected(_action_started):
		context.action_started.disconnect(_action_started)
func _set_action_finished(toggle : bool) -> void:
	if toggle:
		if !context.action_finished.is_connected(_action_finished):
			context.action_finished.connect(_action_finished)
		return
	if context.action_finished.is_connected(_action_finished):
		context.action_finished.disconnect(_action_finished)

func _set_action_changed(toggle : bool) -> void:
	if toggle:
		if !context.action_changed.is_connected(_action_changed):
			context.action_changed.connect(_action_changed)
		return
	if context.action_changed.is_connected(_action_changed):
		context.action_changed.disconnect(_action_changed)
func _set_value_changed(toggle : bool) -> void:
	if toggle:
		if !context.value_changed.is_connected(_value_changed):
			context.value_changed.connect(_value_changed)
		return
	if context.value_changed.is_connected(_value_changed):
		context.value_changed.disconnect(_value_changed)

func _set_request_change(state : RHSMNode, toggle : bool) -> void:
	if toggle:
		if !state._request_change.is_connected(change_state):
			state._request_change.connect(change_state, CONNECT_DEFERRED)
		return
	if state._request_change.is_connected(change_state):
		state._request_change.disconnect(change_state)


func _update_processing() -> void:
	set_process(!disabled && !_process_queue.is_empty())
	set_physics_process(!disabled && !_physic_queue.is_empty())
	set_process_unhandled_input(!disabled && !_input_queue.is_empty())
func _update_contexting() -> void:
	_set_action_started(!disabled && !_action_started_queue.is_empty())
	_set_action_finished(!disabled && !_action_finished_queue.is_empty())
	
	_set_action_changed(!disabled && !_action_changed_queue.is_empty())
	_set_value_changed(!disabled && !_value_changed_queue.is_empty())
#endregion


#region Private Methods (Clear Queue)
func _clear_queues() -> void:
	_process_queue.clear()
	_physic_queue.clear()
	_input_queue.clear()
	
	_action_started_queue.clear()
	_action_finished_queue.clear()
	
	_action_changed_queue.clear()
	_value_changed_queue.clear()
func _add_to_queue(state : RHSMBranch) -> void:
	var requirements := state._get_process_requirements()
	var handled : Dictionary
	
	for requirement : PROCESS_REQUIREMENTS in requirements:
		if handled.has(requirement):
			return
		handled.set(requirement, null)
		
		match requirement:
			PROCESS_REQUIREMENTS.PROCESS_FRAME:
				_process_queue.append(state)
			PROCESS_REQUIREMENTS.PROCESS_PHYSICS:
				_physic_queue.append(state)
			PROCESS_REQUIREMENTS.PROCESS_INPUT:
				_input_queue.append(state)
			
			PROCESS_REQUIREMENTS.ACTION_STARTED:
				_action_started_queue.append(state)
			PROCESS_REQUIREMENTS.ACTION_FINISHED:
				_action_finished_queue.append(state)
			
			PROCESS_REQUIREMENTS.ACTION_CHANGED:
				_action_changed_queue.append(state)
			PROCESS_REQUIREMENTS.VALUE_CHANGED:
				_value_changed_queue.append(state)
	
	if state is RHSMNode:
		for module : RHSMModule in state._get_modules():
			_add_to_queue(module)
#endregion


#region Private Methods (Propagates)
func _propagate_parent(bottom : RHSMBase) -> void:
	for node : Node in bottom.get_children():
		if node is RHSMNode:
			node._parent = bottom
			node._register_modules()
			_propagate_parent(node)
func _propagate_info(bottom : RHSMBase) -> void:
	for node : Node in bottom.get_children():
		if node is RHSMNode:
			node._context = context
			node._actor = actor
			node._update_modules_info()
			_propagate_info(node)

func _propagate_child(new_state : RHSMBase) -> void:
	var parent := new_state._parent
	while parent:
		if parent._child != new_state:
			_top = new_state._parent
		
		parent._child = new_state
		new_state = parent
		parent = new_state._parent

func _propagate_enter_state() -> void:
	if _top == null:
		return
		
	var top : RHSMNode = self._child
	# Adds needed to queue again
	while top && top != _top._child:
		_add_to_queue(top)
		top = top._child
	
	# Only acts on the changed states
	while top:
		top._running = true
		_add_to_queue(top)
		
		_set_request_change(top, true)
		
		top.enter_state(actor, context)
		top._enter_modules()
		top.entered.emit()
		
		top = top._child
func _propagate_exit_state() -> void:
	var bottom : RHSMBase = _bottom
	while bottom:
		if bottom == _top:
			return
		
		bottom._exit_modules()
		bottom.exit_state(actor, context)
		bottom.exited.emit()
		_set_request_change(bottom, false)
		
		bottom._running = false
		bottom = bottom._parent
#endregion


#region Public Methods (Helper)
## Initializes the machine's entire structure and changes the current
## state to be [param inital_state]. Is useful if the structure of
## the machine is changed at runtime.
## [br][br]
## [b]NOTE[/b]: It is not recomended to use this method often, as it is
## performance intensive for large machines.
func initializes_machine(inital_state : RHSMNode) -> void:
	_top = self
	_bottom = self
	
	_propagate_parent(self)
	_propagate_info(self)
	change_state(inital_state)

## Requests the current state to be changed. Will not work if
## [member disabled] is set to [code]true[/code].
## [br][br]
## [b]NOTE[/b]: This method will first cycle through
## [method HSMNode.passthrough_state] before transitioning. If an
## infinite loop is detect, then this state chance is cancled.
func change_state(new_state : RHSMNode) -> bool:
	if disabled:
		return false
	
	# Goes through passthrough
	var check_state : RHSMNode = new_state
	while check_state:
		new_state = check_state
		check_state = check_state.passthrough_state(actor, context)
			
		# If passthrough gives the same state, stop.
		# Avoids infinite loop.
		if _bottom == new_state && check_state != null:
			push_error("Possible Infinite State Loop Found")
			return false
	if _bottom == new_state:
		return false
	
	if new_state == null:
		push_warning("Attempted to transition to a 'null' instead of a vaild RHSMNode.")
		_propagate_exit_state()
		_clear_queues()
		_update_processing()
		_update_contexting()
		return true
	if !new_state.safe_guard(actor, context):
		return false
	
	_propagate_child(new_state)
	
	_propagate_exit_state()
	_clear_queues()
	
	_bottom = new_state
	_propagate_enter_state()
	_action_finished_queue.reverse()
	
	_update_processing()
	_update_contexting()
	return true
#endregion

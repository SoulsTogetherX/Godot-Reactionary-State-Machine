class_name RHSMContext extends Node
## The node holds the context that is used and passed through [HSMMaster] nodes.
## [br][br]
## It is used to transfer information between states, state machines, and
## facilitate state changes.


#region Signals
## A signal that is emited when an action is toggled on when previously off.
## [br][br]
## [b]NOTE[/b]: Actions are considered off by default, so defining an action
## will also trigger this signal.
signal action_started(action_name : StringName)
## A signal that is emited when an action is toggled off when previously on.
signal action_finished(action_name : StringName)

## A signal that is emited when an action is toggle.
## [br][br]
## Also see: [signal action_started] and [signal action_finished].
signal action_changed(action_name : StringName, val : bool)
## A signal that is emited when a value is changed.
signal value_changed(value_name : StringName, val : Variant)
#endregion


#region Private Variables
var _actions : Array[Action]
var _actions_cache : Dictionary[StringName, int]

var _values : Array[Value]
var _values_cache : Dictionary[StringName, int]
#endregion


#region External Variables
## The initial values of a context object.
@export var starting_values : Dictionary
#endregion



#region Virtual Methods
func _ready() -> void:
	_register_starting_values()
#endregion


#region Private Methods (Helper)
func _register_starting_values() -> void:
	for value_name : StringName in starting_values:
		set_value(value_name, starting_values[value_name])

func _get_action_index(action_name : StringName) -> int:
	return _actions_cache.get(action_name, -1)
func _get_value_index(value_name : StringName) -> int:
	return _values_cache.get(value_name, -1)

func _force_action_signal(act : Action) -> void:
	if act.toggle:
		action_started.emit(act.action_name)
		return
	action_finished.emit(act.action_name)
#endregion


#region Public Methods (Action Cache)
## Sets an actions toggle value.
## [br][br]
## Also see: [signal action_started], [signal action_finished],
## and [signal action_changed].
func set_action(action_name : StringName, toggle : bool) -> void:
	var idx := _get_action_index(action_name)
	if idx == -1:
		var act := Action.new(
			action_started,
			action_finished,
			action_changed,
			action_name,
			toggle
		)
		
		_actions_cache[action_name] = _actions.size()
		_actions.push_back(act)
		return
	
	_actions.get(idx).toggle = toggle

## Sets a value within the context.
## [br][br]
## Also see: [signal value_changed].
func set_value(value_name : StringName, val : Variant) -> void:
	var idx := _get_value_index(value_name)
	if idx == -1:
		_values_cache[value_name] = _values.size()
		_values.push_back(Value.new(value_name, val))
		
		value_changed.emit(value_name, val)
		return
	
	if _values[idx].value != val:
		_values[idx].value = val
		value_changed.emit(value_name, val)
#endregion


#region Public Methods (Erase)
## Clears all actions and values from this context object.
## If [param inital_values] is [code]true[/code], then
## all values from [member starting_values] will be reinitialized
## as well.
func clear_caches(inital_values : bool = false) -> void:
	_actions.clear()
	_actions_cache.clear()
	
	_values.clear()
	_values_cache.clear()
	_register_starting_values()

## Removes an action from the cache.
## If [param toggle_off] is [code]true[/code], then the action will be toggled
## off before being erased.
func erase_action(action_name : StringName, toggle_off : bool = false) -> void:
	var idx := _get_action_index(action_name)
	if idx == -1:
		return
	if toggle_off:
		_actions.get(idx).toggle = false
	
	_actions[idx] = _actions.back()
	_actions.pop_back()
	_actions_cache[_actions[idx].action_name] = idx

## Removes an value from the cache.
func erase_value(value_name : StringName) -> void:
	var idx := _get_value_index(value_name)
	if idx == -1:
		return
	
	_values[idx] = _values.back()
	_values.pop_back()
	_values_cache[_values[idx].value_name] = idx
#endregion


#region Public Methods (Action Checks)
## Returns true if the action is toggled on. If the action does not exist,
## then [param default] is returned instead.
func is_action(action_name : StringName, default : bool = false) -> bool:
	var idx := _get_action_index(action_name)
	if idx == -1:
		return default
	return _actions[idx].toggle

## Returns the requested value. If the value does not exist, then
## [param default] is returned instead.
func get_value(value_name : StringName, default : Variant = null) -> Variant:
	var idx := _get_value_index(value_name)
	if idx == -1:
		return default
	return _values[idx].value

## Forces [signal action_started] and [signal action_finished] to be emitted
## for the action if it is toggled [code]true[/code] or [code]false[/code]
## respectfully.
func force_action_signal(action_name : StringName) -> void:
	var idx := _get_action_index(action_name)
	if idx == -1:
		return
	
	_force_action_signal(_actions[idx])
## Performs [method force_action_signal] for all cached actions.
func force_all_action_signals() -> void:
	for act : Action in _actions:
		_force_action_signal(act)
#endregion


#region Inner Classes
## An action class used by [HSMContext] nodes.
## [br][br]
## Useful for states, like in_air or jumping, and player controls.
class Action:
	## A signal that is emited when an action is toggled on when previously off.
	## [br][br]
	## [b]NOTE[/b]: Actions are considered off by default, so defining an action
	## will also trigger this signal.
	var action_started : Signal
	## A signal that is emited when an action is toggled off when previously on.
	var action_finished : Signal

	## A signal that is emited when an action is toggle.
	## [br][br]
	## Also see: [signal action_started] and [signal action_finished].
	var action_changed : Signal
	
	## The name of the action
	var action_name : StringName
	## The toggled state of the action
	var toggle : bool:
		set = set_toggle
	
	func _init(
		act_s : Signal, fin_s : Signal, chan_s : Signal,
		act_name : StringName, tog : bool
	) -> void:
		action_started = act_s
		action_finished = fin_s
		action_changed = chan_s
		action_name = act_name
		toggle = tog
	
	## Toggles the state of the action
	func set_toggle(val : bool) -> void:
		if val == toggle:
			return
		toggle = val
		
		if toggle:
			action_started.emit(action_name)
		else:
			action_finished.emit(action_name)
		action_changed.emit(action_name, toggle)

## A value holder class used by [HSMContext] nodes.
## [br][br]
## Useful for enum checks and memory transfer between states.
class Value:
	## The name of the value
	var value_name : StringName
	## The literal value of the value
	var value : Variant
	
	func _init(
		val_name : StringName, val : Variant
	) -> void:
		value_name = val_name
		value = val
#endregion

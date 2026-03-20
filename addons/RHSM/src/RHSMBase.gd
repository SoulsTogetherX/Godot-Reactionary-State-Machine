@abstract
class_name RHSMBase extends Node
## The Abstract Class for all Hierarchical State Machine nodes.


#region Enums
## An eneum used to determine what processing mode the [HSMMaster] should
## allow [HSMBranch] to use. This prevents unneeded method calling.
enum PROCESS_REQUIREMENTS {
	PROCESS_FRAME,
	PROCESS_PHYSICS,
	PROCESS_INPUT,
	ACTION_STARTED,
	ACTION_FINISHED,
	ACTION_CHANGED,
	VALUE_CHANGED
}
#endregion


#region Private Variables
var _parent : RHSMBase
var _child : RHSMBase
#endregion

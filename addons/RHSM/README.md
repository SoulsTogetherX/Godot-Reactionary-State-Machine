# Reactionary Hierarchical State Machine

Hello.

I've often found the need to use a performant state machine in my games, whether or a player controller or toggleable UI, but all the state machines on the market often felt limiting or too complex for my needs.

Here is an alternative I plan to use in my projects.

## Functionality

This state machine can be separated into three main components.

* HSMMaster
* HSMNode
* HSMModule
* HSMContext

### HSMMaster

HSMMaster is the root of any state machine. Within here all calculates are processed and where state changes occur.

### HSMNode

HSMNode nodes are the main node type that will hold any state functionality you want to be implemented. Physics frame, process frame, unhandled input, as well as cache changes are signaled within these nodes. You made handle these inputs as you wish when they are relevant.

Each HSMNode also act as group of child HSMNode nodes. Changing state to any HSMNode node will also propagate the functionality of all ancestor HSMNode nodes within the state machine. This allows complex groupings, as well as shared conditions. If multiple states can be exited the same way, creating a new state as their parent will work instead.

The system is designed to reduce code redundancy.

### HSMModule

To further reduce redundancy, HSMModule are essentially the leaf node of any state machine. If a HSMNode node is active, then all of it's children HSMModule nodes will also be active.

HSMModule has equivalent to HSMNode in implemented functionally. However, they cannot be the current state in a state machine, and they do not propagate functionality to their ancestors.

These nodes are best used for repeatable code expected for multiple states to possess. For example, code that changes the current animation upon entering a state.

### HSMContext

This node is a shared blackboard of information between states of the same or different state machines. It can either hold actions (bools) or values (Variants). Any connected state machine will receive signals when an action is turned on, off, toggled, and when values are changed. You are also able to access the context object at any time in your HSMNode and HSMModule nodes via the get_context() method.

Actions are best used for simple known states. For example, when a player is in the air or on the ground. Values are best used for misc information, or when an enum would be a better fit than a boolean.

These should be your primary method of state communication, as well as facilitating when to change states.

## Efficency Measures

Each HSMNode and HSMModule node possess the method _get_process_requirements(). Via overloading this, you can tell the state machine what methods this method need to be called at relevant times. This drastically reduces overhead of having multiple unneeded functions be called, for each state, per frame.

The enter and exit method of each HSMNode and HSMModule node are only called when required too. If the new state shares ancestors, those ancestors will not be exited and reentered.

## Known Issues

None

## Profile

If you like what I do, check out my [other stuff](https://ko-fi.com/soulstogether). Maybe buy me a coffee, if you want.

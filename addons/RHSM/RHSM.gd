@tool
extends EditorPlugin


func _enter_tree() -> void:
	## HSMContext
	add_custom_type(
		"RHSMContext", "Node",
		preload("uid://6hg6o4escfno"),
		preload("uid://eq0y83s6enxe")
	)
	
	## HSMMaster
	add_custom_type(
		"RHSMMaster", "Node",
		preload("uid://cn1lche2a867t"),
		preload("uid://byj78q2ccpxwd")
	)
	
	## HSMBranch
	add_custom_type(
		"RHSMBranch", "Node",
		preload("uid://yub3sptxiwct"),
		preload("uid://dwxxew7u0rj2y")
	)
	add_custom_type(
		"RHSMModule", "Node",
		preload("uid://te71xef3w38h"),
		preload("uid://dtcuuta3j78ay")
	)
	add_custom_type(
		"RHSMNode", "Node",
		preload("uid://dqceopkr2ry2y"),
		preload("uid://djekf463mguay")
	)


func _exit_tree() -> void:
	## HSMContext
	remove_custom_type("RHSMContext")
	
	## HSMMaster
	remove_custom_type("RHSMMaster")
	
	## HSMBranch
	remove_custom_type("RHSMBranch")
	remove_custom_type("RHSMModule")
	remove_custom_type("RHSMNode")

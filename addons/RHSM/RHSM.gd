@tool
extends EditorPlugin


func _enter_tree() -> void:
	## HSMContext
	add_custom_type(
		"HSMContext", "Node",
		preload("uid://6hg6o4escfno"),
		preload("uid://eq0y83s6enxe")
	)
	
	## HSMMaster
	add_custom_type(
		"HSMMaster", "Node",
		preload("uid://cn1lche2a867t"),
		preload("uid://byj78q2ccpxwd")
	)
	
	## HSMBranch
	add_custom_type(
		"HSMBranch", "Node",
		preload("uid://yub3sptxiwct"),
		preload("uid://dwxxew7u0rj2y")
	)
	add_custom_type(
		"HSMModule", "Node",
		preload("uid://te71xef3w38h"),
		preload("uid://dtcuuta3j78ay")
	)
	add_custom_type(
		"HSMNode", "Node",
		preload("uid://dqceopkr2ry2y"),
		preload("uid://djekf463mguay")
	)


func _exit_tree() -> void:
	## HSMContext
	remove_custom_type("HSMContext")
	
	## HSMMaster
	remove_custom_type("HSMMaster")
	
	## HSMBranch
	remove_custom_type("HSMBranch")
	remove_custom_type("HSMModule")
	remove_custom_type("HSMNode")

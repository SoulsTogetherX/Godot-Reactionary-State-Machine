extends HBoxContainer

@onready var col_1: MarginContainer = $Col1
@onready var col_2: MarginContainer = $Col2
@onready var col_3: MarginContainer = $Col3


@onready var _hsm_context: RHSMContext = $HSMContext



func _start_col_1() -> void:
	_hsm_context.set_value("column", 1)
func _start_col_2() -> void:
	_hsm_context.set_value("column", 2)
func _start_col_3() -> void:
	_hsm_context.set_value("column", 3)

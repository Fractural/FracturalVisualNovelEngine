extends "res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/literals/literal/literal.gd"


# ----- Typeable ----- #

func get_types():
	var arr = .get_types()
	arr.append("string literal")
	return arr

# ----- Typeable ----- #


func _init(position_ = null, value_ = null).(position_, value_):
	pass


func _debug_string_literal_name():
	return "STR"

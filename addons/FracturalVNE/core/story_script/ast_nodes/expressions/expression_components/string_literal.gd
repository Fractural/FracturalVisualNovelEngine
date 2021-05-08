extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/literal.gd"

static func get_types():
	var arr = .get_types()
	arr.append("string literal")
	return arr

func _init(position_ = null, value_ = null).(position_, value_):
	pass

func _debug_string_literal_name():
	return "STR"

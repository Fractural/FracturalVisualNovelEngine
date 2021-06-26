extends "res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/constant_value_component/constant_value_component_construct.gd"


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("literal")
	return arr

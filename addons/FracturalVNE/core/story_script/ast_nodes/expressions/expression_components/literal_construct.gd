extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_component_construct.gd"

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("literal")
	return arr

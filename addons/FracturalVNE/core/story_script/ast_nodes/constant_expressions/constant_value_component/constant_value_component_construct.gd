extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_components/value_component/value_component_construct.gd"


func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("constant value component")
	return arr

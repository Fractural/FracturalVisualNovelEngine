extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/operator_parser.gd"

func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("pre unary operator")
	return arr

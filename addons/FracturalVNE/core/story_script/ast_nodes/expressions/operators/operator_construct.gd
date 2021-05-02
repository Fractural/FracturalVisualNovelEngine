extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node_construct.gd"

func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("operator")
	return arr

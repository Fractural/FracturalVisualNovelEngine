extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node/node_construct.gd"
# -- Abstract Class -- #
# Base class for all operator constructs.


func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("Operator")
	return arr

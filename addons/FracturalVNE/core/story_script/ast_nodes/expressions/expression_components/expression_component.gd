extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression.gd"

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("expression component")
	return arr
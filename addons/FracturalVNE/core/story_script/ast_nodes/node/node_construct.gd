extends Reference
# NodeConstructs are objects that parse tokens to create nodes.
# Each node usually has it's own construct (with the exception
# of expressions and operators, since those are handled by the 
# expression constructs.)


const Utils = preload("res://addons/FracturalVNE/core/utils/utils.gd")
const SSUtils = preload("res://addons/FracturalVNE/core/story_script/story_script_utils.gd")


func get_parse_types() -> Array:
	return []


func parse(parser):
	pass

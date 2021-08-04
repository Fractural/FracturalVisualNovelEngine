extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node/node.gd"
# -- Abstract Class -- #
# Base class for all ExpressionNodes.
# Expression nodes can evaluate themselves to
# return a value of some kind.


func get_types() -> Array:
	return ["expression"]


func _init(position_).(position_):
	pass


func evaluate():
	pass

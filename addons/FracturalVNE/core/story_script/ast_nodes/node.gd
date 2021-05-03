extends "res://addons/FracturalVNE/core/utils/typeable.gd"

static func get_types() -> Array:
	return ["node"]

var runtime_block
var position: StoryScriptToken.Position

func _init(position_):
	position = position_

func debug_string(tabs_string: String) -> String:
	return "N/A"

func is_success(result):
	return not result is StoryScriptError

func error(message: String):
	return StoryScriptError.new(message, position)

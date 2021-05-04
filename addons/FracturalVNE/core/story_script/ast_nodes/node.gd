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
	return not result is StoryScriptError and not result is StoryScriptError.ErrorStack

func error(message: String):
	return StoryScriptError.new(message, position)

func throw_error(error):
	# TODO: Add integration within StoryScriptEditor to automatically point out
	# where the error occurred.
	assert(false, str(error))

func stack_error(error, message = ""):
	if error is StoryScriptError.ErrorStack:
		error.add_error(error(message))
		return error
	elif error is StoryScriptError:
		var err_stack = StoryScriptError.ErrorStack.new([error])
		err_stack.add_error(error(message))
		return err_stack
	else:
		assert(false, "Unknown of stack_error()")

func propagate_call(method, arguments, parent_first = false):
	if has_method(method):
		callv(method, arguments)

func configure_node(runtime_block_):
	runtime_block = runtime_block_

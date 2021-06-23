extends "res://addons/FracturalVNE/core/utils/typeable.gd"

static func get_types() -> Array:
	return ["node"]

var reference_id
var runtime_block
var position: StoryScriptPosition

func _init(position_ = StoryScriptPosition.new()):
	position = position_

func propagate_call(method, arguments = [], parent_first = false):
	if has_method(method):
		callv(method, arguments)

func find_node_with_id(reference_id_):
	if reference_id == reference_id_:
		runtime_block.get_service("ASTNodeManager")._add_result(self)

func configure_node(runtime_block_):
	runtime_block = runtime_block_
	reference_id = runtime_block.get_service("ASTNodeConfigurer").next_reference_id()

func debug_string(tabs_string: String) -> String:
	return "N/A"

# ----- Error ----- #

func is_success(result):
	return not result is StoryScriptError and not result is StoryScriptError.ErrorStack

func error(message: String):
	return StoryScriptError.new(message, position)

func throw_error(error):
	# TODO: Add integration within StoryScriptEditor to automatically point out
	# where the error occurred.
	if runtime_block != null:
		runtime_block.throw_error(error)
	# assert(false, str(error))

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

# ----- Error ----- #

# ----- Serialization ----- #

func serialize():
	return {
		"script_path": get_script().get_path(),
		"position": position.serialize(),
	}

func deserialize(serialized_obj):
	var instance = get_script().new()
	instance.position = SerializationUtils.deserialize(serialized_obj["position"])
	# No need to assign runtime_block since that is assgined at runtime
	return instance

# ----- Serialization ----- #

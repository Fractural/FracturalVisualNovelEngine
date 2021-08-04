extends Reference
# -- Abstract Class -- #
# Base class for all nodes. Represents a node on an abstract sytax tree (AST) for a story.
# The root of this tree executes it's children, which execute their own children, etc. in order
# to play an entire story.

# TODO: Refactor the get_types() from all nodes to follow
#		the traditional PascalCase naming style.


# ----- Typeable ----- #
func get_types() -> Array:
	return ["node"]

# ----- Typeable ----- #


const StoryScriptPosition = preload("res://addons/FracturalVNE/core/story_script/story_script_position.gd")
const StoryScriptError = preload("res://addons/FracturalVNE/core/story_script/story_script_error.gd")
const SSUtils = preload("res://addons/FracturalVNE/core/story_script/story_script_utils.gd")
const FracUtils = preload("res://addons/FracturalVNE/core/utils/utils.gd")

var reference_id
var runtime_block setget set_runtime_block, get_runtime_block
var position: StoryScriptPosition


func _init(position_ = StoryScriptPosition.new()):
	position = position_


func propagate_call(method, arguments = [], parent_first = false):
	if has_method(method):
		callv(method, arguments)


func find_node_with_id(reference_id_):
	if reference_id == reference_id_:
		get_runtime_block().get_service("ASTNodeLocator")._add_result(self)


func configure_node(runtime_block_):
	set_runtime_block(runtime_block_)
	reference_id = get_runtime_block().get_service("ASTNodeIDDistributor").next_reference_id()


func set_runtime_block(new_value):
	runtime_block = weakref(new_value)


func get_runtime_block():
	if runtime_block != null:
		return runtime_block.get_ref()


func debug_string(tabs_string: String) -> String:
	return "N/A"


# ----- Error ----- #

func is_success(result):
	return SSUtils.is_success(result)


func error(message: String):
	return StoryScriptError.new(message, position)


func throw_error(error):
	# TODO: Add integration within StoryScriptEditor to automatically point out
	# where the error occurred.
	if get_runtime_block() != null:
		get_runtime_block().throw_error(error)
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


func deserialize(serialized_object):
	var instance = get_script().new()
	instance.position = SerializationUtils.deserialize(serialized_object["position"])
	# No need to assign runtime_block since that is assgined at runtime
	return instance

# ----- Serialization ----- #

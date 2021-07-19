extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Moves a visual to a position with an optional smoothing.


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("move")
	return arr

# ----- Typeable ----- #


const MoveAction = preload("move_action.gd")

var visual
var target_position


func _init(position_ = null, visual_ = null, target_position_ = null).(position_):
	visual = visual_
	target_position = target_position_


func execute():
	var visual_result = visual.evaluate()
	
	if not is_success(visual_result):
		throw_error(stack_error(visual_result, "Could not evaluate the Visual."))
	
	var curr_move_action = MoveAction.new(self)
	
	_on_move_finished(


func _on_move_finished(curr_move_action):
	# If the animation ends naturally, then we have to remove the step_action.
	if not skipped:
		get_runtime_block().get_service("StoryDirector").remove_step_action(curr_animation_action)
	.execute()

func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "HIDE :" 
	
	string += "\n" + tabs_string + "{"
	
	if animation != null:
		string += "\n" + "ANIMATION: " + animation.debug_string(tabs_string)

	string += "\n" + tabs_string + "}"
	return string


func propagate_call(method, arguments = [], parent_first = false):
	if parent_first:
		.propagate_call(method, arguments, parent_first)
	
	visual.propagate_call(method, arguments, parent_first)
	if animation != null:
		animation.propagate_call(method, arguments, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)


# ----- Serialization ----- #

func serialize():
	var serialized_obj = .serialize()
	serialized_obj["visual"] = visual.serialize()
	if animation != null:
		serialized_obj["animation"] = animation.serialize()
	
	return serialized_obj


func deserialize(serialized_obj):	
	var instance = .deserialize(serialized_obj)
	instance.visual = SerializationUtils.deserialize(serialized_obj["visual"])
	if serialized_obj.has("animation"):
		instance.animation = SerializationUtils.deserialize(serialized_obj["animation"])
	
	return instance

# ----- Serialization ----- #

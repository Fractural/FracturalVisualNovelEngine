extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# TODO: Finish the rest the show statement.

# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("show")
	return arr

# ----- Typeable ----- #


var visual
var animation_string


func _init(position_ = null, visual_ = null, animation_string_ = null).(position_):
	visual = visual_
	animation_string = animation_string_


func execute():
	var animation = null
	if animation_string != null:
		animation = get_runtime_block().get_service("VisualsManager").get_animation(animation_string)
		if not is_success(animation):
			throw_error(stack_error(animation, "Expected valid animation for show statement."))
			return
	
	var visual_result = visual.evaluate()
	if not is_success(visual_result):
		return visual_result
	if typeof(visual_result) == TYPE_OBJECT and visual_result.is_type("Visual"):
		visual_result.show(animation_string) 
	else: 
		throw_error(StoryScriptError.new("Expected a visual for the show statement."))
		return
	
	.execute()


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "SHOW :" 
	
	string += "\n" + tabs_string + "{"
	
	if animation_string != null:
		string += "\n" + "ANIMATION: " + animation_string

	string += "\n" + tabs_string + "}"
	return string


func propagate_call(method, arguments = [], parent_first = false):
	if parent_first:
		.propagate_call(method, arguments, parent_first)
	
	visual.propagate_call(method, arguments, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)


# ----- Serialization ----- #

func serialize():
	var serialized_obj = .serialize()
	serialized_obj["visual"] = visual.serialize()
	serialized_obj["animation"] = animation_string
	
	return serialized_obj


func deserialize(serialized_obj):	
	var instance = .deserialize(serialized_obj)
	instance.visual = SerializationUtils.deserialize(serialized_obj["visual"])
	instance.animation_string = serialized_obj["animation"]
	
	return instance

# ----- Serialization ----- #

extends "show_statement.gd"
# TODO: Finish the rest the show statement.


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("multivisual show")
	return arr

# ----- Typeable ----- #


var modifiers_string


func _init(position_ = null, visual_ = null, modifiers_string_ = null, animation_string_ = null).(position_, visual_, animation_string_):
	modifiers_string = modifiers_string_


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
	if typeof(visual) == TYPE_OBJECT and visual.is_type("MultiVisual"):
		if modifiers_string != null:
			visual_result.set_sprite(modifiers_string)
		visual_result.show(animation)
	else: 
		throw_error(StoryScriptError.new("Expected a multi visual for show statements that have modifiers."))
		return
	
	.execute()


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "MULTI VISUALS SHOW :" 
	
	string += "\n" + tabs_string + "{"
	
	if modifiers_string != null:
		string += "\n" + "MODIFIERS: " + modifiers_string
	
	if animation_string != null:
		string += "\n" + "ANIMATION: " + animation_string

	string += "\n" + tabs_string + "}"
	return string


func propagate_call(method: String, arguments: Array = [], parent_first: bool = false):	
	if parent_first:
		.propagate_call(method, arguments, parent_first)
	
	if visual != null:
		visual.propagate_call(method, arguments, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)


# ----- Serialization ----- #

func serialize():
	var serialized_obj = .serialize()
	serialized_obj["visual"] = visual.serialize()
	serialized_obj["modifiers"] = modifiers_string
	
	return serialized_obj


func deserialize(serialized_obj):	
	var instance = .deserialize(serialized_obj)
	instance.visual = serialized_obj["visual"]
	instance.modifiers_string = serialized_obj["modifiers"]
	
	return instance

# ----- Serialization ----- #

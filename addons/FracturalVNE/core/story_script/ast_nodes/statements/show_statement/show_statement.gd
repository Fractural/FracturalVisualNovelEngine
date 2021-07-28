extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Shows a visual.


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("show")
	return arr

# ----- Typeable ----- #


const TransitionAction = preload("res://addons/FracturalVNE/core/transitions/transition_action.gd")
# const animation_player_visual_animation_prefab = preload("res://addons/FracturalVNE/core/visuals/animation/types/animation_player_visual_animation.tscn")

var visual
var animation


func _init(position_ = null, visual_ = null, animation_ = null).(position_):
	visual = visual_
	animation = animation_


func execute():
	var transition_result = null
	if animation != null:
		var animation_result = animation.evaluate()
		
		
		if not is_success(animation_result) or not animation_result is PackedScene:
			throw_error(stack_error(animation_result, "Expected valid StoryScriptTransition for the show statement."))
			return
		 
		if animation_result is PackedScene:
			transition_result = animation_result.instance()
			if not FracUtils.is_type(transition_result, "StoryScriptTransition"):
				throw_error(stack_error(transition_result, "Expected valid StoryScriptTransition for the show statement."))
				return
	
	var visual_result = visual.evaluate()
	if not is_success(visual_result):
		throw_error(stack_error(visual_result, "Could not evaluate the visual."))
		return
	
	if visual_result is Object:
		if FracUtils.is_type(visual_result, "Character"):
			visual_result = visual_result.visual
		
		if FracUtils.is_type(visual_result, "Visual"):
			var curr_transition_action = null
			if transition_result != null:
				curr_transition_action = TransitionAction.new(transition_result)
			
			var visual_controller = get_runtime_block().get_service("VisualManager").get_or_load_visual_controller(visual_result)
			if not is_success(visual_controller):
				throw_error(stack_error(visual_controller, "Could not load visual controller for the show statement."))
				return
			visual_controller.show(transition_result, curr_transition_action)
		else: 
			throw_error(error("Expected a valid visual for the show statement."))
			return
	else: 
		throw_error(error("Expected a valid visual for the show statement."))
		return
	
	.execute()


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "SHOW :" 
	
	string += "\n" + tabs_string + "{"
	
	string += "\n" + tabs_string + "\tVISUAL: "
	string += "\n" + tabs_string + "\t{"
	string += "\n" + visual.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"
	
	if animation != null:
		string += "\n" + tabs_string + "\tANIMATION: "
		string += "\n" + tabs_string + "\t{"
		string += "\n" + animation.debug_string(tabs_string + "\t\t")
		string += "\n" + tabs_string + "\t}"

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
	var serialized_object = .serialize()
	serialized_object["visual"] = visual.serialize()
	if animation != null:
		serialized_object["animation"] = animation.serialize()
	
	return serialized_object


func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	instance.visual = SerializationUtils.deserialize(serialized_object["visual"])
	if serialized_object.has("animation"):
		instance.animation = SerializationUtils.deserialize(serialized_object["animation"])
	
	return instance

# ----- Serialization ----- #

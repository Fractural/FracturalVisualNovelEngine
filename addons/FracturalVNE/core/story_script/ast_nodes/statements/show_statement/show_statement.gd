extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Shows a visual.


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("show")
	return arr

# ----- Typeable ----- #


const AnimationAction = preload("res://addons/FracturalVNE/core/visuals/animation_action.gd")

var visual
var animation


func _init(position_ = null, visual_ = null, animation_ = null).(position_):
	visual = visual_
	animation = animation_


func execute():
	var animation_result = null
	if animation != null:
		animation_result = animation.evaluate()
		
		if not is_success(animation_result) or not animation_result is Animation:
			throw_error(stack_error(animation_result, "Expected valid Animation for the show statement."))
			return
	
	var visual_result = visual.evaluate()
	if not is_success(visual_result):
		throw_error(stack_error(visual_result, "Could not evaluate the visual."))
		return
	
	if typeof(visual_result) == TYPE_OBJECT:
		if visual_result.is_type("Character"):
			visual_result = visual_result.visual
		
		if visual_result.is_type("Visual"):
			visual_result.show(animation_result) 
			
			if animation_result != null:
				# TODO: Allow devs to force users to watch an animation by making the animation unskippable 
				# 		(Will likely rarely be used since we mostly want control in the player's hands)
				var curr_animation_action = AnimationAction.new(visual_result.visual_animator, true)
				visual_result.visual_animator.connect("animation_finished", self, "_on_animation_finished", [curr_animation_action], CONNECT_ONESHOT)
				get_runtime_block().get_service("StoryDirector").add_step_action(curr_animation_action)
		else: 
			throw_error(error("Expected a valid visual for the show statement."))
			return
	else: 
		throw_error(error("Expected a valid visual for the show statement."))
		return
	
	.execute()


func _on_animation_finished(animation_name, skipped, curr_animation_action):
	# If the animation ends naturally, then we have to remove the step_action.
	if not skipped:
		get_runtime_block().get_service("StoryDirector").remove_step_action(curr_animation_action)


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "SHOW :" 
	
	string += "\n" + tabs_string + "{"
	
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

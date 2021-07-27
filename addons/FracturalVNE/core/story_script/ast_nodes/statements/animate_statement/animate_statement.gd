extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Animates a visual.


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("animate")
	return arr

# ----- Typeable ----- #


const Utils = FracVNE.Utils
const AnimationAction = preload("res://addons/FracturalVNE/core/visuals/animation/animation_action.gd")
const animation_player_visual_animation_prefab = preload("res://addons/FracturalVNE/core/visuals/animation/types/animation_player_visual_animation.tscn")

var visual
var animation


func _init(position_ = null, visual_ = null, animation_string_ = null).(position_):
	visual = visual_
	animation = animation_string_


func execute():
	var visual_animation_result = null
	if animation != null:
		var animation_result = animation.evaluate()
		
		if not is_success(animation_result) or not (animation_result is Animation or animation_result is PackedScene):
			throw_error(stack_error(animation_result, "Expected valid Animation or VisualAnimation for the animate statement."))
			return
		
		if animation_result is Animation:
			visual_animation_result = animation_player_visual_animation_prefab.instance()
			var animation_name: String = animation_result.get_path().get_basename().get_file()
			var animation_player = visual_animation_result.get_node(visual_animation_result.animation_player_path)
			animation_player.add_animation(animation_name, animation_result)
			animation_player.assigned_animation = animation_name
		elif animation_result is PackedScene:
			visual_animation_result = animation_result.instance()
			if not Utils.is_type(visual_animation_result, "VisualAnimation"):
				throw_error(stack_error(visual_animation_result, "Expected valid VisualAnimation for the animate statement."))
				return
	
	var visual_result = visual.evaluate()
	if not is_success(visual_result):
		throw_error(stack_error(visual_result, "Could not evaluate the visual."))
		return
	
	if visual_result is Object:
		if Utils.is_type(visual_result, "Character"):
			visual_result = visual_result.visual
		
		if Utils.is_type(visual_result, "Visual"):
			var curr_animation_action = null
			if visual_animation_result != null:
				curr_animation_action = AnimationAction.new(visual_animation_result, true)
			
			var visual_controller = get_runtime_block().get_service("VisualManager").get_or_load_visual_controller(visual_result)
			visual_controller.visual_animator.play_animation(visual_animation_result, curr_animation_action)
		else: 
			throw_error(error("Expected a visual for the animate statement."))
			return
	else: 
		throw_error(error("Expected a visual for the animate statement."))
		return
	
	.execute()


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "ANIMATE :" 
	
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

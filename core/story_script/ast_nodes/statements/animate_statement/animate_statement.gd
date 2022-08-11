extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Animates an actor.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("AnimateStatement")
	return arr

# ----- Typeable ----- #


const ANIMATION_PLAYER_ANIMATION_PREFAB = preload("res://addons/FracturalVNE/core/standard_node_2d/animation/types/animation_player_animation/animation_player_animation.tscn")

var actor
var animation


func _init(position_ = null, actor_ = null, animation_string_ = null).(position_):
	actor = actor_
	animation = animation_string_


func execute():
	var actor_animation_result = null
	if animation != null:
		var animation_result = animation.evaluate()
		
		if not SSUtils.is_success(animation_result) or not (animation_result is Animation or animation_result is PackedScene):
			throw_error(stack_error(animation_result, "Expected valid Animation or ActorAnimation for the animate statement."))
			return
		
		if animation_result is Animation:
			actor_animation_result = ANIMATION_PLAYER_ANIMATION_PREFAB.instance()
			var animation_name: String = animation_result.get_path().get_basename().get_file()
			var animation_player = actor_animation_result.get_node(actor_animation_result.animation_player_path)
			animation_player.add_animation(animation_name, animation_result)
			animation_player.assigned_animation = animation_name
		elif animation_result is PackedScene:
			actor_animation_result = animation_result.instance()
			if not FracUtils.is_type(actor_animation_result, "ActorAnimation"):
				throw_error(stack_error(actor_animation_result, "Expected valid ActorAnimation for the animate statement."))
				return
	
	var actor_result = actor.evaluate()
	if not SSUtils.is_success(actor_result):
		throw_error(stack_error(actor_result, "Could not evaluate the actor."))
		return
	
	if actor_result is Object:
		if FracUtils.is_type(actor_result, "Character"):
			actor_result = actor_result.visual
		
		if FracUtils.is_type(actor_result, "Actor"):
			var actor_controller = get_runtime_block().get_service("ActorManager").get_or_load_actor_controller(actor_result)
			if not SSUtils.is_success(actor_controller):
				throw_error(stack_error(actor_controller, "Could not load actor controller for the animate statement."))
				return
			actor_controller.actor_animator.play_animation(actor_animation_result)
		else: 
			throw_error(error("Expected an actor for the animate statement."))
			return
	else: 
		throw_error(error("Expected an actor for the animate statement."))
		return
	
	_finish_execute()


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "ANIMATE :" 
	
	string += "\n" + tabs_string + "{"
	
	string += "\n" + tabs_string + "\tACTOR: "
	string += "\n" + tabs_string + "\t{"
	string += "\n" + actor.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"
	
	if animation != null:
		string += "\n" + tabs_string + "\tANIMATION: "
		string += "\n" + tabs_string + "\t{"
		string += "\n" + animation.debug_string(tabs_string + "\t\t")
		string += "\n" + tabs_string + "\t}"

	string += "\n" + tabs_string + "}"
	return string


# -- StoryScriptErrorable -- #
func propagate_call(method, arguments = [], parent_first = false):
	var result
	if parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
		
	result = actor.propagate_call(method, arguments, parent_first)
	if not SSUtils.is_success(result):
		return result
	
	if animation != null:
		result = animation.propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
		
	if not parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["actor"] = actor.serialize()
	if animation != null:
		serialized_object["animation"] = animation.serialize()
	
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.actor = SerializationUtils.deserialize(serialized_object["actor"])
	if serialized_object.has("animation"):
		instance.animation = SerializationUtils.deserialize(serialized_object["animation"])
	
	return instance

# ----- Serialization ----- #

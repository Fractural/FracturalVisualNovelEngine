extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Hides a actor.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("hide")
	return arr

# ----- Typeable ----- #


const ANIMATION_PLAYER_HIDE_TRANSITION_PREFAB = preload("res://addons/FracturalVNE/core/actor/transition/types/animation_player_transition/hide.tscn")

var actor
var transition


func _init(position_ = null, actor_ = null, transition_ = null).(position_):
	actor = actor_
	transition = transition_


func execute():
	var transition_instance = _get_transition_instance()
	
	if not is_success(transition_instance):
		throw_error(transition_instance)
		return
	
	var result = _run_hide_transition(transition_instance)
	
	if not is_success(result):
		throw_error(result)
		return
	
	_finish_execute()


func _run_hide_transition(transition_instance):
	var actor_result = evaluate_type("Actor", actor)
	if not is_success(actor_result):
		return stack_error(actor_result, "Could not evaluate the actor for the hide statement.")
	
	var actor_controller = get_runtime_block().get_service("ActorManager").get_or_load_actor_controller(actor_result)
	if not is_success(actor_controller):
		return stack_error(actor_controller, "Could not load the ActorController for the hide statement.")
	actor_controller.actor_transitioner.hide(transition_instance)


func _get_transition_instance():
	var transition_instance = null
	if transition != null:
		var transition_result = evaluate_type("ActorTransition", transition)
		if not is_success(transition_result):
			return stack_error(transition_result, "Could not evaluate transition_result for the hide statement.")
		
		transition_instance = transition_result.hide_transition.instance()
		if not FracUtils.is_type(transition_instance, "SingleTransition"):
			return error("Expected valid SingleTransition for the hide statement.")
	return transition_instance


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "HIDE :" 
	
	string += "\n" + tabs_string + "{"
	
	string += "\n" + tabs_string + "\tACTOR: "
	string += "\n" + tabs_string + "\t{"
	string += "\n" + actor.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"
	
	if transition != null:
		string += "\n" + tabs_string + "\tANIMATION: "
		string += "\n" + tabs_string + "\t{"
		string += "\n" + transition.debug_string(tabs_string + "\t\t")
		string += "\n" + tabs_string + "\t}"

	string += "\n" + tabs_string + "}"
	return string


func propagate_call(method, arguments = [], parent_first = false):
	if parent_first:
		.propagate_call(method, arguments, parent_first)
	
	actor.propagate_call(method, arguments, parent_first)
	if transition != null:
		transition.propagate_call(method, arguments, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)


# ----- Serialization ----- #

func serialize():
	var serialized_object = .serialize()
	serialized_object["actor"] = actor.serialize()
	if transition != null:
		serialized_object["transition"] = transition.serialize()
	
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.actor = SerializationUtils.deserialize(serialized_object["actor"])
	if serialized_object.has("transition"):
		instance.transition = SerializationUtils.deserialize(serialized_object["transition"])
	
	return instance

# ----- Serialization ----- #

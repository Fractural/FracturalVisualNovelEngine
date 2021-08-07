extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Shows an actor.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("show")
	return arr

# ----- Typeable ----- #


var actor
var transition


func _init(position_ = null, actor_ = null, transition_ = null).(position_):
	actor = actor_
	transition = transition_


func execute():
	var transition_result = _get_transition_result()
	
	if not is_success(transition_result):
		throw_error(transition_result)
		return
	
	var result = _run_show_transition(transition_result)
	
	if not is_success(result):
		throw_error(result)
		return
	
	_finish_execute()


func _run_show_transition(transition_result):
	var actor_result = SSUtils.evaluate_and_cast(actor, "Actor")
	if not is_success(actor_result):
		return stack_error(actor_result, "Could not evaluate the actor for the show statement.")
	
	var actor_controller = get_runtime_block().get_service("ActorManager").get_or_load_actor_controller(actor_result)
	if not is_success(actor_controller):
		return stack_error(actor_controller, "Could not load the ActorController for the show statement.")
	actor_controller.actor_transitioner.show(transition_result)


func _get_transition_result():
	var transition_result = null
	if transition != null:
		transition_result = SSUtils.evaluate_and_cast(transition, "StandardNode2DTransition")
		if not is_success(transition_result):
			return stack_error(transition_result, "Could not evaluate transition_result for the show statement.")
	return transition_result


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "SHOW :" 
	
	string += "\n" + tabs_string + "{"
	
	string += "\n" + tabs_string + "\tACTOR: "
	string += "\n" + tabs_string + "\t{"
	string += "\n" + actor.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"
	
	if transition != null:
		string += "\n" + tabs_string + "\tTRANSITION: "
		string += "\n" + tabs_string + "\t{"
		string += "\n" + transition.debug_string(tabs_string + "\t\t")
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
	
	if transition != null:
		result = transition.propagate_call(method, arguments, parent_first)
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

extends "show_statement.gd"
# Shows a MultiVisual. MultiVisuals support showing with modifiers, which specifies
# a specific texture under its texture_directory to show.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("MultiVisualShowStatement")
	return arr

# ----- Typeable ----- #


var modifiers_string


func _init(position_ = null, actor_ = null, modifiers_string_ = null, transition_ = null).(position_, actor_, transition_):
	modifiers_string = modifiers_string_


func _run_show_transition(transition_result):
	var actor_result = SSUtils.evaluate_and_cast(actor, "MultiVisual")
	if not SSUtils.is_success(actor_result):
		return stack_error(actor_result, "Could not evaluate the multi visual for the multi visual show statement.")
	
	if modifiers_string != null:
		var actor_controller = get_runtime_block().get_service("VisualManager").get_or_load_visual_controller(actor_result)
		if not SSUtils.is_success(actor_controller):
			return stack_error(actor_controller, "Could not load MultiVisualController.")
		var result = actor_controller.set_sprite_show(modifiers_string, transition_result)
		if not SSUtils.is_success(result):
			return stack_error(result, "Could not set MultiVisual sprite.")


func _get_transition_result():
	var transition_result = null
	if transition != null:
		transition_result = SSUtils.evaluate_and_cast(transition, "StandardNode2DTransition")
		if not SSUtils.is_success(transition_result):
			return stack_error(transition_result, "Could not evaluate transition_result for the show statement.")
	return transition_result


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "MULTI VISUALS SHOW:" 
	
	string += "\n" + tabs_string + "{"
	
	string += "\n" + tabs_string + "\tVISUAL:"
	string += "\n" + tabs_string + "\t{"
	string += "\n" + actor.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"
	
	if modifiers_string != null:
		string += "\n" + tabs_string + "\tMODIFIERS: " + modifiers_string
	
	if transition != null:
		string += "\n" + tabs_string + "\tTRANSITION:"
		string += "\n" + tabs_string + "\t{"
		string += "\n" + transition.debug_string(tabs_string + "\t\t")
		string += "\n" + tabs_string + "\t}"

	string += "\n" + tabs_string + "}"
	return string


func propagate_call(method: String, arguments: Array = [], parent_first: bool = false):	
	var result
	if parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	if actor != null:
		result = actor.propagate_call(method, arguments, parent_first)
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
	serialized_object["modifiers"] = modifiers_string
	
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.actor = SerializationUtils.deserialize(serialized_object["actor"])
	instance.modifiers_string = serialized_object["modifiers"]
	
	return instance

# ----- Serialization ----- #

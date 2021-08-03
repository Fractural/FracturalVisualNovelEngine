extends "show_statement.gd"
# Shows a MultiVisual. MultiVisuals support showing with modifiers, which specifies
# a specific texture under its texture_directory to show.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("multivisual show")
	return arr

# ----- Typeable ----- #


var modifiers_string


func _init(position_ = null, actor_ = null, modifiers_string_ = null, transition_ = null).(position_, actor_, transition_):
	modifiers_string = modifiers_string_


func _run_show_transition(actor_transition):
	var actor_result = evaluate_type("MultiVisual", actor)
	if not is_success(actor_result):
		throw_error(stack_error(actor_result, "Could not evaluate the multi visual for the multi visual show statement."))
		return
	
	if modifiers_string != null:
		var actor_controller = get_runtime_block().get_service("VisualManager").get_or_load_visual_controller(actor_result)
		if not is_success(actor_controller):
			throw_error(stack_error(actor_controller, "Could not load MultiVisualController."))
			return
		var result = actor_controller.set_sprite(modifiers_string, actor_transition)
		if not is_success(result):
			throw_error(stack_error(result, "Could not set MultiVisual sprite."))
			return
	
	_finish_execute()


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "MULTI VISUALS SHOW :" 
	
	string += "\n" + tabs_string + "{"
	
	string += "\n" + tabs_string + "\tVISUAL: "
	string += "\n" + tabs_string + "\t{"
	string += "\n" + actor.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"
	
	if modifiers_string != null:
		string += "\n" + tabs_string + "\tMODIFIERS: " + modifiers_string
	
	if transition != null:
		string += "\n" + tabs_string + "\tTRANSITION: "
		string += "\n" + tabs_string + "\t{"
		string += "\n" + transition.debug_string(tabs_string + "\t\t")
		string += "\n" + tabs_string + "\t}"

	string += "\n" + tabs_string + "}"
	return string


func propagate_call(method: String, arguments: Array = [], parent_first: bool = false):	
	if parent_first:
		.propagate_call(method, arguments, parent_first)
	
	if actor != null:
		actor.propagate_call(method, arguments, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)


# ----- Serialization ----- #

func serialize():
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

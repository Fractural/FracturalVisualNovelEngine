extends "show_statement.gd"
# Shows a MultiVisual. MultiVisuals support showing with modifiers, which specifies
# a specific texture under its texture_directory to show.


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
	var visual_result = visual.evaluate()
	if not is_success(visual_result):
		throw_error(stack_error(visual_result, "Could not evaluate the multi visual."))
		return
	
	if visual is Object:
		if visual_result.is_type("Character"):
			visual_result = visual_result.visual
		
		if visual_result.is_type("MultiVisual"):
			if modifiers_string != null:
				var result = visual_result.set_sprite(modifiers_string)
				if not is_success(result):
					result.position = position
					throw_error(result)
					return
		else: 
			throw_error(error("Expected a multi visual for show statements that have modifiers."))
			return
	else: 
		throw_error(error("Expected a multi visual for show statements that have modifiers."))
		return
	
	# All animation is done in execute() function of the parent class (show_statement.gd)
	.execute()


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "MULTI VISUALS SHOW :" 
	
	string += "\n" + tabs_string + "{"
	
	string += "\n" + tabs_string + "\tVISUAL: "
	string += "\n" + tabs_string + "\t{"
	string += "\n" + visual.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"
	
	if modifiers_string != null:
		string += "\n" + tabs_string + "\tMODIFIERS: " + modifiers_string
	
	if animation != null:
		string += "\n" + tabs_string + "\tANIMATION: "
		string += "\n" + tabs_string + "\t{"
		string += "\n" + animation.debug_string(tabs_string + "\t\t")
		string += "\n" + tabs_string + "\t}"

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
	var serialized_object = .serialize()
	serialized_object["visual"] = visual.serialize()
	serialized_object["modifiers"] = modifiers_string
	
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.visual = SerializationUtils.deserialize(serialized_object["visual"])
	instance.modifiers_string = serialized_object["modifiers"]
	
	return instance

# ----- Serialization ----- #

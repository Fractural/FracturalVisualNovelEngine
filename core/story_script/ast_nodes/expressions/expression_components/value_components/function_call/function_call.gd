extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_components/value_component/value_component.gd"
# Calls a function from the runtime_block it's under.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("FunctionCallNode")
	return arr

# ----- Typeable ----- #



var name
var argument_group


func _init(position_ = null, name_ = null, argument_group_ = null).(position_):
	name = name_
	argument_group = argument_group_


func evaluate():
	# Formatted arguments is in the form of:
	# [StoryScriptArgument1, StoryScriptArgument2]
	var formatted_arguments = argument_group.evaluate_arguments_as_array()
	if not SSUtils.is_success(formatted_arguments):
		return stack_error(formatted_arguments, "Error in arguments for function \"%s\"." % name)
	
	var result = get_runtime_block().call_function(name, formatted_arguments)
	if not SSUtils.is_success(result):
		return stack_error(result, "Error calling function \"%s\"." % name)
	
	return result


func debug_string(tabs_strings) -> String:
	var string = ""
	string += tabs_strings + "CALL FUNC " + name + ":"
	string += "\n" + tabs_strings + "{"
	string += "\n" + argument_group.debug_string(tabs_strings + "\t")
	string += "\n" + tabs_strings + "}"
	return string


func propagate_call(method: String, arguments: Array = [], parent_first: bool = false):
	var result
	if parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	result = argument_group.propagate_call(method, arguments, parent_first)
	if not SSUtils.is_success(result):
		return result
	
	if not parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["name"] = name
	serialized_object["argument_group"] = argument_group.serialize()
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.name = serialized_object["name"]
	instance.argument_group = SerializationUtils.deserialize(serialized_object["argument_group"])
	return instance

# ----- Serialization ----- #

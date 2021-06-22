extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_component.gd"

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("function call")
	return arr

static func is_stepped() -> bool:
	return false

var name
var argument_group

func _init(position_ = null, name_ = null, argument_group_ = null).(position_):
	name = name_
	argument_group = argument_group_

func evaluate():
	# Formatted arguments is in the form of:
	# [{"name": "parameter name", "value": value}, {"name": "another param name", "value": another_value}]
	var formatted_arguments = []
	for argument in argument_group.arguments:
		var evaluated_value = argument.value.evaluate()
		if is_success(evaluated_value):
			formatted_arguments.append({"name": argument.name, "value": evaluated_value})
		else:
			throw_error(evaluated_value)
	
	var result = runtime_block.call_function(name, formatted_arguments)
	if is_success(result):
		return result
	else:
		throw_error(stack_error(result, 'Error calling function "%s".' % name))
	
func debug_string(tabs_strings) -> String:
	var string = ""
	string += tabs_strings + "CALL FUNC " + name + ":"
	string += "\n" + tabs_strings + "{"
	string += "\n" + argument_group.debug_string(tabs_strings + "\t")
	string += "\n" + tabs_strings + "}"
	return string

func propagate_call(method: String, arguments: Array = [], parent_first: bool = false):
	if parent_first:
		.propagate_call(method, arguments, parent_first)
	
	argument_group.propagate_call(method, arguments, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)

# ----- Serialization ----- #

func serialize():
	var serialized_obj = .serialize()
	serialized_obj["name"] = name
	serialized_obj["argument_group"] = argument_group.serialize()
	return serialized_obj

func deserialize(serialized_obj):	
	var instance = .deserialize(serialized_obj)
	instance.name = serialized_obj["name"]
	instance.argument_group = SerializationUtils.deserialize(serialized_obj["argument_group"])
	return instance

# ----- Serialization ----- #

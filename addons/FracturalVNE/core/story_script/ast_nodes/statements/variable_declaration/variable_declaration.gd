extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("variable declaration")
	return arr

# ----- Typeable ----- #


var variable_name
var value_expression


func _init(position_ = null, variable_name_ = null, value_expression_ = null).(position_):
	variable_name = variable_name_
	value_expression = value_expression_


func execute():
	var result = get_runtime_block().declare_variable(variable_name, value_expression)
	if not is_success(result):
		throw_error(result)
		return
	.execute()


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "VAR DECLARE " + variable_name + ":" 
	string += "\n" + tabs_string + "{"
	string += "\n" + tabs_string + "\tVALUE:"
	string += "\n" + tabs_string + "\t{"
	string += "\n" + value_expression.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"
	string += "\n" + tabs_string + "}"
	return string


func propagate_call(method: String, arguments: Array = [], parent_first: bool = false):	
	if parent_first:
		.propagate_call(method, arguments, parent_first)
	
	value_expression.propagate_call(method, arguments, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)


# ----- Serialization ----- #

func serialize():
	var serialized_obj = .serialize()
	serialized_obj["variable_name"] = variable_name
	serialized_obj["value_expression"] = value_expression.serialize()
	return serialized_obj


func deserialize(serialized_obj):	
	var instance = .deserialize(serialized_obj)
	instance.variable_name = serialized_obj["variable_name"]
	instance.value_expression = SerializationUtils.deserialize(serialized_obj["value_expression"])
	return instance

# ----- Serialization ----- #

extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statement_node.gd"

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("variable assignment")
	return arr

var variable_name
var value_expression

func _init(position_ = null, variable_name_ = null, value_expression_ = null).(position_):
	variable_name = variable_name_
	value_expression = value_expression_

func execute():
	var result = value_expression.evaluate()
	if not is_success(result):
		throw_error(result)
		return
	
	runtime_block.get_variable(variable_name).value = result
	.execute()

func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "VAR ASSIGN " + variable_name + ":" 
	string += "\n" + tabs_string + "{"
	string += "\n" + tabs_string + "\tNEW VALUE:"
	string += "\n" + tabs_string + "\t{"
	string += "\n" + value_expression.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"
	string += "\n" + tabs_string + "}"
	return string

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

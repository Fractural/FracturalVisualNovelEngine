extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/parenthesized_expression/parenthesized_expression.gd"


func _init(position_ = null, operand_ = null).(position_, operand_):
	pass


func evaluate():
	return operand.evaluate()


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "CONSTANT PARENTHESES GROUP:"
	string += "\n" + tabs_string + "{"
	string += "\n" + operand.debug_string(tabs_string + "\t")
	string += "\n" + tabs_string + "}"
	return string


func propagate_call(method, arguments = [], parent_first = false):
	if parent_first:
		.propagate_call(method, arguments, parent_first)
	
	operand.propagate_call(method, arguments, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)


# ----- Serialization ----- #

func serialize():
	var serialized_object = .serialize()
	serialized_object["operand"] = operand.serialize()
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.operand = SerializationUtils.deserialize(serialized_object["operand"])
	return instance

# ----- Serialization ----- #

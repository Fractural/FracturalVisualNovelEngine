extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Evaluates an expression.
# Function calls are called via this manner.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("expression statement")
	return arr

# ----- Typeable ----- #


var expression


func _init(position_ = null, expression_ = null).(position_):
	expression = expression_


func execute():
	var result = expression.evaluate()
	if not is_success(result):
		throw_error(stack_error(result, 'Expression statement could not evaluate.'))
		return
	_finish_execute()


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "EXPR STMT:"
	string += "\n" + tabs_string + "{"
	string += "\n" + expression.debug_string(tabs_string + "\t")
	string += "\n" + tabs_string + "}"
	return string


func propagate_call(method, arguments = [], parent_first = false):
	if parent_first:
		.propagate_call(method, arguments, parent_first)
	
	expression.propagate_call(method, arguments)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["expression"] = expression.serialize()
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.expression = SerializationUtils.deserialize(serialized_object["expression"])
	return instance

# ----- Serialization ----- #

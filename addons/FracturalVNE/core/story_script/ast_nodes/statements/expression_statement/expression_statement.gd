extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"


# ----- Typeable ----- #

static func get_types() -> Array:
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
	.execute()


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

func serialize():
	var serialized_obj = .serialize()
	serialized_obj["expression"] = expression.serialize()
	return serialized_obj


func deserialize(serialized_obj):	
	var instance = .deserialize(serialized_obj)
	instance.expression = SerializationUtils.deserialize(serialized_obj["expression"])
	return instance

# ----- Serialization ----- #

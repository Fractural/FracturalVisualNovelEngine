extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node/node.gd"
# Holds an argument, which is a name and value pair.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("ArgumentNode")
	return arr

# ----- Typeable ----- #Z

const Argument = preload("res://addons/FracturalVNE/core/story_script/story_script_argument.gd")

var name	# String
var value	# ExpressionNode


func _init(position_ = null, name_ = null, value_ = null).(position_):
	name = name_
	value = value_


# -- StoryScriptErrorable -- #
func evaluate_argument():
	var value_result = value.evaluate()
	if not SSUtils.is_success(value_result):
		if name != null:
			return stack_error(value_result, "Could not evaluate value of argument named: \"%s\"." % name)
		else:
			return stack_error(value_result, "Could not evaluate unnamed argument.")
	return Argument.new(name, value_result)


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "ARG " + ("_" if name == null else str(name)) + ": "
	string += "\n" + tabs_string + "{"
	string += "\n" + value.debug_string(tabs_string + "\t")
	string += "\n" + tabs_string + "}"
	return string


func propagate_call(method: String, arguments_: Array = [], parent_first: bool = false):
	if parent_first:
		.propagate_call(method, arguments_, parent_first)
	
	value.propagate_call(method, arguments_, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments_, parent_first)


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["name"] = name
	serialized_object["value"] = value.serialize()
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.name = serialized_object["name"]
	instance.value = SerializationUtils.deserialize(serialized_object["value"])
	return instance

# ----- Serialization ----- #

extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Standard if statement. 
# Executes a block of code if some condition is true. 


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("IfStatement")
	return arr

# ----- Typeable ----- #


var condition
var block
var next_if_statement


func _init(position_ = null, condition_ = null, block_ = null, next_if_statement_ = null).(position_):
	condition = condition_
	block = block_
	next_if_statement = next_if_statement_


func configure_node(runtime_block_):
	.configure_node(runtime_block_)
	block.connect("executed", self, "_finish_execute")
	if next_if_statement != null:
		next_if_statement.connect("executed", self, "_finish_execute")


func execute():
	var condition_result = SSUtils.evaluate_and_cast(condition, "bool")
	if not SSUtils.is_success(condition_result):
		throw_error(stack_error(condition_result, "Could not evaluate the condition for the if statement."))
		return
	if condition_result:
		block.execute()
	else:
		next_if_statement.execute()


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "IF:" 
	
	string += "\n" + tabs_string + "{"
	
	string += "\n\t" + tabs_string + "CONDITION:"
	string += "\n\t" + tabs_string + "{"
	string += "\n" + condition.debug_string(tabs_string + "\t\t")
	string += "\n\t" + tabs_string + "}"
	
	string += "\n" + block.debug_string(tabs_string + "\t")
	
	if next_if_statement != null:
		string += "\n\t" + tabs_string + "ELSE:"
		string += "\n\t" + tabs_string + "{"
		string += "\n" + next_if_statement.debug_string(tabs_string + "\t\t")
		string += "\n\t" + tabs_string + "}"
	
	string += "\n" + tabs_string + "}"
	return string


# -- StoryScriptErrorable -- #
func propagate_call(method, arguments = [], parent_first = false):
	var result
	if parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	result = condition.propagate_call(method, arguments, parent_first)
	if not SSUtils.is_success(result):
		return result
	
	result = block.propagate_call(method, arguments, parent_first)
	if not SSUtils.is_success(result):
		return result
	
	if next_if_statement != null:
		result = next_if_statement.propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	if not parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["condition"] = condition.serialize()
	serialized_object["block"] = block.serialize()
	if next_if_statement != null:
		serialized_object["next_if_statement"] = next_if_statement.serialize()
	return serialized_object


func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	instance.condition = SerializationUtils.deserialize(serialized_object["condition"])
	instance.block = SerializationUtils.deserialize(serialized_object["block"])
	if serialized_object.has("next_if_statement"):
		instance.next_if_statement = SerializationUtils.deserialize(serialized_object["next_if_statement"])
	return instance
	
# ----- Serialization ----- #

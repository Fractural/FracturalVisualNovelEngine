extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node/executable_node.gd"
# Holds an option for a choice statement.


var ChoiceOption = load("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/choice_statement/choice_option.gd")

var block
var choice_text
var condition


func _init(position = null, choice_text_ = null, block_ = null).(position):
	block = block_
	choice_text = choice_text_


func configure_node(runtime_block_):
	.configure_node(runtime_block_)
	block.connect("finished", self, "_on_block_finished")


func execute():
	block.execute()


func _on_block_finished():
	_finish_execute()

# -- StoryScriptErrorable -- #
func get_choice_option():
	var is_valid_result = is_valid()
	if not SSUtils.is_success(is_valid_result):
		return is_valid_result
	
	var choice_text_result = SSUtils.evaluate_and_cast(choice_text, "String")
	if not SSUtils.is_success(choice_text_result):
		return choice_text_result
	
	return ChoiceOption.new(choice_text_result, is_valid_result)


# -- StoryScriptErrorable -- #
func is_valid():
	if condition == null:
		return true
	return SSUtils.evaluate_and_cast(condition.evaluate(), "bool")


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "OPTION:" 
	
	string += "\n" + tabs_string + "{"
	
	string += "\n" + tabs_string + "\tBLOCK:"
	string += "\n" + tabs_string + "\t{"
	string += "\n" + block.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"
	
	string += "\n" + tabs_string + "\tCHOICE TEXT:"
	string += "\n" + tabs_string + "\t{"
	string += "\n" + choice_text.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"
	
	if condition != null:
		string += "\n" + tabs_string + "\tCHOICE TEXT:"
		string += "\n" + tabs_string + "\t{"
		string += "\n" + condition.debug_string(tabs_string + "\t\t")
		string += "\n" + tabs_string + "\t}"

	string += "\n" + tabs_string + "}"
	return string


func propagate_call(method: String, arguments: Array = [], parent_first: bool = false):	
	var result
	if parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	result = block.propagate_call(method, arguments, parent_first)
	if not SSUtils.is_success(result):
		return result
		
	result = choice_text.propagate_call(method, arguments, parent_first)
	if not SSUtils.is_success(result):
		return result
	
	if condition != null:
		result = condition.propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	if not parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["block"] = block.serialize()
	serialized_object["choice_text"] = choice_text.serialize()
	serialized_object["condition"] = condition.serialize()
	return serialized_object


func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	instance.block = SerializationUtils.deserialize(serialized_object["block"])
	instance.choice_text = SerializationUtils.deserialize(serialized_object["choice_text"])
	instance.condition = SerializationUtils.deserialize(serialized_object["condition"])
	return instance

# ----- Serialization ----- #

extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Creates a choice for the user.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("ChoiceStatement")
	return arr

# ----- Typeable ----- #


const ChoiceAction = preload("res://addons/FracturalVNE/core/story/choice/choice_action.gd")

var option_nodes

var _curr_choice_action


func _init(position_ = null, option_nodes_ = null).(position_):
	option_nodes = option_nodes_


func configure_node(runtime_block_):
	.configure_node(runtime_block_)
	for option_node in option_nodes:
		option_node.connect("executed", self, "_finish_execute")


func execute():
	var options: Array = []
	for option_node in option_nodes:
		var result = option_node.get_choice_option()
		if not SSUtils.is_success(result):
			throw_error(stack_error(result, "Could not run the choice statement."))
			return
		options.append(result)
	
	_curr_choice_action = ChoiceAction.new(self)
	get_runtime_block().get_service("StoryDirector").add_step_action(_curr_choice_action)
	var choice_manager = get_runtime_block().get_service("ChoiceManager")
	choice_manager.connect("choice_selected", self, "_on_choice_selected")
	choice_manager.start_choice(options)


func _on_choice_selected(choice_index):
	_finished_choice(false)
	option_nodes[choice_index].execute()


func _finished_choice(skipped: bool):
	get_runtime_block().get_service("ChoiceManager").disconnect("choice_selected", self, "_on_choice_selected")
	if skipped:
		_finish_execute()
	else:
		get_runtime_block().get_service("StoryDirector").remove_step_action(_curr_choice_action)


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "CHOICE:" 
	
	string += "\n" + tabs_string + "{"
	
	for option_node in option_nodes:
		string += "\n" + option_node.debug_string(tabs_string + "\t")
	
	string += "\n" + tabs_string + "}"
	return string


# -- StoryScriptErrorable -- #
func propagate_call(method, arguments = [], parent_first = false):
	var result
	if parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	for option_node in option_nodes:
		result = option_node.propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	if not parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	var serialized_option_nodes: Array = []
	for option_node in option_nodes:
		serialized_option_nodes.append(option_node.serialize())
	serialized_object["option_nodes"] = serialized_option_nodes
	return serialized_object


func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	var option_nodes = []
	for serialized_option_node in serialized_object["option_nodes"]:
		option_nodes.append(SerializationUtils.deserialize(serialized_option_node))
	instance.option_nodes = option_nodes
	return instance
	
# ----- Serialization ----- #

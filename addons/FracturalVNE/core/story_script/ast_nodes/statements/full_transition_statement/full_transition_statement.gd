extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Performs a full screen transition.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("FullTransitionStatement")
	return arr

# ----- Typeable ----- #


var transition
var setup_block
var is_skippable


func _init(position_ = null, transition_ = null, setup_block_ = null, is_skippable_ = null).(position_):
	transition = transition_
	setup_block = setup_block_
	is_skippable = is_skippable_


func configure_node(runtime_block_):
	.configure_node(runtime_block_)
	setup_block.connect("executed", self, "_on_setup_block_executed")


func execute():
	var transition_result = SSUtils.evaluate_and_cast(transition, "StandardNode2DTransition")
	if not SSUtils.is_success(transition_result):
		return SSUtils.stack_error(transition_result, "Expected a valid StandardNode2DTransition for \"transition\".")
	
	var is_skippable_result 
	if is_skippable == null:
		is_skippable_result = false
	else:
		is_skippable_result = SSUtils.evaluate_and_cast(is_skippable, "bool")
		if not SSUtils.is_success(is_skippable_result):
			return SSUtils.stack_error(is_skippable_result, "Expected a bool for \"is_skippable\".")
	
	var full_transition_manager = get_runtime_block().get_service("FullTransitionManager")
	full_transition_manager.connect("transition_in_finished", self, "_on_transition_in_finished")
	full_transition_manager.connect("transition_out_finished", self, "_on_transition_out_finished")
	full_transition_manager.start_transition(transition_result, is_skippable_result)


func skip_transition():
	_on_transition_in_finished()
	_on_transition_out_finished()


func _on_transition_in_finished():
	setup_block.execute()


func _on_setup_block_executed():
	get_runtime_block().get_service("FullTransitionManager").resume_transition()


func _on_transition_out_finished():
	_finish_execute()


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "FULL TRANSITION:" 
	
	string += "\n" + tabs_string + "{"
	
	string += "\n\t" + tabs_string + "TRANSITION:"
	string += "\n\t" + tabs_string + "{"
	string += "\n" + transition.debug_string(tabs_string + "\t")
	string += "\n\t" + tabs_string + "}"
	
	string += "\n\t" + tabs_string + "BLOCK:"
	string += "\n\t" + tabs_string + "{"
	string += "\n\t" + tabs_string + "}"
	string += "\n" + setup_block.debug_string(tabs_string + "\t")
	
	string += "\n" + tabs_string + "}"
	return string


# -- StoryScriptErrorable -- #
func propagate_call(method, arguments = [], parent_first = false):
	var result
	if parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	result = transition.propagate_call(method, arguments, parent_first)
	if not SSUtils.is_success(result):
		return result
	
	result = setup_block.propagate_call(method, arguments, parent_first)
	if not SSUtils.is_success(result):
		return result
	
	if not parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["transition"] = transition.serialize()
	serialized_object["setup_block"] = setup_block.serialize()
	return serialized_object


func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	instance.transition = SerializationUtils.deserialize(serialized_object["transition"])
	instance.setup_block = SerializationUtils.deserialize(serialized_object["setup_block"])
	return instance
	
# ----- Serialization ----- #

extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Removes an ActorController.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("RemoveStatement")
	return arr

# ----- Typeable ----- #


var actor


func _init(position_ = null, actor_ = null).(position_):
	actor = actor_


func execute():
	var actor_result = SSUtils.evaluate_and_cast(actor, "Actor")
	if not SSUtils.is_success(actor_result):
		return SSUtils.stack_error(actor_result, "Expected a valid Actor for \"actor\".")
	
	get_runtime_block().get_service("ActorManager").remove_actor_controller(actor_result)
	_finish_execute()


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "REMOVE:" 
	
	string += "\n" + tabs_string + "{"
	
	string += "\n" + actor.debug_string(tabs_string + "\t")

	string += "\n" + tabs_string + "}"
	return string


# -- StoryScriptErrorable -- #
func propagate_call(method, arguments = [], parent_first = false):
	var result
	if parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	result = actor.propagate_call(method, arguments, parent_first)
	if not SSUtils.is_success(result):
		return result
	
	if not parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["actor"] = actor.serialize()
	return serialized_object


func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	instance.actor = SerializationUtils.deserialize(serialized_object["actor"])
	return instance
	
# ----- Serialization ----- #

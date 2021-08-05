extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Transitions to a BGScene.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("scene")
	return arr

# ----- Typeable ----- #


var scene
var transition
var keep_old_scene


func _init(position_ = null, scene_ = null, transition_ = null, keep_old_scene_ = null).(position_):
	scene = scene_
	transition = transition_
	keep_old_scene = keep_old_scene_


func execute():
	var scene_result = SSUtils.evaluate_and_cast(scene, "BGScene")
	if not is_success(scene_result):
		throw_error(stack_error(scene_result, "Expected a valid BGScene for the scene statement."))
		return
	
	var transition_result = null
	if transition != null:
		transition_result = SSUtils.evaluate_and_cast(transition, "StandardNode2DTransition")
		if not is_success(transition_result):
			throw_error(stack_error(transition_result, "Expected a valid StandardNode2DTransition for the scene statement."))
			return
	
	var keep_old_scene_result = false
	if keep_old_scene != null:
		keep_old_scene_result = SSUtils.evaluate_and_cast(keep_old_scene, "bool")
		if not is_success(keep_old_scene_result):
			throw_error(stack_error(keep_old_scene_result, "Expected a bool for the scene statement."))
			return
	
	var result = get_runtime_block().get_service("BGSceneManager").show_scene(scene_result, transition_result, keep_old_scene_result)
	if not is_success(result):
		throw_error(stack_error(result, "Could not show scene."))
		return
	
	_finish_execute()


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "SCENE :" 
	
	string += "\n" + tabs_string + "{"
	
	string += "\n" + tabs_string + "\tSCENE: "
	string += "\n" + tabs_string + "\t{"
	string += "\n" + scene.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"
	
	if transition != null:
		string += "\n" + tabs_string + "\tTRANSITION: "
		string += "\n" + tabs_string + "\t{"
		string += "\n" + transition.debug_string(tabs_string + "\t\t")
		string += "\n" + tabs_string + "\t}"

	string += "\n" + tabs_string + "}"
	return string


func propagate_call(method, arguments = [], parent_first = false):
	if parent_first:
		.propagate_call(method, arguments, parent_first)
	
	scene.propagate_call(method, arguments, parent_first)
	if transition != null:
		transition.propagate_call(method, arguments, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["scene"] = scene.serialize()
	if keep_old_scene != null:
		serialized_object["keep_old_scene"] = keep_old_scene.serialize()
	if transition != null:
		serialized_object["transition"] = transition.serialize()
	
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.scene = SerializationUtils.deserialize(serialized_object["scene"])
	if serialized_object.has("keep_old_scene"):
		instance.keep_old_scene = SerializationUtils.deserialize(serialized_object["keep_old_scene"])
	if serialized_object.has("transition"):
		instance.transition = SerializationUtils.deserialize(serialized_object["transition"])
	
	return instance

# ----- Serialization ----- #

extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statement_node.gd"

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("jump")
	return arr

func overrides_story_flow():
	return true

var label_name

func _init(position_ = null, label_name_ = null).(position_):
	label_name = label_name_

# TODO NOW: Add error system and connect it to the StoryRuntimeDebugger error popup

func execute():
	var result = runtime_block.get_service("StoryDirector").jump_to_label(label_name)
	if not is_success(result):
		throw_error(stack_error(result, 'Error jumping to label "%s".' % label_name))
		return
	emit_signal("executed")

func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "JUMP -> " + label_name 
	return string

# ----- Serialization ----- #

func serialize():
	var serialized_obj = .serialize()
	serialized_obj["label_name"] = label_name
	return serialized_obj

func deserialize(serialized_obj):	
	var instance = .deserialize(serialized_obj)
	instance.label_name = serialized_obj["label_name"]
	return instance

# ----- Serialization ----- #

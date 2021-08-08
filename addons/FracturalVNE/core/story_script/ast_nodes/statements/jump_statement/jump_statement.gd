extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Jumps to a label.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("JumpStatement")
	return arr

# ----- Typeable ----- #


var label_name


func _init(position_ = null, label_name_ = null).(position_):
	label_name = label_name_
	overrides_story_flow = true


func execute():
	var result = get_runtime_block().get_service("StoryDirector").jump_to_label(label_name)
	if not is_success(result):
		throw_error(stack_error(result, 'Error jumping to label "%s".' % label_name))
		return
	_finish_execute()


func _finish_execute():
	emit_signal("executed")


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "JUMP -> " + label_name 
	return string


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["label_name"] = label_name
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.label_name = serialized_object["label_name"]
	return instance

# ----- Serialization ----- #

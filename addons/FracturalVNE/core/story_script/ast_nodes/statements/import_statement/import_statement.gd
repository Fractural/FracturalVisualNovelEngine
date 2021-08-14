extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Imports another story by attaching it to this node.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("ImportStatement")
	return arr

# ----- Typeable ----- #


var story_file_path
# story_block gets assigned when the story from story_file_path
# is imported. Then when this node is executed it will
# execute the story_block.
var story_block


func _init(position_ = null, story_file_path_ = null).(position_):
	story_file_path = story_file_path_


func set_story_block(value):
	story_block = value
	if story_block != null:
		story_block.override_scope = true
		story_block.propagate_call("configure_node", [get_runtime_block()], true)
		story_block.propagate_call("runtime_initialize")
		story_block.connect("executed", self, "story_block_executed")


func runtime_initialize():
	var story_file_path_result = SSUtils.evaluate_and_cast(story_file_path, "String")
	if not SSUtils.is_success(story_file_path_result):
		return stack_error(story_file_path_result, "Expected a string for the story path in an import statement.")
	
	var imported_story_block = get_runtime_block().get_service("StoryImportManager").import_story(story_file_path_result, reference_id, position)
	if not SSUtils.is_success(imported_story_block):
		return stack_error(imported_story_block, "Could not load imported story block in import statement.")
	
	set_story_block(imported_story_block)


func execute():
	if story_block != null:
		story_block.execute()


func story_block_executed():
	_finish_execute()


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "IMPORT:"
	string += "\n" + tabs_string + "{"
	
	string += "\n" + tabs_string + "\tSTORY PATH:"
	string += "\n" + tabs_string + "\t{"
	string += "\n" + story_file_path.debug_string(tabs_string + "\t")
	string += "\n" + tabs_string + "\t}"
	
	string += "\n" + tabs_string + "}"
	return string


# -- StoryScriptErrorable -- #
func propagate_call(method, arguments = [], parent_first = false):
	var result
	if parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	result = story_file_path.propagate_call(method, arguments, parent_first)
	if not SSUtils.is_success(result):
		return result
	
	if story_block != null:
		result = story_block.propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	if not parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["story_file_path"] = story_file_path.serialize()
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.story_file_path = SerializationUtils.deserialize(serialized_object["story_file_path"])
	return instance

# ----- Serialization ----- #

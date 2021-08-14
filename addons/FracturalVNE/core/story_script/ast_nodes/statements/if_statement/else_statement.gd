extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Standard if statement. 
# Executes a block of code if some condition is true. 


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("ElseStatement")
	return arr

# ----- Typeable ----- #


var block


func _init(position_ = null, block_ = null).(position_):
	block = block_


func _post_init():
	block.connect("executed", self, "_finish_execute")


func execute():
	block.execute()


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "DEFAULT ELSE:" 
	
	string += "\n" + tabs_string + "{"
	string += "\n" + block.debug_string(tabs_string + "\t")
	string += "\n" + tabs_string + "}"
	return string


# -- StoryScriptErrorable -- #
func propagate_call(method, arguments = [], parent_first = false):
	var result
	if parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	result = block.propagate_call(method, arguments, parent_first)
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
	return serialized_object


func deserialize(serialized_object):
	var instance = _pre_init_deserialize(serialized_object)
	instance._post_init()
	return instance


func _pre_init_deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	instance.block = SerializationUtils.deserialize(serialized_object["block"])
	return instance
	
# ----- Serialization ----- #

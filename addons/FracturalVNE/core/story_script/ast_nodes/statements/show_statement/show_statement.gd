extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# TODO: Finish the rest the show statement.


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("show")
	return arr

# ----- Typeable ----- #


var visual
var modifiers
var animation


func _init(position_ = null, visual_ = null, modifiers_ = null, animation_ = null).(position_):
	visual = visual_
	modifiers = modifiers_
	animation = animation_


func execute(arguments = []):
	if parameter_group != null:
		for arg in arguments:
			var result = block.set_variable(arg.name, arg.value)
			if not is_success(result):
				return stack_error(result, "Could not assign argument with name %s." % [arg.name])
	
	block.execute()


func block_executed():
	.execute()


func runtime_initialize():
	var result = get_runtime_block().get_service("StoryDirector").add_label(self)
	if not is_success(result):
		throw_error(result)
		return


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "LABEL " + name + ":" 
	
	string += "\n" + tabs_string + "{"
	
	if parameter_group != null:
		string += "\n" + parameter_group.debug_string(tabs_string + "\t")

	string += "\n" + block.debug_string(tabs_string + "\t")
	string += "\n" + tabs_string + "}"
	return string


func propagate_call(method, arguments = [], parent_first = false):
	if parent_first:
		.propagate_call(method, arguments, parent_first)
	
	block.propagate_call(method, arguments, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)


# ----- Serialization ----- #

func serialize():
	var serialized_obj = .serialize()
	serialized_obj["name"] = name
	serialized_obj["block"] = block.serialize()
	if parameter_group != null:
		serialized_obj["parameter_group"] = parameter_group.serialize()
	return serialized_obj


func deserialize(serialized_obj):	
	var instance = .deserialize(serialized_obj)
	instance.name = serialized_obj["name"]
	instance.block = SerializationUtils.deserialize(serialized_obj["block"])
	if serialized_obj.has("parameter_group"):
		instance.parameter_group = SerializationUtils.deserialize(serialized_obj["parameter_group"])
	instance._init_post()
	return instance

# ----- Serialization ----- #

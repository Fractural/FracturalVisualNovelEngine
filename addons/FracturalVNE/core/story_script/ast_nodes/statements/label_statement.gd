extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statement_node.gd"

var name
var block
var parameter_group

func _init(position_ = null, name_ = null, block_ = null, parameter_group_ = null).(position_):
	name = name_
	block = block_
	parameter_group = parameter_group_

func _init_post():
	block.connect("executed", self, "block_executed")
	if parameter_group != null:
		for param in parameter_group.parameters:
			block.declare_variable(param.name, param.default_value)

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

extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement_construct.gd"

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("label")
	return arr

func get_keywords() -> Array:
	return ["label"]

func get_punctuation() -> Array:
	return [":"]

func parse(parser):
	var checkpoint = parser.save_reader_state()
	var label = parser.expect_token("keyword", "label")
	if parser.is_success(label):
		var identifier = parser.expect_token("identifier")
		if parser.is_success(identifier):
			var colon = parser.expect_token("punctuation", ":")
			if parser.is_success(colon):
				var block = parser.expect("block")
				if parser.is_success(block):
					return LabelNode.new(label.position, identifier.symbol, block)
				else:
					return parser.error(block, 4/5.0, checkpoint)
			else:
				var params = parser.expect("parenthesized parameters")
				if parser.is_success(params):
					colon = parser.expect_token("punctuation", ":")
					if parser.is_success(colon):
						var block = parser.expect("block")
						if parser.is_success(block):
							return LabelNode.new(label.position, identifier.symbol, block, params)
						else:
							return parser.error(block, 4/5.0, checkpoint)
					else:
						return parser.error(colon, 3/5.0, checkpoint)
				else:
					return parser.error(params, 2/5.0, checkpoint)
		else:
			return parser.error(identifier, 1/5.0, checkpoint)
	else:
		return parser.error(label, 0)
# TODO NOW: Port over ast_nodes following the google drawings UML diagram

class LabelNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statement_node.gd":
	var name: String
	var block
	var parameter_group
	
	func _init(position_, name_: String, block_, parameter_group_ = null).(position_):
		name = name_
		block = block_
		block.connect("executed", self, "block_executed")
		parameter_group = parameter_group_
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
		runtime_block.get_service("StoryDirector").add_label(self)
	
	func debug_string(tabs_string: String) -> String:
		var string = ""
		string += tabs_string + "LABEL " + name + ":" 
		
		if parameter_group != null:
			string += "\n" + tabs_string + "("
			string += "\n" + parameter_group.debug_string(tabs_string + "\t")
			string += "\n" + tabs_string + ")"
		
		string += "\n" + tabs_string + "{"
		string += "\n" + block.debug_string(tabs_string + "\t")
		string += "\n" + tabs_string + "}"
		return string
	
	func propagate_call(method, arguments, parent_first = false):
		if parent_first:
			.propagate_call(method, arguments, parent_first)
		
		block.propagate_call(method, arguments, parent_first)
		
		if not parent_first:
			.propagate_call(method, arguments, parent_first)

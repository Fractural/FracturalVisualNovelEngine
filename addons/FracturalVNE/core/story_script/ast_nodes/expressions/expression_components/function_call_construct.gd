extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_component_construct.gd"

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("function call")
	return arr

func parse(parser):
	var checkpoint = parser.save_reader_state()
	var function = parser.expect_token("identifier")
	if parser.is_success(function):
		var arguments = parser.expect("parenthesized arguments")
		var ahead = str(parser.peek().symbol) + str(parser.peek(2).symbol) + str(parser.peek(3).symbol)
		if parser.is_success(arguments):
			return FunctionCallNode.new(function.symbol, arguments)
		else:
			return parser.error(arguments, 1, checkpoint)
	else:
		return function

class FunctionCallNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node.gd":
	var name: String
	var argument_group
	
	func _init(name_: String, argument_group_):
		name = name_
		argument_group = argument_group_
	
	func execute(runtime_manager):
		runtime_manager.call_function(self)
	
	func debug_string(tabs_strings) -> String:
		var string = ""
		string += tabs_strings + "CALL FUNC " + name + ":"
		string += "\n" + tabs_strings + "{"
		string += "\n" + argument_group.debug_string(tabs_strings + "\t")
		string += "\n" + tabs_strings + "}"
		return string

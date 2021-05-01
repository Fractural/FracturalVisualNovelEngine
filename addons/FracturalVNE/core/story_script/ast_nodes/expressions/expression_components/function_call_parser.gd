extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/expression_component_parser.gd"

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("function call")
	return arr

func parse(parser):
	var function = parser.expect_token("identifier")
	if parser.is_success(function):
		var arguments = parser.expect("arguments")
		if parser.is_success(arguments):
			return FunctionCallNode.new(function.symbol, arguments)
		else:
			arguments.confidence = 1/2.0
			return arguments
	else:
		return function

class FunctionCallNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node.gd":
	var name: String
	var arguments
	
	func _init(name_: String, arguments_):
		name = name_
		arguments = arguments_
	
	func execute(runtime_manager):
		runtime_manager.call_function(self)

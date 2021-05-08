extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_component_construct.gd"

const FunctionCallNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/function_call.gd")

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("function call")
	return arr

func parse(parser):
	var checkpoint = parser.save_reader_state()
	var function = parser.expect_token("identifier")
	if parser.is_success(function):
		var arguments = parser.expect("parenthesized arguments")
		if parser.is_success(arguments):
			return FunctionCallNode.new(function.position, function.symbol, arguments)
		else:
			return parser.error(arguments, arguments.confidence, checkpoint)
	else:
		return function

extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement_construct.gd"

func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("expression statement")
	return arr

func parse(parser):
	var checkpoint = parser.save_reader_state()
	var ahead = str(parser.peek()) + str(parser.peek(2)) + str(parser.peek(3))
	var expression = parser.expect("expression")
	if parser.is_success(expression):
		if parser.is_success(parser.expect_token("punctuation", "newline")):
			return ExpressionStatementNode.new(expression)
		else:
			return parser.error("Expected a new line to conclude a statement.", 1/2.0, checkpoint)
	else:
		return expression

class ExpressionStatementNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node.gd":
	var expression
	
	func _init(expression_):
		expression = expression_
	
	func execute(runtime_manager):
		expression.evaluate(runtime_manager)
	
	func debug_string(tabs_string: String) -> String:
		var string = ""
		string += tabs_string + "EXPR STMT:"
		string += "\n" + tabs_string + "{"
		string += "\n" + expression.debug_string(tabs_string + "\t")
		string += "\n" + tabs_string + "}"
		return string

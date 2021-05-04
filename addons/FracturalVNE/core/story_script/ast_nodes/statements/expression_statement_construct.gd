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
		var newline = parser.expect_token("punctuation", "newline")
		if parser.is_success(newline):
			return ExpressionStatementNode.new(expression.position, expression)
		else:
			newline.message = "Expected a new line to conclude an expression statement."
			return parser.error(newline, 1/2.0, checkpoint)
	else:
		return expression

class ExpressionStatementNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statement_node.gd":
	var expression
	
	func _init(position_, expression_).(position_):
		expression = expression_
	
	func execute():
		expression.evaluate()
		.execute()
	
	func debug_string(tabs_string: String) -> String:
		var string = ""
		string += tabs_string + "EXPR STMT:"
		string += "\n" + tabs_string + "{"
		string += "\n" + expression.debug_string(tabs_string + "\t")
		string += "\n" + tabs_string + "}"
		return string
	
	func propagate_call(method, arguments, parent_first = false):
		if parent_first:
			.propagate_call(method, arguments, parent_first)
		
		expression.propagate_call(method, arguments)
		
		if not parent_first:
			.propagate_call(method, arguments, parent_first)

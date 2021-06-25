extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement_construct.gd"

const ExpressionStatementNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/expression_statement.gd")

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

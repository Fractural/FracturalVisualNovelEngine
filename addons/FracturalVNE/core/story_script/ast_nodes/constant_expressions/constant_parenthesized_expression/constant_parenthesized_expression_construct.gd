extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/parenthesized_expression/parenthesized_expression_construct.gd"


const ConstantParenthesizedExpression = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/constant_parenthesized_expression/constant_parenthesized_expression.gd")


# Parenthesized expression construct already implements get_punctuation
# to get the open and closed parenthesis

# Since we cannot extend from both parenthesized component and constant value component,
# we must then manually add the parse type for constant value component. (Since only
# "value component" and "parenthesized experssion" are automatically handled by 
# "parenthesized_expression_construct.gd").
func get_parse_types():
	var arr = .get_parse_types()
	arr.append_array(["constant parenthesized expression", "constant value component"])
	return arr

# Override parse to only handle constant expressions
func parse(parser):
	var checkpoint = parser.save_reader_state()
	var open_paren = parser.expect_token("punctuation", "(")
	if parser.is_success(open_paren):
		var expression = parser.expect("constant expression")
		if not parser.is_success(expression):
			return parser.error(expression, 1, checkpoint)
		
		var closing_paren = parser.expect_token("punctuation", ")")
		if not parser.is_success(closing_paren):
			return parser.error('Expected a ")" to close a parenthesized expression.', 1, checkpoint) 
		
		return ConstantParenthesizedExpression.new(expression.position, expression)
	else:
		return open_paren

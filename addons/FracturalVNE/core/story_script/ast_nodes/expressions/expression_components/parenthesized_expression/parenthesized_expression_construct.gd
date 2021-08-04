extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_components/value_component/value_component_construct.gd"
# Parses a ParentehsizedExpression.


const ParenthesizedExpression = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/parenthesized_expression/parenthesized_expression.gd")


func get_punctuation():
	return ["(", ")"]


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("parenthesized expression")
	return arr


func parse(parser):
	var checkpoint = parser.save_reader_state()
	var open_paren = parser.expect_token("punctuation", "(")
	if parser.is_success(open_paren):
		var expression = parser.expect("expression")
		if not parser.is_success(expression):
			return parser.error(expression, 1, checkpoint)
		
		var closing_paren = parser.expect_token("punctuation", ")")
		if not parser.is_success(closing_paren):
			return parser.error('Expected a ")" to close a parenthesized expression.', 1, checkpoint) 
		
		return ParenthesizedExpression.new(expression.position, expression)
	else:
		return open_paren

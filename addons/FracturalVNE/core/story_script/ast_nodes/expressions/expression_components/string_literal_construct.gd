extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/literal_construct.gd"

const StringLiteralNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/string_literal.gd")

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("string literal")
	return arr

func parse(parser):
	if parser.peek().type == "string":
		var literal = parser.consume()
		return StringLiteralNode.new(literal.position, literal.symbol)
	return parser.error("Expected a string literal.")

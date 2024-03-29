extends "res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/literals/literal/literal_construct.gd"
# Parses an IntegerLiteral.


const IntegerLiteralNode = preload("integer_literal.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("IntegerLiteral")
	return arr


func parse(parser):
	if parser.peek().type == "integer":
		var literal = parser.consume()
		return IntegerLiteralNode.new(literal.position, literal.symbol)
	return parser.error("Expected an integer literal.")

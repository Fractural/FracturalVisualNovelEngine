extends "res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/literals/literal/literal_construct.gd"
# Parses a BoolLiteral.


const BoolLiteralNode = preload("bool_literal.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("BoolLiteral")
	return arr


func parse(parser):
	if parser.peek().type == "bool":
		var literal = parser.consume()
		return BoolLiteralNode.new(literal.position, literal.symbol)
	return parser.error("Expected a bool literal.")

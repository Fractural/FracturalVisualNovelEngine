extends "res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/literals/literal/literal_construct.gd"
# Parses a StringLiteral.


const StringLiteralNode = preload("string_literal.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("string literal")
	return arr


func parse(parser):
	if parser.peek().type == "string":
		var literal = parser.consume()
		return StringLiteralNode.new(literal.position, literal.symbol)
	return parser.error("Expected a string literal.")

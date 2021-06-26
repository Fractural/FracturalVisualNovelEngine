extends "res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/literals/literal/literal_construct.gd"


const FloatLiteralNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/literals/float_literal/float_literal.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("float literal")
	return arr


func parse(parser):
	if parser.peek().type == "float":
		var literal = parser.consume()
		return FloatLiteralNode.new(literal.position, literal.symbol)
	return parser.error("Expected a float literal.")

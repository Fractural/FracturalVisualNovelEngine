extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_components/value_component/value_component_construct.gd"
# Parses a VariableNode.


const VariableNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/variable/variable.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("VariableNode")
	return arr


func parse(parser):
	var identifier = parser.expect_token("identifier")
	if parser.is_success(identifier):
		return VariableNode.new(identifier.position, identifier.symbol)
	return identifier

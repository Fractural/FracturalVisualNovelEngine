extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/literal_parser.gd"

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("float literal")
	return arr

func parse(parser):
	if parser.peek().type == "float":
		return FloatLiteralNode.new(parser.consume().symbol)
	return parser.error("Expected a float literal.")

class FloatLiteralNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/expression_component.gd":
	var value: int
	
	func _init(value_: int):
		value = value_
	
	func evaluate(runtime_manager):
		return value

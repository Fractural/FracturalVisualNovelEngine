extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/literal_construct.gd"

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("string literal")
	return arr

func parse(parser):
	if parser.peek().type == "string":
		return StringLiteralNode.new(parser.consume().symbol)
	return parser.error("Expected a string literal.")

class StringLiteralNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_component.gd":
	var value: String
	
	func _init(value_: String):
		value = value_
		
	func evaluate(runtime_manager):
		return value
	
	func debug_string(tabs_string) -> String:
		return tabs_string + "STR: " + value

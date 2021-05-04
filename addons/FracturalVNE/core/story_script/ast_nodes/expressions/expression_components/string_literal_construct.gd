extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/literal_construct.gd"

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("string literal")
	return arr

func parse(parser):
	if parser.peek().type == "string":
		var literal = parser.consume()
		return StringLiteralNode.new(literal.position, literal.symbol)
	return parser.error("Expected a string literal.")

class StringLiteralNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_component.gd":
	static func get_types():
		var arr = .get_types()
		arr.append("string literal")
		return arr
	
	var value: String
	
	func _init(position_, value_: String).(position_):
		value = value_
		
	func evaluate():
		return value
	
	func debug_string(tabs_string) -> String:
		return tabs_string + "STR: " + value
	
	func get_return_type() -> String:
		return "string"

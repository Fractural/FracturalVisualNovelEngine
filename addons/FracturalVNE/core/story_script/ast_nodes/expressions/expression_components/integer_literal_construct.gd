extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/literal_construct.gd"

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("integer literal")
	return arr

func parse(parser):
	if parser.peek().type == "integer":
		var literal = parser.consume()
		return IntegerLiteralNode.new(literal.position, literal.symbol)
	return parser.error("Expected an integer literal.")

class IntegerLiteralNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_component.gd":
	var value: int
	
	func _init(position_, value_: int).(position_):
		value = value_
	
	func evaluate(runtime_manager):
		return value
		
	func debug_string(tabs_string) -> String:
		return tabs_string + "INT: " + str(value)
	
	func get_return_type() -> String:
		return "integer"

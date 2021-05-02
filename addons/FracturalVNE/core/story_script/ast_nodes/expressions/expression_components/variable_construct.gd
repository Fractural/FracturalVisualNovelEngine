extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_component_construct.gd"

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("variable")
	return arr

func parse(parser):
	var ahead = str(parser.peek().symbol) + str(parser.peek(2).symbol) + str(parser.peek(3).symbol)
	var identifier = parser.expect_token("identifier")
	if parser.is_success(identifier):
		return VariableNode.new(identifier.symbol)
	return identifier

class VariableNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_component.gd":
	var name: String
	
	func _init(name_: String):
		name = name_
	
	func evaluate(runtime_manager):
		runtime_manager.get_variable(name)
	
	func debug_string(tabs_string: String) -> String:
		return tabs_string + "VAR: " + name

extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_component_construct.gd"

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("variable")
	return arr

func parse(parser):
	var ahead = str(parser.peek().symbol) + str(parser.peek(2).symbol) + str(parser.peek(3).symbol)
	var identifier = parser.expect_token("identifier")
	if parser.is_success(identifier):
		return VariableNode.new(identifier.position, identifier.symbol)
	return identifier

class VariableNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_component.gd":
	var name: String
	
	func _init(position_, name_: String).(position_):
		name = name_
	
	func evaluate():
		var variable = runtime_block.get_variable(name)
		if is_success(variable):
			return variable.value
		return adopt_error(variable)
	
	func debug_string(tabs_string: String) -> String:
		return tabs_string + "VAR: " + name

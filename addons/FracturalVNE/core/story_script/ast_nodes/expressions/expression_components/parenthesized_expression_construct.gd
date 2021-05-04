extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_component_construct.gd"

func get_punctuation():
	return ["(", ")"]

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("parenthesized expression")
	return arr

func parse(parser):
	var checkpoint = parser.save_reader_state()
	var open_paren = parser.expect_token("punctuation", "(")
	if parser.is_success(open_paren):
		var expression = parser.expect("expression")
		if not parser.is_success(expression):
			return parser.error(expression, 1, checkpoint)
		
		var closing_paren = parser.expect_token("punctuation", ")")
		if not parser.is_success(closing_paren):
			return parser.error('Expected a ")" to close a parenthesized expression.', 1, checkpoint) 
		
		return ParenthesizedOperator.new(expression.position, expression)
	else:
		return open_paren

class ParenthesizedOperator extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/operator.gd":
	var operand
	
	func _init(position_, operand_).(position_):
		operand = operand_
	
	func evaluate():
		return operand.evaluate()
	
	func debug_string(tabs_string: String) -> String:
		var string = ""
		string += tabs_string + "PARENTHESES GROUP:"
		string += "\n" + tabs_string + "{"
		string += "\n" + operand.debug_string(tabs_string + "\t")
		string += "\n" + tabs_string + "}"
		return string
	
	func propagate_call(method, arguments, parent_first = false):
		if parent_first:
			.propagate_call(method, arguments, parent_first)
		
		operand.propagate_call(method, arguments, parent_first)
		
		if not parent_first:
			.propagate_call(method, arguments, parent_first)

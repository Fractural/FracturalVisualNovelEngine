extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node_construct.gd"

func get_punctuation():
	return ["(", ",", ")"]

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("parenthesized parameters")
	return arr

func parse(parser):
	var checkpoint = parser.save_reader_state()
	
	var parameters = []
	
	var ahead = str(parser.peek().symbol) + str(parser.peek(2).symbol) + str(parser.peek(3).symbol)
	
	var open_paren = parser.expect_token("punctuation", "(")
	if parser.is_success(open_paren):
		while true:
			if parser.is_EOF():
				return parser.error('Expected a ")" to close a parenthesized parameter group but reached the end of the file.', 1, checkpoint)
			
			var arg_name = null
			
			var arg_identifier = parser.expect_token("identifier")
			if parser.is_success(arg_identifier):
				if parser.is_success(parser.expect_token("punctuation", "=")):
					var literal = parser.expect("literal")
					if parser.is_success(literal):
						parameters.append(StoryScriptParameter.new(arg_identifier.symbol, literal.evaluate()))
					else:
						return parser.error(literal, 1, checkpoint)
				else:
					parameters.append(StoryScriptParameter.new(arg_identifier.symbol))
			else:
				return parser.error(arg_identifier, 1, checkpoint)
			
			if parser.is_success(parser.expect_token("punctuation", ",")):
				pass
			elif parser.is_success(parser.expect_token("punctuation", ")")):
				break
			else:
				return parser.error('Expected a "," or a ")" after a parameter.', 1, checkpoint)
		return ParameterGroupNode.new(open_paren.position, parameters)
	else:
		return open_paren

class ParameterGroupNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node.gd":
	var parameters: Array
	
	func _init(position_, parameters_: Array).(position_):
		parameters = parameters_
	
	func debug_string(tabs_string: String) -> String:
		var string = ""
		string += tabs_string + "PARAM GROUP :" 
		string += "\n" + tabs_string + "{"
		for param in parameters:
			string += "\n" + tabs_string + "\t" + str(param) + ","
		string += "\n" + tabs_string + "}"
		return string

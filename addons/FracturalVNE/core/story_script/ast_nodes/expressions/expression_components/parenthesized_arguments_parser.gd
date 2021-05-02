extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_component_parser.gd"

func get_punctuation():
	return ["(", ",", ")", "="]

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("parenthesized arguments")
	return arr

func parse(parser):
	var checkpoint = parser.save_reader_state()
	
	var arguments = []
	
	var open_paren = parser.expect_token("punctuation", "(")
	if parser.is_success(open_paren):
		while true:
			if parser.is_EOF():
				return parser.error('Expected a ")" to close a parenthesized argument group but reached the end of the file.', 1, checkpoint)
			
			var arg_identifier = parser.expect_token("identifier")
			if parser.is_success(arg_identifier):
				if not parser.is_success(parser.expect_token("punctuation", "=")):
					return parser.error('Expected a "=" after an argument identifier.', 1, checkpoint)
			
			var expression = parser.expect("expression")
			if not parser.is_success(expression):
				return parser.error(expression, 1, checkpoint)
			
			arguments.append(ArgumentNode.new(arg_identifier, expression))
			
			if parser.is_success(parser.expect_token("punctuation", ",")):
				pass
			elif parser.is_success(parser.expect_token("punctuation", ")")):
				break
			else:
				return parser.error('Expected a "," or a ")" after a argument.', 1, checkpoint)
		return ArgumentGroupNode.new(arguments)
	else:
		return open_paren

class ArgumentGroupNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node.gd":
	var arguments: Array
	
	func _init(arguments_: Array):
		arguments = arguments_
	
	func debug_string(tabs_string: String):
		var string = ""
		string += tabs_string + "ARG GROUP :" 
		string += "\n" + tabs_string + "{"
		for argument in arguments:
			string += "\n" + argument.debug_string(tabs_string + "\t")
		string += "\n" + tabs_string + "}"

class ArgumentNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node.gd":
	var name: String
	var value
	
	func _init(name_: String, value_):
		name = name_
		value = value_
	
	func debug_string(tabs_string: String):
		var string = ""
		string += indent_string + "ARG " + name + " : " + str(value_) 

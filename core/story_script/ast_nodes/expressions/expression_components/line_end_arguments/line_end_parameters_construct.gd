extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node/node_construct.gd"
# Parses a group of ParenthesizedParameters.


const ArgumentNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/parenthesized_arguments/argument.gd")
const ArgumentGroupNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/parenthesized_arguments/argument_group.gd")


func get_punctuation():
	return [",", "="]


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("LineEndArgumentGroup")
	return arr


func parse(parser):
	var checkpoint = parser.save_reader_state()
	
	var arguments = []
	var named_arguments = []
	
	var position
	var newline = parser.expect_token("punctuation", "newline")
	if not parser.is_success(newline):
		var first_arg: bool = true
		while true:
			if parser.is_EOF():
				return parser.error('Expected a new line to close a line end argument group but reached the end of the file.', 1, checkpoint)
			
			var checkpoint2 = parser.save_reader_state()
			var arg_name = null
			
			var arg_identifier = parser.expect_token("identifier")
			if parser.is_success(arg_identifier):
				if parser.is_success(parser.expect_token("punctuation", "=")):
					if named_arguments.has(arg_identifier.symbol):
						return parser.error('Argument with the name "%s" already exists.' % arg_identifier.symbol, 1, checkpoint)
					named_arguments.append(arg_identifier.symbol)
					arg_name = arg_identifier.symbol
				else:
					# We only allow named arguments for line end argument groups
					return parser.error('Expected a "=" after an argument name for line end argument group')
			
			var expression = parser.expect("Expression")
			if not parser.is_success(expression):
				return parser.error(expression, 1, checkpoint)
			
			# We will use the first argument's position as the position
			# of the line end argument group.
			if first_arg:
				first_arg = false
				position = arg_identifier.position
			
			arguments.append(ArgumentNode.new(expression.position, arg_name, expression))
			
			if parser.is_success(parser.expect_token("punctuation", ",")):
				pass
			elif parser.is_success(parser.expect_token("punctuation", "newline")):
				break
			else:
				return parser.error('Expected a "," or a newline after an argument.', 1, checkpoint)
	else:
		position = newline.position
	return ArgumentGroupNode.new(position, arguments)

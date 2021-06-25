extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node_construct.gd"

const ArgumentNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/argument.gd")
const ArgumentGroupNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/argument_group.gd")

func get_punctuation():
	return ["(", ",", ")", "="]

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("parenthesized arguments")
	return arr

func parse(parser):
	var checkpoint = parser.save_reader_state()
	
	var arguments = []
	var named_arguments = []
	
	var open_paren = parser.expect_token("punctuation", "(")
	if parser.is_success(open_paren):
		if parser.is_success(parser.expect_token("punctuation", ")")):
			pass
		else:
			while true:
				if parser.is_EOF():
					return parser.error('Expected a ")" to close a parenthesized argument group but reached the end of the file.', 1, checkpoint)
				
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
						# Identifier may be interpreted as a variable, so we have to
						# revert the parser state back so that expect("expression") 
						# can pickup the identifier since it could be a variable
						parser.load_reader_state(checkpoint2)
				
				var expression = parser.expect("expression")
				if not parser.is_success(expression):
					return parser.error(expression, 1, checkpoint)
				
				arguments.append(ArgumentNode.new(expression.position, arg_name, expression))
				
				if parser.is_success(parser.expect_token("punctuation", ",")):
					pass
				elif parser.is_success(parser.expect_token("punctuation", ")")):
					break
				else:
					return parser.error('Expected a "," or a ")" after a argument.', 1, checkpoint)
		return ArgumentGroupNode.new(open_paren.position, arguments)
	else:
		return open_paren

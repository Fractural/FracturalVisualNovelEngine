#class_name StoryScriptParser
#extends Reference
#
#const EOF = "EOF"
#
## Token Types
#const TT_IDENTIFIER = "IDENTIFIER"
#const TT_INT = "INT"
#const TT_FLOAT = "FLOAT"
#const TT_STRING = "STRING"
#const TT_OPEN_PARENTHESIS = "("
#const TT_CLOSED_PARENTHESIS = ")"
#const TT_COMMA = ","
#const TT_COLON = ":"
#const TT_INDENT = "INDENT"
#const TT_ASSIGNMENT = "="
#
## Operators
#
## Binary Operators
#const TT_EQUALS = "=="
#const TT_NOT_EQUALS = "!="
#const TT_PLUS = "+"
#const TT_MINUS = "-"
#const TT_MULTIPLY = "*"
#const TT_DIVIDE = "/"
#const TT_MODULUS = "%"
#const TT_GREATER_THAN = ">"
#const TT_LESS_THAN = "<"
#const TT_GREATER_THAN_OR_EQUALS = ">="
#const TT_LESS_THAN_OR_EQUALS = "<="
#const TT_AND = "and"
#const TT_OR = "or"
#
#var BINARY_OPERATOR_PRECEDENCE = {
#	TT_OR : 1,
#	TT_AND : 2,
#	TT_GREATER_THAN : 3, TT_LESS_THAN : 3, TT_GREATER_THAN_OR_EQUALS : 3, TT_LESS_THAN_OR_EQUALS : 3, TT_EQUALS : 3, TT_NOT_EQUALS : 3,
#	TT_PLUS : 4, TT_MINUS : 4,
#	TT_MULTIPLY : 5, TT_DIVIDE : 5, TT_MODULUS : 5,
#}
#
## Unary Operators
#const TT_NOT = "not"
#const TT_NEGATIVE = "-"
#
## Keyword Token Types
#const TT_DEFINE = "define"
#const TT_LABEL = "label"
#const TT_JUMP = "jump"
#const TT_IF = "if"
#const TT_ELSE = "else"
#const TT_ELIF = "elif"
#const TT_MENU = "menu"
#
#var reader: StoryScriptTokensReader
#
#func generate_abstract_syntax_tree(reader_: StoryScriptTokensReader):
#	reader = reader_
#	var result = parse_block(0)
#	if result is StoryScriptError:
#		return result
#
#	return result
#
#func is_literal(current_token: StoryScriptToken) -> bool:
#	return current_token.type == TT_INT or current_token.type == TT_FLOAT or current_token.type == TT_STRING
#
#func parse_literal():
#	var token = reader.consume()
#	return StoryScriptASTNode.new(token.type, [StoryScriptASTNode.new(token.symbol)])
#
#func parse_block(indent_level: int):
#	var node = StoryScriptASTNode.new("block")
#	var result = null
#	while true: 
#		if reader.is_EOF():
#			break
#
#		if reader.peek().type == TT_INDENT:
#			# Stop parsing block if we reached a smaller indent level
#			if reader.peek().symbol < indent_level:
#				break
#			elif reader.peek().symbol > indent_level:
#				# Should never happen normally, since new blocks are handled by custom keywords
#				# ie. parse_label already parses the block that a label uses
#				return error("Unexpected indentation.", reader.peek().position)
#		elif is_literal(reader.peek()):
#			result = parse_literal()
#		elif reader.peek().type == TT_DEFINE:
#			result = parse_definition()
#		elif reader.peek().type == TT_LABEL:
#			result = parse_label(indent_level)
#		elif reader.peek().type == TT_JUMP:
#			result = parse_jump()
#		else:
#			result = error("Unexpected token.", reader.peek().position)
#
#		if result is StoryScriptError:
#			return result
#		node.add_child(result)
#	# TODO: Finish parsing tokens
#	return node
#
#func parse_label(previous_indent: int):
#	# If we are here, then we already know that the current text is a label, so we can consume it
#	reader.consume()
#	if reader.peek().type == TT_IDENTIFIER:
#		var identifier = reader.consume()
#		if reader.peek().type == TT_COLON:
#			reader.consume()
#			if reader.peek().type == TT_INDENT:
#				var indent = reader.consume()
#				if indent > previous_indent:
#					var result = parse_block(indent.symbol)
#					if result is StoryScriptError:
#						return result
#
#					return StoryScriptASTNode.new("label", [
#						StoryScriptASTNode.new("identifier", [StoryScriptASTNode.new(identifier.symbol)]),
#						result])
#				else:
#					return error('Label statement blocks must be indented once relative to the block that it is in.')
#			else:
#				return error('Expected an indented block after label statement.')
#		else:
#			return error('Expected a ":" after identifier.')
#	else:
#		return error('Expected an identifier after "label"')
#
#func delimited(start, stop, separator, parser: FuncRef):
#	var a = []
#	var first = true;
#
#	if reader.peek().type != start:
#		return error('Expected a start symbol "%s"' % start)
#	reader.consume()
#
#	while true:
#		if reader.peek().type == stop:
#			break
#
#		# First argument has no delimiter infront of it, therefore skip
#		# adding a delimiter for the first argument
#		if first:
#			first = false 
#		else:
#			if reader.peek().type != separator:
#				return error('Expected a separator "%s"' % separator)
#			reader.consume()
#		# The last separator can be missing
#		if reader.peek().type == stop:
#			break
#
#		var result = parser.call_func()
#		if result is StoryScriptError:
#			return result
#		a.push(result)
#
#	if reader.peek().type != stop:
#		return error('Expected a stop symbol "%s"' % stop)
#	reader.consume()
#
#	return a;
#
#func parse_definition():
#	reader.consume()
#	if reader.peek() == TT_IDENTIFIER:
#		var identifier = reader.consume()
#		if reader.peek() == TT_ASSIGNMENT:
#			reader.consume()
#			if is_class_type(reader.peek()):
#				var identifier_type = reader.consume()
#
#				var parser_func = FuncRef.new()
#				parser_func.set_function("parse_expression")
#				parser_func.set_instance(self)
#
#				var result = delimited(TT_OPEN_PARENTHESIS, TT_CLOSED_PARENTHESIS, TT_COMMA, parser_func)
#				if result is StoryScriptError:
#					return result
#
#				return StoryScriptASTNode.new("definition", [
#					StoryScriptASTNode.new("type", [StoryScriptASTNode.new(identifier_type.type)]),
#					StoryScriptASTNode.new("identifier", [StoryScriptASTNode.new(identifier.symbol)]),
#					StoryScriptASTNode.new("args", result)
#					])
#			else:
#				return error('Expected a class type after "=".')
#		else:
#			return error('Expected a "=" after identifier.')
#	else:
#		return error('Expected an identifier after "define".')
#
#func parse_jump():
#	reader.consume()
#	if reader.peek().type == TT_IDENTIFIER:
#		var identifier = reader.consume()
#
#		return StoryScriptASTNode.new("jump", [
#			StoryScriptASTNode.new("identifier", [StoryScriptASTNode.new(identifier.symbol)])
#			])
#	else:
#		return error('Expected an identifier after "jump".')
#
## TODO: Add PEMDAS using shunting yard algorithm
## See: https://stackoverflow.com/questions/28256/equation-expression-parser-with-precedence
## For now, assums we are parsing just literals
#func parse_expression():
#	var node = StoryScriptASTNode.new("expression")
#	while is_expression_token(reader.peek()):
#		if reader.isEOF():
#			break
#
#		var result = parse_atom()
#		if result is StoryScriptError:
#			return result
#
#		node.add_child(result)	
#	return node
#
#func parse_atom():
#	if reader.peek().type == TT_OPEN_PARENTHESIS:
#		reader.consume()
#		var result = parse_expression()
#		if result is StoryScriptError:
#			return result
#		if reader.peek().type == TT_CLOSED_PARENTHESIS:
#			return result
#		else:
#			return error('Expected stop symbol ")"')
#
#	# Unary Operatorst
#	if reader.peek().type == TT_NOT:
#		reader.consume()
#		var result = parse_atom()
#		if result is StoryScriptError:
#			return result
#		return StoryScriptASTNode.new("not", [StoryScriptASTNode.new("body", result)])
#
#	var result
#	if reader.peek().type == TT_IF:
#		result = parse_if()
#	elif is_bool(reader.peek()):
#		result = parse_bool()
#	elif is_literal(reader.peek()) or reader.peek().type == TT_IDENTIFIER:
#		var token = reader.consume()
#		return StoryScriptASTNode.new(token.type, [StoryScriptASTNode.new(token.symbol)])
#	else:
#		result = error("Unexpected atom.")
#	return result
#
#func is_bool(token: StoryScriptToken):
#	return token.type == TT_TRUE or token.type == TT_FALSE
#
#func is_expression_token(token: StoryScriptToken):
#	return is_literal(token) or token.type == TT_IDENTIFIER
#
#func is_class_type(keyword):
#	return keyword == "Character" or keyword == "Sprite"
#
#func error(message: String, position: StoryScriptToken.Position = reader.peek().position) -> StoryScriptError:
#	return StoryScriptError.new(message, position)

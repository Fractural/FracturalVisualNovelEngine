#class_name StoryScriptParser
#extends Reference
#
#const EOF = "EOF"
#
## Variable
#const TT_VARIABLE = "VARIABLE"
#
## Keywords
#const TT_KEYWORD = "KEYWORD"
#
#const KW_TRUE = "true"
#const KW_FALSE = "false"
#const KW_DEFINE = "define"
#const KW_LABEL = "label"
#const KW_JUMP = "jump"
#const KW_IF = "if"
#const KW_ELSE = "else"
#const KW_ELIF = "elif"
#const KW_MENU = "menu"
#
#var ALL_KEYWORDS = [
#	KW_DEFINE,
#	KW_LABEL,
#	KW_JUMP,
#	KW_IF,
#	KW_ELSE,
#	KW_ELIF,
#	KW_MENU,
#]
#
## Literals
#const TT_INT = "INT"
#const TT_FLOAT = "FLOAT"
#const TT_STRING = "STRING"
#
#var ALL_LITERALS = [
#	TT_INT,
#	TT_FLOAT,
#	TT_STRING,
#]
#
## Punctuation
#const TT_PUNCTUATION = "PUNCTUATION"
#
#const PUNC_OPEN_PARENTHESIS = "("
#const PUNC_CLOSED_PARENTHESIS = ")"
#const PUNC_COMMA = ","
#const PUNC_COLON = ":"
#const PUNC_INDENT = "INDENT"
#const PUNC_DEDENT = "DEDENT"
#
#var ALL_PUNCTUATION = [
#	PUNC_OPEN_PARENTHESIS,
#	PUNC_CLOSED_PARENTHESIS,
#	PUNC_COMMA,
#	PUNC_COLON,
#	PUNC_INDENT,
#	PUNC_DEDENT,
#]
#
## Operators
#const TT_OPERATOR = "OPERATOR"
#
## Binary Operators
#const OP_ASSIGN = "="
#const OP_EQUALS = "=="
#const OP_NOT_EQUALS = "!="
#const OP_PLUS = "+"
#const OP_MINUS = "-"
#const OP_MULTIPLY = "*"
#const OP_DIVIDE = "/"
#const OP_MODULUS = "%"
#const OP_GREATER_THAN = ">"
#const OP_LESS_THAN = "<"
#const OP_GREATER_THAN_OR_EQUALS = ">="
#const OP_LESS_THAN_OR_EQUALS = "<="
#const OP_AND = "and"
#const OP_OR = "or"
#
#var BINARY_OPERATOR_PRECEDENCE = {
#	OP_OR : 1,
#	OP_AND : 2,
#	OP_GREATER_THAN : 3, OP_LESS_THAN : 3, OP_GREATER_THAN_OR_EQUALS : 3, OP_LESS_THAN_OR_EQUALS : 3, OP_EQUALS : 3, OP_NOT_EQUALS : 3,
#	OP_PLUS : 4, OP_MINUS : 4,
#	OP_MULTIPLY : 5, OP_DIVIDE : 5, OP_MODULUS : 5,
#}
#
## Unary Operators
#const OP_NOT = "not"
#const OP_NEGATIVE = "-"
#
#var ALL_OPERATORS = [
#	# Binary
#	OP_ASSIGN,
#	OP_EQUALS,
#	OP_NOT_EQUALS,
#	OP_PLUS,
#	OP_MINUS,
#	OP_MULTIPLY,
#	OP_DIVIDE,
#	OP_MODULUS,
#	OP_GREATER_THAN,
#	OP_LESS_THAN,
#	OP_GREATER_THAN_OR_EQUALS,
#	OP_LESS_THAN_OR_EQUALS,
#	OP_AND,
#	OP_OR,
#	# Unary
#	OP_NOT,
#	OP_NEGATIVE,
#]
#
#var reader: StoryScriptTokensReader
#
#func generate_abstract_syntax_tree(reader_: StoryScriptTokensReader):
#	reader = reader_
#	return parse_top_level()
#
#func is_keyword(token: StoryScriptToken, keyword: String = ""):
#	if keyword != "":
#		return token.type == TT_KEYWORD and keyword == token.symbol
#	return token.type == TT_KEYWORD
#
#func is_operator(token: StoryScriptToken, operator: String = ""):
#	if operator != "":
#		return token.type == TT_OPERATOR and operator == token.symbol
#	return token.type == TT_OPERATOR
#
#func is_punctuation(token: StoryScriptToken, punctuation: String = ""):
#	if punctuation != "":
#		return token.type == TT_PUNCTUATION and punctuation == token.symbol
#	return token.type == TT_PUNCTUATION
#
#func peek_is_keyword(keyword: String):
#	return is_keyword(reader.peek(), keyword)
#
#func peek_is_operator(operator: String):
#	return is_operator(reader.peek(), operator)
#
#func peek_is_punctuation(punctuation: String):
#	return is_punctuation(reader.peek(), punctuation)
#
#func is_literal(current_token: StoryScriptToken) -> bool:
#	return current_token.type == TT_INT or current_token.type == TT_FLOAT or current_token.type == TT_STRING
#
#func delimited(start, stop, separator, parser: FuncRef):
#	var a = []
#	var first = true;
#
#	if reader.peek().symbol != start:
#		return error('Expected a start symbol "%s"' % start)
#	reader.consume()
#
#	while true:
#		if reader.peek().symbol == stop:
#			break
#
#		# First argument has no delimiter infront of it, therefore skip
#		# adding a delimiter for the first argument
#		if first:
#			first = false 
#		else:
#			if reader.peek().symbol != separator:
#				return error('Expected a separator "%s"' % separator)
#			reader.consume()
#		# The last separator can be missing
#		if reader.peek().symbol == stop:
#			break
#
#		var result = parser.call_func()
#		if result is StoryScriptError:
#			return result
#		a.push(result)
#
#	if reader.peek().symbol != stop:
#		return error('Expected a stop symbol "%s"' % stop)
#	reader.consume()
#
#	return a;
#
#func parse_top_level():
#	var program = []
#	while not reader.is_EOF():
#		var result = parse_expression()
#		if result is StoryScriptError:
#			return result
#		program.append(result)
#
#	return { 
#		"type": "prog", 
#		"prog": program
#		}
#
#func parse
#
#func parse_if():
#	reader.consume()
#	var condition = parse_expression()	
#	if condition is StoryScriptError:
#		return condition
#	if peek_is_punctuation(PUNC_COLON):
#		reader.consume()
#		var then = parse_expression()
#		if then is StoryScriptError:
#			return then
#		var ret = {
#			"type": "if",
#			"cond": condition,
#			"then": then
#		}
#		if peek_is_keyword(KW_ELSE):
#			reader.consume()
#			var else_expression = parse_expression()
#			if else_expression is StoryScriptError:
#				return else_expression
#			ret["else"] = else_expression
#		return ret
#
#class IfStatement:
#	static func get_type():
#		return "if"
#	var 
#
#func parse_bool():
#	return { "type": "bool", "value": reader.consume().value == "true"}
#
#class BinaryOperation:
#	static func get_type():
#		return "binary"
#	var operator: String
#	var left
#	var right
#
#	func _init(operator_: String, left_, right_):
#		operator = operator_
#		left = left_
#		right = right_
#
#func parse_atom():
#	if peek_is_punctuation(PUNC_OPEN_PARENTHESIS):
#		reader.consume()
#		var result = parse_expression()
#		if result is StoryScriptError:
#			return result
#		if peek_is_punctuation(PUNC_CLOSED_PARENTHESIS):
#			return result
#		else:
#			return error('Expected stop symbol ")"')
#
#	# Unary Operatorst
#	if peek_is_operator(OP_NOT):
#		reader.consume()
#		var result = parse_atom()
#		if result is StoryScriptError:
#			return result
#		return { "type": "not", "body": result }
#
#	var result
#	if peek_is_keyword(KW_IF):
#		result = parse_if()
#	# TODO: Add other keywords (like "jump", "label", etc)
#	elif peek_is_keyword(KW_TRUE) or peek_is_keyword(KW_FALSE):
#		result = parse_bool()
#	elif is_literal(reader.peek()) or reader.peek().type == TT_VARIABLE:
#		var token = reader.consume()
#		return StoryScriptASTNode.new(token.type, [StoryScriptASTNode.new(token.symbol)])
#	else:
#		result = error("Unexpected atom.")
#	return result
#
#func parse_expression():
#	var atom_result = parse_atom()
#	if atom_result is StoryScriptError:
#		return atom_result
#	return maybe_parse_binary(atom_result, 0)
#
## Custom keyword parsing
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
#func is_class_type(keyword):
#	return keyword == "Character" or keyword == "Sprite"
#
#func error(message: String, position: StoryScriptToken.Position = reader.peek().position) -> StoryScriptError:
#	return StoryScriptError.new(message, position)

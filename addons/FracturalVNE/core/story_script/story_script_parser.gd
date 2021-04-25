class_name StoryScriptParser
extends Reference
 
const EOF = "EOF"















# Token Types and Symbols

# Identifier
const TT_IDENTIFIER = "IDENTIFIER"

# Keywords
const TT_KEYWORD = "KEYWORD"

# TODO FUTURE: Implement more keywords
# TODO NOW: Implement current keywords

const KW_TRUE = 'true'
const KW_FALSE = 'false'
const KW_IF = 'if'
const KW_ELSE = 'else'
const KW_ELIF = 'elif'

const KW_DEFINE = 'define'
#const KW_AS = 'as'
const KW_AT = 'at'
#const KW_ANIMATE = 'animate'
#const KW_BEHIND = 'behind'
#const KW_CALL = 'call'
#const KW_EXPRESSION = 'expression'
const KW_HIDE = 'hide'
const KW_IMAGE = 'image'
#const KW_INIT = 'init'
const KW_JUMP = 'jump'
const KW_LABEL = 'label'
const KW_MENU = 'menu'
const KW_PAUSE = 'pause'

#const KW_ONLAYER = 'onlayer'
#const KW_PASS = 'pass'
#const KW_GODOT = 'godot'
#const KW_RETURN = 'return'
#const KW_SCENE = 'scene'
#const KW_SET = 'set'
const KW_SHOW = 'show'
const KW_TOGETHER = 'together'
#const KW_WITH = 'with'
#const KW_WHILE = 'while'
#const KW_ZORDER = 'zorder'

var ALL_KEYWORDS = [
	KW_TRUE,
	KW_FALSE,
	KW_IF,
	KW_ELSE,
	KW_ELIF,
	KW_DEFINE,
#	KW_AS,
	KW_AT,
#	KW_ANIMATE,
#	KW_BEHIND,
#	KW_CALL,
#	KW_EXPRESSION,
	KW_HIDE,
	KW_IMAGE,
#	KW_INIT,
	KW_JUMP,
	KW_LABEL,
	KW_MENU,
	KW_PAUSE,
#	KW_ONLAYER,
#	KW_PASS,
#	KW_GODOT,
#	KW_RETURN,
#	KW_SCENE,
#	KW_SET,
	KW_SHOW,
	KW_TOGETHER,
#	KW_WITH,
#	KW_WHILE,
#	KW_ZORDER,
]

# Literals
const TT_INT = "INT"
const TT_FLOAT = "FLOAT"
const TT_STRING = "STRING"

var ALL_LITERALS = [
	TT_INT,
	TT_FLOAT,
	TT_STRING,
]

# Punctuation
const TT_PUNCTUATION = "PUNCTUATION"

const PUNC_OPEN_PARENTHESIS = "("
const PUNC_CLOSED_PARENTHESIS = ")"
const PUNC_COMMA = ","
const PUNC_COLON = ":"
const PUNC_INDENT = "INDENT"
const PUNC_DEDENT = "DEDENT"

var ALL_PUNCTUATION = [
	PUNC_OPEN_PARENTHESIS,
	PUNC_CLOSED_PARENTHESIS,
	PUNC_COMMA,
	PUNC_COLON,
	PUNC_INDENT,
	PUNC_DEDENT,
]

# Operators

const TT_OPERATOR = "OPERATOR"

# Unary Operators
const OP_NOT = "not"
const OP_NEGATIVE = "-"

var ALL_UNARY_OPERATORS = [
	OP_NOT,
	OP_NEGATIVE,
]

# Binary Operators
const OP_ASSIGN = "="
const OP_EQUALS = "=="
const OP_NOT_EQUALS = "!="
const OP_PLUS = "+"
const OP_MINUS = "-"
const OP_MULTIPLY = "*"
const OP_DIVIDE = "/"
const OP_MODULUS = "%"
const OP_GREATER_THAN = ">"
const OP_LESS_THAN = "<"
const OP_GREATER_THAN_OR_EQUALS = ">="
const OP_LESS_THAN_OR_EQUALS = "<="
const OP_AND = "and"
const OP_OR = "or"

var ALL_BINARY_OPERATORS = [
	OP_ASSIGN,
	OP_EQUALS,
	OP_NOT_EQUALS,
	OP_PLUS,
	OP_MINUS,
	OP_MULTIPLY,
	OP_DIVIDE,
	OP_MODULUS,
	OP_GREATER_THAN,
	OP_LESS_THAN,
	OP_GREATER_THAN_OR_EQUALS,
	OP_LESS_THAN_OR_EQUALS,
	OP_AND,
	OP_OR,
]

var BINARY_OPERATOR_PRECEDENCE = {
	# Precedence 0 is reserved for "no operator"
	OP_OR : 1,
	OP_AND : 2,
	OP_GREATER_THAN : 3, OP_LESS_THAN : 3, OP_GREATER_THAN_OR_EQUALS : 3, OP_LESS_THAN_OR_EQUALS : 3, OP_EQUALS : 3, OP_NOT_EQUALS : 3,
	OP_PLUS : 4, OP_MINUS : 4,
	OP_MULTIPLY : 5, OP_DIVIDE : 5, OP_MODULUS : 5,
}

var ALL_OPERATORS = ALL_UNARY_OPERATORS.duplicate().append_array(ALL_BINARY_OPERATORS)















# Statements

enum BuiltinType {
	VOID,
	FLOAT,
	INT,
	STRING,
	VARIABLE,
}

class Type:
	var name: String
	var builtin_type: int
	var fields: Array  #Type[]
	
	func _init(name_: String, builtin_type_: int, fields_ = []):
		name = name_
		builtin_type = builtin_type_
		fields = fields_

enum StatementKind {
	VARIABLE_DECLARATION,
	FUNCTION_CALL,
	LITERAL,
	UNARY_OPERATOR_CALL,
	BINARY_OPERATOR_CALL,
}

const StatementKindStrings = {
	StatementKind.VARIABLE_DECLARATION: "VARIABLE_DECLARATION",
	StatementKind.FUNCTION_CALL: "FUNCTION_CALL",
	StatementKind.LITERAL: "LITERAL",
	StatementKind.UNARY_OPERATOR_CALL: "UNARY_OPERATOR_CALL",
	StatementKind.BINARY_OPERATOR_CALL: "BINARY_OPERATOR_CALL",
}

class Statement:
	var kind: int
	var name
	var return_type: Type
	var parameters: Array # Statement[]
	
	func _init(kind_: int = StatementKind.FUNCTION_CALL, name_ = null, parameters_: Array = [], return_type_: Type = Type.new("void", BuiltinType.VOID)):
		kind = kind_ 
		name = name_
		return_type = return_type_
		parameters = parameters_
	
	func debug_string(indent_level: int) -> String:
		var indented_string = ""
		for i in indent_level:
			indented_string += "\t"
		
		var string = indented_string + StatementKindStrings[kind] + " " + return_type.name + " " + str(name) + " (\n"
		for statement in parameters:
			string += statement.debug_string(indent_level + 1);
		string += indented_string + ")\n";
		
		return string
#
#class Block:
#	var statements: Array # Statement[]
#
#	func _init(statements_: Array):
#		statements = statements_















# Basic Checks

# "is_..." functions check if a given token matches a given check

func is_keyword(token: StoryScriptToken, keyword: String = ""):
	if keyword != "":
		return token.type == TT_KEYWORD and keyword == token.symbol
	return token.type == TT_KEYWORD

func is_operator(token: StoryScriptToken, operator: String = ""):
	if operator != "":
		return token.type == TT_OPERATOR and operator == token.symbol
	return token.type == TT_OPERATOR

func is_unary_operator(token: StoryScriptToken, operator: String = ""):
	return is_operator(token, operator) and ALL_UNARY_OPERATORS.has(operator)

func is_binary_operator(token: StoryScriptToken, operator: String = ""):
	return is_operator(token, operator) and ALL_BINARY_OPERATORS.has(operator)

func is_punctuation(token: StoryScriptToken, punctuation: String = ""):
	var type = str(token.type)
	var symbol = str(token.symbol)
	if punctuation != "":
		return token.type == TT_PUNCTUATION and punctuation == token.symbol
	return token.type == TT_PUNCTUATION

# "peek_is_..." functions check if the next token matches a given check. 
# This does not consume the next token.	

func peek_is_keyword(keyword: String = ""):
	return is_keyword(reader.peek(), keyword)

func peek_is_operator(operator: String = ""):
	return peek_is_unary_operator(operator) or peek_is_binary_operator(operator)

func peek_is_unary_operator(operator: String = ""):
	return is_unary_operator(reader.peek(), operator)

func peek_is_binary_operator(operator: String = ""):
	return is_binary_operator(reader.peek(), operator)

func peek_is_punctuation(punctuation: String = ""):
	return is_punctuation(reader.peek(), punctuation)
	
# "expect_..." functions only consume the next token if the token 
# matches what is expected

func expect_keyword(keyword: String = ""):
	if peek_is_keyword(keyword):
		return reader.consume()
	return error('Expected keyword "%s."' % keyword)

func expect_operator(operator: String = ""):
	if peek_is_operator(operator):
		return reader.consume()
	return error('Expected operator "%s".' % operator)

func expect_unary_operator(operator: String = ""):
	if peek_is_unary_operator(operator):
		return reader.consume()
	return error('Expected unary operator "%s".' % operator)

func expect_binary_operator(operator: String = ""):
	if peek_is_binary_operator(operator):
		return reader.consume()
	return error('Expected binary operator "%s."' % operator)

func expect_punctuation(punctuation: String = ""):
	if peek_is_punctuation(punctuation):
		return reader.consume()
	return error('Expected symbol "%s."' % punctuation)

func expect_identifier():
	if reader.peek().type == TT_IDENTIFIER:
		return reader.consume()
	return error('Expected an identifier.')

func is_literal(current_token: StoryScriptToken) -> bool:
	return ALL_LITERALS.has(current_token.type)

# Checks if an expect statement was successful
func is_success(result):
	return result != null and not result is StoryScriptError















# Core

var reader: StoryScriptTokensReader

func generate_abstract_syntax_tree(reader_: StoryScriptTokensReader):
	reader = reader_
	# TODO: Make lexer add PUNC_INDENT and PUNC_DEDENT to the beginning and end of a file
	return expect_block()

# TODO: Add INDENT and DEDENTs for lexer
func expect_block():
	if is_success(expect_punctuation(PUNC_INDENT)):
		var statements = []
		while not is_success(expect_punctuation(PUNC_DEDENT)):
			# Should normally never happen since the lexer automatically adds 
			# dedents to the end of the program
			if reader.is_EOF():
				return error("Expected a dedent to terminate a block but reached the end of the file.")
			
			var statement = expect_statement()
			if statement is StoryScriptError:
				return statement
			
			statements.append(statement)
		return statements
	else:
		return error("Expected an indent to begin a block.")

func expect_statement():
	# Attempt to parse a statement.
	
	# Each attempts adds their result to the end of "errors".
	# If the last attempt was successful, then the last added attempt is the 
	# result we want so we return that last value.
	
	var errors = []
	
	errors.append(expect_say_statement())
	if errors.back() is Statement:
		return errors.back()
		
	errors.append(expect_label_statement())
	if errors.back() is Statement:
		return errors.back()
	
	errors.append(expect_jump_statement())
	if errors.back() is Statement:
		return errors.back()
	
	errors.append(expect_if_statement())
	if errors.back() is Statement:
		return errors.back()
	
	errors.append(expect_show_statement())
	if errors.back() is Statement:
		return errors.back()
	
	errors.append(expect_hide_statement())
	if errors.back() is Statement:
		return errors.back()
	
	errors.append(expect_menu_statement())
	if errors.back() is Statement:
		return errors.back()
	
	errors.append(expect_together_statement())
	if errors.back() is Statement:
		return errors.back()
	
	errors.append(expect_animate_statement())
	if errors.back() is Statement:
		return errors.back()
	
	errors.append(expect_pause_statement())
	if errors.back() is Statement:
		return errors.back()
	
	errors.append(expect_expression())
	if errors.back() is Statement:
		return errors.back()
	
	errors.append(expect_variable_declaration())
	if errors.back() is Statement:
		return errors.back()
	
	# We know that none of the attempts to parse a statement worked.
	
	# Now we select the error statement with the highest confidence,
	# which should be the most accurate error statement relating to the
	# mistake the user made.
	var closest_error = error("Unexpected statement.", 0)
	for error in errors:
		if error == null:
			continue
		if error.confidence > closest_error.confidence:
			closest_error = error
	
	return closest_error















# Expressions

func expect_expression():
	var start_parse_iter = reader.clone()
	
	# Is the next token a value?
	var lhs = expect_one_expression_component() 
	if lhs is StoryScriptError:
		return lhs
	
	while true:
		var operator = expect_binary_operator()
		if operator is StoryScriptError:
			break;
		
		var rhs_precedence: int = BINARY_OPERATOR_PRECEDENCE[reader.peek()]
		if rhs_precedence == 0:
			# Unconsume the operator
			reader.unconsume()
			return lhs
		
		var rhs = expect_one_expression_component()
		if rhs is StoryScriptError:
			# Unconsume the operator
			reader.unconsume()
			return lhs
			
		var rightmost_statement: Statement = find_rightmost_statement(lhs, rhs_precedence)
		
		var operator_call = Statement.new()
		operator_call.kind = StatementKind.BINARY_OPERATOR_CALL
		operator_call.name = operator.symbol
		
		# [0] is lhs, and [1] is rhs
		if rightmost_statement:
			operator_call.parameters.push_back(rightmost_statement.parameters[1])
			operator_call.parameters.push_back(rhs)
			# Assign rhs of right_most_statement with this operator
			rightmost_statement.parameters[1] = operator_call
		else:
			operator_call.parameters.push_back(lhs)
			operator_call.parameters.push_back(rhs)
			lhs = operator_call
	return lhs

func expect_pre_unary_expression():
	var unary_operator = expect_unary_operator()
	if is_success(unary_operator):
		# Try to parse a unary operator
		
		# Note that this current allows for chaining multiple unary operators in
		# a row. (ie. "!!!!!statement" is a valid expression)
		var one_value = expect_one_expression_component()
		if one_value is StoryScriptError:
			return one_value
		
		var unary_operator_call = Statement.new()
		unary_operator_call.kind = StatementKind.UNARY_OPERATOR_CALL
		unary_operator_call.name = unary_operator.symbol
		unary_operator_call.parameters.push_back(one_value)
		
		return unary_operator_call
	return error("Unary operator not found.")

func expect_post_unary_expression_using(previous_expression):
	var unary_operator = expect_unary_operator()
	if is_success(unary_operator):
		# Try to parse a unary operator
		
		var unary_operator_call = Statement.new()
		unary_operator_call.kind = StatementKind.UNARY_OPERATOR_CALL
		unary_operator_call.name = unary_operator.symbol
		unary_operator_call.parameters.push_back(previous_expression)
		
		return unary_operator_call
	return error("Unary operator not found")

func expect_binary_expression():
	pass

func find_rightmost_statement(lhs: Statement, rhs_precedence: int):
	if lhs.kind != StatementKind.BINARY_OPERATOR_CALL:
		return null
	if operator_precedence(lhs) >= rhs_precedence:
		pass
	pass
	#TODO:

func operator_precedence(operator):
	if BINARY_OPERATOR_PRECEDENCE.has(operator):
		return BINARY_OPERATOR_PRECEDENCE[operator]
	return 0

# An expression component can be one expression, one string, one float, etc.
func expect_one_expression_component():
	var result
	if reader.peek().type == TT_FLOAT:
		var float_literal_statement = Statement.new()
		float_literal_statement.kind = StatementKind.LITERAL
		float_literal_statement.name = reader.peek().symbol
		float_literal_statement.return_type = Type.new("float", BuiltinType.FLOAT) 
		reader.consume()
		result = float_literal_statement
	elif reader.peek().type == TT_INT:
		var integer_literal_statement = Statement.new()
		integer_literal_statement.kind = StatementKind.LITERAL
		integer_literal_statement.name = reader.peek().symbol
		integer_literal_statement.return_type = Type.new("integer", BuiltinType.INT)
		reader.consume()
		result = integer_literal_statement
	elif reader.peek().type == TT_STRING:
		var string_literal_statement = Statement.new()
		string_literal_statement.kind = StatementKind.LITERAL
		string_literal_statement.name = reader.peek().symbol
		string_literal_statement.return_type = Type.new("string", BuiltinType.STRING)
		reader.consume()
		result = string_literal_statement
	elif is_success(expect_punctuation(PUNC_OPEN_PARENTHESIS)):
		result = expect_expression()
		# Only check for missing close parenthesis since result is automatically
		# returned at the end of this function anyways, therefore if result is
		# an error, it will be returned at the end of the function
		if is_success(result) and expect_punctuation(PUNC_CLOSED_PARENTHESIS) is StoryScriptError:
			return error('Unbalanced "(" in parenthesized expression.')
	elif peek_is_unary_operator():
		# Must be a pre-unary operator (ie. the "!" in "!statement")
		return expect_pre_unary_expression()
	
	if result != null and result is Statement:
		if peek_is_unary_operator():
			# Must be a post-unary operator (ie. the "++" in "statement++"
			var post_unary_result = expect_post_unary_expression_using(result) 
			if is_success(post_unary_result):
				return post_unary_result
	
	return result
#	elif result == null or result is StoryScriptError:
#		result = expect_function_call()
	# TODO: Implement function calls
	pass

func expect_variable_declaration():
	var start_parse_iter = reader.clone()
	# Our language will not be typed
	if expect_keyword(KW_DEFINE) is StoryScriptError:
		return error('Expected "define" to start variable declaration.', 1.0/2)
	
	var variable_name = expect_identifier()
	if variable_name is StoryScriptError:
		variable_name.confidence = 2.0/2
		return variable_name
	
	var declaration_statement = Statement.new()
	declaration_statement.kind = StatementKind.VARIABLE_DECLARATION
	declaration_statement.name = variable_name.symbol
	declaration_statement.return_type = Type.new("variable", BuiltinType.VARIABLE)
	
	# Add an initial value to the variable if there is an assignment operator
	if is_success(expect_operator(OP_EQUALS)):
		var initial_value = expect_expression()
		if initial_value is StoryScriptError:
			return error('Expected a valid expression to the right of "=" in variable declaration.', 1)
	
		declaration_statement.parameters.push_back(initial_value)
	
	return declaration_statement















# Statements
# TODO NOW: Implement statements

func expect_say_statement():
	pass

func expect_label_statement():
	 pass

func expect_jump_statement():
	pass

func expect_if_statement():
	pass

func expect_show_statement():
	pass

func expect_hide_statement():
	pass

func expect_menu_statement():
	pass

func expect_animate_statement():
	pass

func expect_together_statement():
	pass

func expect_pause_statement():
	pass














# Error

func error(message: String, confidence: float = 1, position: StoryScriptToken.Position = reader.peek().position) -> StoryScriptError:
	return StoryScriptError.new(message, position, confidence)

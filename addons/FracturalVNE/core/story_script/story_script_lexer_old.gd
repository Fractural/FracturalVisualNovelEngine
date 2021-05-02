tool
#class_name StoryScriptLexer
extends Reference

const EOF = "EOF"















const USE_TABS_INDENT: bool = true
const INDENT_SPACES : int = 4

# Characters
const NEWLINE = '\n'
const SPACE = ' '
const TAB = '\t'

const QUOTATION_MARK = '"'
const PERIOD = '.'
const OPEN_PARENTHESIS = '('
const CLOSED_PARENTHESIS = ')'
const COMMA = ','
const COLON = ':'
const BACKSLASH = '\\'
const HASHTAG = '#'
const EQUALS = '='















# Token Types and Symbols

# Identifier

const TT_IDENTIFIER = "IDENTIFIER"

# Keywords

const TT_KEYWORD = "KEYWORD"

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

var ALL_OPERATORS














# Core

var reader: StoryScriptReader

# Lines and columns use 0 indexing 
var current_token_position = StoryScriptToken.Position.new()
var previous_indent_level: int

var tokens: Array

var identifier_first_char_regex: RegEx
var identifier_nonfirst_char_regex: RegEx

func _init():
	ALL_OPERATORS = []
	ALL_OPERATORS.append_array(ALL_UNARY_OPERATORS)
	ALL_OPERATORS.append_array(ALL_BINARY_OPERATORS)
	
	identifier_first_char_regex = RegEx.new()
	identifier_first_char_regex.compile("^[_a-zA-Z]$")
	
	identifier_nonfirst_char_regex = RegEx.new()
	identifier_nonfirst_char_regex.compile("^[_a-zA-Z0-9]$")

# Returns Token[]
func generate_tokens(reader_: StoryScriptReader):
	reader = reader_
	current_token_position.line = -1
	tokens = []
	previous_indent_level = 0
	
	var error = null
	while not reader.is_EOF():
		if reader.peek() == HASHTAG:
			ignore_rest_of_line()
		elif reader.peek() == QUOTATION_MARK:
			error = add_string_literal()
		elif is_possible_number(reader.peek()):
			error = add_number()
		elif reader.peek() == OPEN_PARENTHESIS:
			error = consume_next_and_add_token(TT_PUNCTUATION, PUNC_OPEN_PARENTHESIS)
		elif reader.peek() == CLOSED_PARENTHESIS:
			error = consume_next_and_add_token(TT_PUNCTUATION, PUNC_CLOSED_PARENTHESIS)
		elif reader.peek() == COMMA:
			error = consume_next_and_add_token(TT_PUNCTUATION, PUNC_COMMA)
		elif reader.peek() == COLON:
			error = consume_next_and_add_token(TT_PUNCTUATION, PUNC_COLON)
		elif reader.peek() == EQUALS:
			error = consume_next_and_add_token(TT_OPERATOR, OP_ASSIGN)
		# We check identifiers and keywords together, since they share the
		# same rules (Since keywords are special identifiers determined
		# by the language)
		elif is_possible_identifier_or_keyword(reader.peek()):
			error = add_identifier_or_keyword()
		elif reader.peek() == NEWLINE:
			# Notes that a String can consume a new line when it spans multiple
			# lines, threfore not all new lines may be recorded
			error = add_indent()
		elif reader.peek() == SPACE or reader.peek() == TAB:
			consume()
		else:
			error = error("Unknown symbol: \"%s\"." % reader.peek())
			
		if error is StoryScriptError:
			return error
		
	return tokens

func add_token(type: String, value = null):
	tokens.append(StoryScriptToken.new(type, value, current_token_position.clone()))

func consume_next_and_add_token(type: String, value = null):
	consume()
	add_token(type, value)

# Keywords

func is_keyword(identifier) -> bool:
	for keyword in ALL_KEYWORDS:
		if identifier == keyword:
			return true
	return false

func add_keyword(identifier):
	add_token(TT_KEYWORD, identifier)

# Comments

func ignore_rest_of_line():
	# Consume hashtag
	consume()
	while reader.peek() != NEWLINE:
		consume()
		if reader.is_EOF():
			return

# Identifier

func is_possible_identifier_or_keyword(ch) -> bool:
	return identifier_first_char_regex.search(ch) != null

func add_identifier_or_keyword():
	var possible_identifier: String = consume()
	
	while identifier_nonfirst_char_regex.search(reader.peek()) != null:
		possible_identifier += consume()
		if reader.is_EOF():
			break
	
	if is_keyword(possible_identifier):
		add_keyword(possible_identifier)
	# TODO: Remove this since the previous checks technically mean
	# this statement is always true
	else:
		add_identifier(possible_identifier)

func add_identifier(identifier):
	add_token(TT_IDENTIFIER, identifier)

# Number

func is_possible_number(ch: String) -> bool:
	# Assume that '.' is never used for anything but a number
	return ch in "0123456789."

func add_number():
	var possible_number_string: String = ""
	var decimal_exists: bool = false
	
	while reader.peek() in "0123456789.":
		if reader.peek() == PERIOD:
			if decimal_exists:
				consume()
				return error("Cannot have more than one decimal point in a number.")
			else:
				decimal_exists = true
		possible_number_string += consume()
		if reader.is_EOF():
			break

	if possible_number_string.is_valid_integer():
		add_token(TT_INT, int(possible_number_string))
	elif possible_number_string.is_valid_float():
		add_token(TT_FLOAT, float(possible_number_string))
	else:
		return error("Could not parse number.")

# String

func add_string_literal():
	# Consume quotation mark
	consume()
	var string_literal: String = ""
	
	if reader.is_EOF():
		return error("Unexpected open quotation mark at end of file.")
	
	var next_char_escaped: bool = false
	while reader.peek() != QUOTATION_MARK or (reader.peek() == QUOTATION_MARK and next_char_escaped):
		var current_character: String = consume()
		
		var isEOF = reader.is_EOF()
		if reader.is_EOF():
			return error("String extended to end of file without termination.")
		
		# We skip new lines to allow for multiline strings
		if current_character == NEWLINE:
			# We reset escape charcters flag because they should not span multiple lines
			# ie. cases like 
			# "\   
			#  n" 
			# would not be included
			next_char_escaped = false
			continue
		
		# If we are not an escaped character, we can try to escape the next character.
		# Else if we are an escapec character, reset the escaped character
		#
		# This prevents double backslashes from escaping the next character
		# ie for "\\n", we should not escape 'n'
		if not next_char_escaped and current_character == BACKSLASH:
			next_char_escaped = true
			# Consume the backslash
		elif next_char_escaped:
			next_char_escaped = false
			if current_character == QUOTATION_MARK:
				string_literal += QUOTATION_MARK
			elif current_character in 'nN':
				string_literal += NEWLINE
			elif current_character in 'tT':
				string_literal += TAB
			elif current_character == BACKSLASH:
				string_literal += BACKSLASH
			else:
				return error("Unknown escape sequence: \"\\%s\"" % current_character)
		else:
			string_literal += current_character
	
	# Consume the quotation mark that made us leave the while loop
	consume()

	add_token(TT_STRING, string_literal)

# Misc

func consume(steps_ahead: int = 1) -> String:
	current_token_position.column += 1
	var consumed = reader.consume(steps_ahead)
	if consumed == NEWLINE:
		new_line_setup()
	return consumed 

func peek_position(steps_ahead: int = 1) -> StoryScriptToken.Position:
	var new_position = current_token_position.clone()
	for i in range(1, steps_ahead + 1):
		if reader.peek(i) == EOF:
			break
			
		if reader.peek(i) == NEWLINE:
			new_position.line += 1
			new_position.column = -1
		else:
			new_position.column += 1
			
	return new_position

func new_line_setup():
	current_token_position.line += 1
	current_token_position.column = -1
	# Identifiers cannot be between two linebreaks, therefore we must reset possible_identifier

func add_indent():
	# Consume newline
	consume()
	var indent_count: int
	if USE_TABS_INDENT:
		var tabs_count: int = 0
		while reader.peek() == TAB:
			tabs_count += 1
			consume()
		
		indent_count = tabs_count
	else:
		# Assume we are currently on a '\n' character
		var spaces_count: int = 0
		while reader.peek() == SPACE:
			spaces_count += 1
			consume()
		
		if spaces_count % INDENT_SPACES != 0:
			return error("Indentations are irregular! Number of spaces used for an indent must == indent space number of %s." % [INDENT_SPACES])
		
		indent_count = spaces_count / INDENT_SPACES
	
	if indent_count > previous_indent_level:
		if indent_count == previous_indent_level + 1:
			add_token(TT_PUNCTUATION, PUNC_INDENT)
			# Set column to 0 since newlines start at a column of -1.
			# An indent column of 0 lets you visit the indentation token
			# if there is an error.
			tokens.back().position.column = 0
		else:
			return error("Expected only one indent for a new block.")
	elif indent_count < previous_indent_level:
		var number_of_indents_below: int = previous_indent_level - indent_count
		for i in range(number_of_indents_below):
			add_token(TT_PUNCTUATION, PUNC_DEDENT)
			tokens.back().position.column = 0
	
	previous_indent_level = indent_count

# Returns a StoryScriptError based on a message and an TokenPosition
# If position is an INT, then it will return a StoryScriptError with a token position = the current position + a `position` number of steps
# If position is not inputted, then it will return a StoryScriptError with the current token position 
func error(message: String, position = current_token_position) -> StoryScriptError:
	if position is StoryScriptToken.Position:
		return StoryScriptError.new(message, position.clone())
	elif typeof(position) == TYPE_INT:
		return StoryScriptError.new(message, peek_position(position))
	return null

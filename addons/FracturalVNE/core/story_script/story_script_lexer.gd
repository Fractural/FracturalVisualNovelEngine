class_name StoryScriptLexer
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
# Token Types
const TT_IDENTIFIER = "IDENTIFIER"
const TT_KEYWORD = "KEYWORD"
const TT_INT = "INT"
const TT_FLOAT = "FLOAT"
const TT_STRING = "STRING"
const TT_OPEN_PARENTHESIS = "("
const TT_CLOSED_PARENTHESIS = ")"
const TT_COMMA = ","
const TT_COLON = ":"
const TT_INDENT = "INDENT"

# Lines and columns use 1 indexing 
var current_line: int
var current_column: int

var reader: StoryScriptReader

var tokens: Array

var identifier_regex: RegEx
var identifier_first_char_regex: RegEx
var identifier_nonfirst_char_regex: RegEx

func _init():
	identifier_regex = RegEx.new()
	identifier_regex.compile("^[a-zA-Z][0-9a-zA-Z]*$")

	identifier_first_char_regex = RegEx.new()
	identifier_first_char_regex.compile("^[a-zA-Z]$")
	
	identifier_nonfirst_char_regex = RegEx.new()
	identifier_nonfirst_char_regex.compile("^[a-zA-Z0-9]$")

# Returns Token[]
func lex_story(reader_: StoryScriptReader) -> Array:
	reader = reader_
	current_line = 0
	tokens = []

	# First line is a new line
	new_line_setup()

	var current_char
	while not reader.is_EOF():
		current_char = consume()
		
		if current_char == QUOTATION_MARK:
			add_string_literal()
		elif is_possible_number(current_char):
			add_number(current_char)
		elif current_char == OPEN_PARENTHESIS:
			add_token(TT_OPEN_PARENTHESIS)
		elif current_char == CLOSED_PARENTHESIS:
			add_token(TT_CLOSED_PARENTHESIS)
		elif current_char == COMMA:
			add_token(TT_COMMA)
		elif current_char == COLON:
			add_token(TT_COLON)
		elif is_possible_identifier(current_char):
			add_identifier(current_char)
		elif current_char == NEWLINE:
			# Notes that a String can consume a new line, threfore not all new 
			# lines may be recorded
			add_indent()
		elif current_char == SPACE or current_char == TAB:
			continue
		else:
			error("Unknown symbol: \"%s\"." % current_char)
	return tokens

func add_token(type: String, value = null):
	tokens.append(StoryScriptToken.new(type, value, current_line, current_column))

# Identifier

func is_possible_identifier(ch) -> bool:
	return identifier_first_char_regex.search(ch) != null

func add_identifier(current_char: String):
	var possible_identifier: String = current_char
	
	while identifier_nonfirst_char_regex.search(reader.peek()) != null:
		possible_identifier += consume()
		if reader.is_EOF():
			break
	
	if identifier_regex.search(possible_identifier):
		add_token(TT_IDENTIFIER, possible_identifier)
	else:
		error("\"%s\" is not a valid identifier" % [possible_identifier])

# Number

func is_possible_number(ch: String) -> bool:
	# Assume that '.' is never used for anything but a number
	return ch in "0123456789."

func add_number(current_char: String):
	var possible_number_string: String = current_char
	var decimal_exists: bool = current_char == PERIOD
	
	while reader.peek() in "0123456789.":
		if reader.peek() == PERIOD:
			if decimal_exists:
				error("Cannot have more than one decimal point in a number.")
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
		error("Could not parse number.")

# String

func add_string_literal():
	var string_literal: String = ""
	
	if reader.is_EOF():
		error("Unexpected open quotation mark at end of file.")
	
	var next_char_escaped: bool = false
	while reader.peek() != QUOTATION_MARK or (reader.peek() == QUOTATION_MARK and next_char_escaped):
		var current_character: String = consume()
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
				error("Unknown escape sequence: \"\\%s\"" % current_character)
		else:
			string_literal += current_character
		
		if reader.is_EOF():
			error("String extended to end of file without termination.")
	
	# Consume the quotation mark that made us leave the while loop
	consume()

	add_token(TT_STRING, string_literal)

# Misc

func consume(steps_ahead: int = 1) -> String:
	current_column += 1
	var consumed = reader.consume(steps_ahead)
	if consumed == NEWLINE:
		new_line_setup()
	return consumed 

func new_line_setup():
	current_line += 1
	current_column = 0
	# Identifiers cannot be between two linebreaks, therefore we must reset possible_identifier

func add_indent():
	var indent_count: int
	if USE_TABS_INDENT:
		var tabs_count: int = 0
		while reader.peek(tabs_count + 1) == TAB:
			tabs_count += 1
		
		indent_count = tabs_count
	else:
		# Assume we are currently on a '\n' character
		var spaces_count: int = 0
		while reader.peek(spaces_count + 1) == SPACE:
			spaces_count += 1
		
		if spaces_count % INDENT_SPACES != 0:
			error("Indentations are irregular! Number of spaces used for an indent must == indent space number of %s." % [INDENT_SPACES])
		
		indent_count = spaces_count / INDENT_SPACES
	
	add_token(TT_INDENT, indent_count)

func error(message: String, line: int = current_line, column: int = current_column):
	assert(false, "Line: %s[%s] : %s" % [str(line), str(column), message])

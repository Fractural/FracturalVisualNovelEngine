tool
class_name StoryScriptLexer
extends Reference
# Lexes a string of text into tokens for parsing.


# ----- Definitions ----- #

const StoryScriptReader = preload("res://addons/FracturalVNE/core/story_script/compiling/story_script_reader.gd")
const NodeConstructConstants = preload("res://addons/FracturalVNE/core/story_script/node_construct_constants.gd")
const StoryScriptPosition = preload("res://addons/FracturalVNE/core/story_script/story_script_position.gd")
const StoryScriptError = preload("res://addons/FracturalVNE/core/story_script/story_script_error.gd")
const SSUtils = preload("res://addons/FracturalVNE/core/story_script/story_script_utils.gd")

# ----- Definitions ----- #


# ----- Constants ----- #

const EOF = "EOF"

const USE_TABS_INDENT: bool = true
const INDENT_SPACES : int = 4

# Characters
const NEWLINE = '\n'
const SPACE = ' '
const TAB = '\t'

const QUOTATION_MARK = '"'
const PERIOD = '.'
const BACKSLASH = '\\'
const HASHTAG = '#'

# ----- Constants ----- #


# ----- Core ----- #

var constructs = NodeConstructConstants.new().CONSTRUCTS
var reader: StoryScriptReader

var keywords = []
var operators = []
var punctuation = []

# Lines and columns use 0 indexing 
var current_token_position = StoryScriptPosition.new()
var previous_indent_level: int

var tokens: Array


func _init():	
	for construct in constructs:
		if construct.has_method("get_keywords"):
			_add_array(keywords, construct.get_keywords())
		if construct.has_method("get_operators"):
			_add_array(operators, construct.get_operators())
		if construct.has_method("get_punctuation"):
			_add_array(punctuation, construct.get_punctuation())


func _add_array(array: Array, added_array: Array):
	for added_elem in added_array:
		if not array.has(added_elem):
			array.append(added_elem)


# Returns Token[]
func generate_tokens(reader_: StoryScriptReader):
	reader = reader_
	current_token_position.line = -1
	tokens = []
	previous_indent_level = 0
	
	while not reader.is_EOF():
		var errors = []
		
		if reader.peek() == HASHTAG:
			add_comment()
			continue

		if reader.peek() == SPACE or reader.peek() == TAB:
			consume()
			continue

		errors.append(add_string_literal())
		if is_success(errors.back()):
			continue
		elif errors.back().confidence == 1:
			return errors.back()

		errors.append(add_number())
		if is_success(errors.back()):
			continue
		elif errors.back().confidence == 1:
			return errors.back()

		errors.append(add_punctuation())
		if is_success(errors.back()):
			continue
		elif errors.back().confidence == 1:
			return errors.back()

		errors.append(add_operator())
		if is_success(errors.back()):
			continue
		elif errors.back().confidence == 1:
			return errors.back()

		# We check identifiers and keywords together, since they share the
		# same rules (Since keywords are special identifiers determined
		# by the language)
		errors.append(add_identifier_or_keyword())
		if is_success(errors.back()):
			continue
		elif errors.back().confidence == 1:
			return errors.back()

		if reader.peek() == NEWLINE:
			var error = add_newline_and_maybe_indent()
			if is_success(error):
				continue
			return error

		var closest_error = errors.front()
		for error in errors:
			if error.confidence > closest_error.confidence:
				closest_error = error

		if closest_error.confidence == 0:
			return error("Unexpected symbol.", 1, null, 1)
		else:
			return closest_error
		consume()
		
	return tokens


func add_token(type: String, value = null):
	tokens.append(StoryScriptToken.new(type, value, current_token_position.clone()))


func consume_next_and_add_token(type: String, value = null):
	consume()
	add_token(type, value)

# ----- Core ----- #


# ----- Keywords ----- #

func is_keyword(identifier) -> bool:
	for keyword in keywords:
		if identifier == keyword:
			return true
	return false


func add_keyword_token(identifier):
	add_token("keyword", identifier)

# ----- Keywords ----- #


# ----- Punctuation ----- #

func add_punctuation():
	var matches = punctuation.duplicate()
	var curr_peek_index = 1
	var confidence = 0
	while true:
		for i in range(matches.size() - 1, -1, -1):
#			var ahead = reader.peek(curr_peek_index) + reader.peek(curr_peek_index + 1) + reader.peek(curr_peek_index + 2) + reader.peek(curr_peek_index + 3)
			if matches[i][curr_peek_index - 1] != reader.peek(curr_peek_index):
				matches.remove(i)
		if matches.size() == 0:
			return error(null, confidence)
		if matches.size() == 1:
			break
		confidence = curr_peek_index / float(matches.size())
		curr_peek_index += 1
	consume(matches[0].length())
	add_token("punctuation", matches[0])

# ----- Punctuation ----- #


# ----- Operators ----- #

func add_operator():
	var matches = operators.duplicate()
	var curr_peek_index = 1
	var confidence = 0
	while true:
		for i in range(matches.size() - 1, -1, -1):
			if matches[i][curr_peek_index - 1] != reader.peek(curr_peek_index):
				matches.remove(i)
		if matches.size() == 0:
			return error(null, confidence)
		if matches.size() == 1:
			break
		confidence = curr_peek_index / float(matches.size())
		curr_peek_index += 1
	consume(matches[0].length())
	add_token("operator", matches[0])

# ----- Operators ----- #


# ----- Comments ----- #

func add_comment():
	# Consume hashtag
	consume()
	
	while reader.peek() != NEWLINE:
		consume()
		if reader.is_EOF():
			return


# ----- Comments ----- #


# ----- Identifier ----- #

func is_identifier_first_char(character):
	return character == "_" or (ord("a") <= ord(character) and ord(character) <= ord("z")) or (ord("A") <= ord(character) and ord(character) <= ord("Z"))


func is_identifier_nonfirst_char(character):
	return is_identifier_first_char(character) or (ord("0") <= ord(character) and ord(character) <= ord("9"))


func add_identifier_or_keyword():
	# Apparently Regex causes memory leaks.
	# Regex was very performance intensive anyways so I've switched to
	# using good old boolean statements.
	if not is_identifier_first_char(reader.peek()):
		return error()
	
	var possible_identifier: String = consume()
	
	while is_identifier_nonfirst_char(reader.peek()):
		possible_identifier += consume()
		if reader.is_EOF():
			break
	
	if is_keyword(possible_identifier):
		add_keyword_token(possible_identifier)
	else:
		add_identifier_token(possible_identifier)


func add_identifier_token(identifier):
	add_token("identifier", identifier)

# ----- Identifier ----- #


# ----- Number ----- #

func add_number():
	if not reader.peek() in "0123456789.":
		return error()
	
	var possible_number_string: String = reader.consume()
	var decimal_exists: bool = possible_number_string == "."
	
	while reader.peek() in "0123456789.":
		if reader.peek() == PERIOD:
			if decimal_exists:
				consume()
				return error("Cannot have more than one decimal point in a number.", 1, null, 1)
			else:
				decimal_exists = true
		possible_number_string += consume()
		if reader.is_EOF():
			break

	if possible_number_string.is_valid_integer():
		add_token("integer", int(possible_number_string))
	elif possible_number_string.is_valid_float():
		add_token("float", float(possible_number_string))
	else:
		return error("Could not parse number. Maybe there is a stray period?", 1)

# ----- Number ----- #


# ----- String ----- #

func add_string_literal():
	if reader.peek() != QUOTATION_MARK:
		return error()
	consume()
	
	var string_literal: String = ""
	
	if reader.is_EOF():
		return error("Unexpected open quotation mark at end of file.", 1)
	
	var next_char_escaped: bool = false
	while reader.peek() != QUOTATION_MARK or (reader.peek() == QUOTATION_MARK and next_char_escaped):
		var current_character: String = consume()
		
		var isEOF = reader.is_EOF()
		if reader.is_EOF():
			return error("String extended to end of file without termination.", 1)
		
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
				return error("Unknown escape sequence: \"\\%s\"" % current_character, 1)
		else:
			string_literal += current_character
	
	# Consume the quotation mark that made us leave the while loop
	consume()

	add_token("string", string_literal)

# ----- String ----- #


# ----- Core cont. ----- #

func consume(steps_ahead: int = 1) -> String:
	current_token_position.column += 1
	var consumed = reader.consume()
	if consumed == NEWLINE:
		new_line_setup()
	if steps_ahead > 1:
		return consume(steps_ahead - 1)
	return consumed 


func peek_position(steps_ahead: int = 1) -> StoryScriptPosition:
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


func add_newline_and_maybe_indent():
	# Consume new line
	consume()
	
	# REFACTOR COMMENT: I have no idea what a "trailing indent" means :(
	#
	# If the previous token was not a newline or an indent/dedent, 
	# then add a newline token. This removes blank lines from the tokens list 
	# and the indent/dedent check prevents a newline from trailing after a dedent
	# (Newlines trailing after indents/dedents are bad since newlines are supposed 
	# to be markers for the end of a statement and indents/dedents aren't statements).
	if (tokens.size() > 0 
		and not (tokens.back().type == "punctuation" 
		and (tokens.back().symbol == "newline" 
			or tokens.back().symbol == "dedent" 
			or tokens.back().symbol == "indent")
			)
		):
		add_token("punctuation", "newline")
	
	# Check if the newline is just a comment/blank line by peeking as far as 
	# popssible until the next line starts. If the line contains only white 
	# space and/or a comment, then do not parse any indentation. This removes 
	# comment/blank lines from the tokens list.
	var j = 1
	while reader.peek(j) == TAB or reader.peek(j) == SPACE:
		j += 1
	if reader.peek(j) == HASHTAG or reader.peek(j) == NEWLINE:
		return
	
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
			return error("Indentations are irregular! Number of spaces used for an indent must == indent space number of %s." % [INDENT_SPACES], 1)
		
		indent_count = spaces_count / INDENT_SPACES
	
	if indent_count > previous_indent_level:
		if indent_count == previous_indent_level + 1:
			add_token("punctuation", "indent")
			# Set column to 0 since newlines start at a column of -1.
			# An indent column of 0 lets you visit the indentation token
			# if there is an error.
			tokens.back().position.column = 0
		else:
			return error("Expected only one indent for a new block.", 1)
	elif indent_count < previous_indent_level:
		var number_of_indents_below: int = previous_indent_level - indent_count
		for i in range(number_of_indents_below):
			add_token("punctuation", "dedent")
			tokens.back().position.column = 0
	
	previous_indent_level = indent_count


func is_success(result):
	return SSUtils.is_success(result)


func save_reader_state():
	return reader.clone()


func load_reader_state(state):
	reader = state


# Returns a StoryScriptError based on a message and an TokenPosition
# If position is an INT, then it will return a StoryScriptError with a token position = the current position + a `position` number of steps
# If position is not inputted, then it will return a StoryScriptError with the current token position 
func error(message = null, confidence: float = 0, checkpoint = null, position = current_token_position):
	if checkpoint != null:
		reader = checkpoint
	
	if message == null:
		return StoryScriptError.new("", position, confidence)
	
	if position is StoryScriptPosition:
		return StoryScriptError.new(message, position.clone(), confidence)
	elif typeof(position) == TYPE_INT:
		return StoryScriptError.new(message, peek_position(position), confidence)
	assert(false, "Unknown use of error().")

# ----- Core cont. ----- #

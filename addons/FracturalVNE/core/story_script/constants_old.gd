extends Reference

enum ConstructType {
	VARIABLE_DECLARATION,
	VARIABLE_ASSIGNMENT,
	FUNCTION_DECLARATION,
	BLOCK,
	LABEL,
	JUMP,
	HIDE,
	SHOW,
}

enum Keyword {
	LABEL,
	JUMP,
	HIDE,
	SHOW,
}

enum TokenType {
	IDENTIFIER,
	KEYWORD,
	PUNCTUATION,
	STRING_LITERAL,
	FLOAT_LITERAL,
	INT_LITERAL,
}

var construct_type_strings: Dictionary
var keyword_strings: Dictionary
var token_type_strings: Dictionary

func _init():
	# Setup the string dictionaries that convert from string to enum
	var keys
	var values
	
	construct_type_strings = {}
	keys = ConstructType.keys()
	values = ConstructType.values()
	for i in range(keys.size()):
		construct_type_strings[values[i]] = keys[i]
		
	keyword_strings = {}
	keys = Keyword.keys()
	values = Keyword.values()
	for i in range(keys.size()):
		keyword_strings[values[i]] = keys[i]
		
	token_type_strings = {}
	keys = TokenType.keys()
	values = TokenType.values()
	for i in range(keys.size()):
		token_type_strings[values[i]] = keys[i]

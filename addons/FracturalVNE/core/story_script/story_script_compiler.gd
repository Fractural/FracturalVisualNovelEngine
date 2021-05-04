tool
class_name StoryScriptCompiler
extends Node

signal throw_error(message, error_position)

var lexer: StoryScriptLexer
var parser: StoryScriptParser

func _init():
	lexer = StoryScriptLexer.new()
	parser = StoryScriptParser.new()

# Compiles a story script that is given in raw text format
# If succesful, returns the compiled syntax tree
# If it fails to compile, returns a `StoryScriptError`
func compile(script_text: String):
	# Clears console
	print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
	
	print("Compilation Start")
	print("Generating Tokens...")
	
	var time_start = OS.get_ticks_msec()
	
	var lexed_tokens = lexer.generate_tokens(StoryScriptReader.new(script_text))
	
	var time_end = OS.get_ticks_msec()
	
	print("Lex time: %sms" % str(time_end - time_start))
	
	if lexed_tokens is StoryScriptError:
		print("Compilation Failed")
		return lexed_tokens
		
	print()
	print("Tokens: (%s tokens)" % lexed_tokens.size())
	for token in lexed_tokens:
		print(token)

	print()	
	print("Generating Abstract Syntax Tree...")
	
	time_start = OS.get_ticks_msec()
	
	var parse_tree = parser.generate_abstract_syntax_tree(StoryScriptTokensReader.new(lexed_tokens))
	
	time_end = OS.get_ticks_msec()
	
	print("Parse time: %sms" % str(time_end - time_start))
	
	if parse_tree is StoryScriptError:
		print("Compilation Failed")
		return parse_tree
	
	print()
	print("Abstract Syntax Tree:")
	print(parse_tree.debug_string(""))
	
	print()
	print("Compilation Succeeded")
	
	return parse_tree

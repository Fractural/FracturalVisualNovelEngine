tool
extends Node
# Compiles a string of StoryScript into a .story file.


signal throw_error(message, error_position)

const StoryScriptReader = preload("res://addons/FracturalVNE/core/story_script/compiling/story_script_reader.gd")
const StoryScriptLexer = preload("res://addons/FracturalVNE/core/story_script/compiling/story_script_lexer.gd")
const StoryScriptParser = preload("res://addons/FracturalVNE/core/story_script/compiling/story_script_parser.gd")
const StoryScriptError = preload("res://addons/FracturalVNE/core/story_script/story_script_error.gd")

var lexer: StoryScriptLexer
var parser: StoryScriptParser


func _init():
	lexer = StoryScriptLexer.new()
	parser = StoryScriptParser.new()


func compile(script_text: String):
	var lexed_tokens = lexer.generate_tokens(StoryScriptReader.new(script_text))	
	if lexed_tokens is StoryScriptError:
		return lexed_tokens
	return parser.generate_abstract_syntax_tree(StoryScriptTokensReader.new(lexed_tokens))
	
	
# Compiles a story script that is given in raw text format
# If succesful, returns the compiled syntax tree
# If it fails to compile, returns a `StoryScriptError`
func test_compile(script_text: String):
	var print_results = true
	# Clears console
	print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
	
	print("Compilation Start")
	print("Generating Tokens...")
	
	var time_start = OS.get_ticks_msec()
	
	var lexed_tokens = lexer.generate_tokens(StoryScriptReader.new(script_text))
	
	var time_end = OS.get_ticks_msec()
	
	var lex_time = time_end - time_start
	print("Lex time: %sms" % str(lex_time))
	
	if lexed_tokens is StoryScriptError:
		print("Compilation Failed")
		return lexed_tokens
		
	print()
	print("Tokens: (%s tokens)" % lexed_tokens.size())
	
	if print_results:
		for token in lexed_tokens:
			print(token)

	print()	
	print("Generating Abstract Syntax Tree...")
	
	time_start = OS.get_ticks_msec()
	
	var parse_tree = parser.generate_abstract_syntax_tree(StoryScriptTokensReader.new(lexed_tokens))
	
	time_end = OS.get_ticks_msec()
	
	var parse_time = time_end - time_start
	print("Parse time: %sms" % str(parse_time))
	
	if parse_tree is StoryScriptError:
		print("Compilation Failed")
		return parse_tree
	
	print()
	print("Abstract Syntax Tree:")
	
	if print_results:
		print(parse_tree.debug_string(""))
	
	print()
	print("Compilation Succeeded")
	
	print()
	print("Attempting to serialize AST:")
	
	time_start = OS.get_ticks_msec()
	
	var serialized_ast = JSON.print(parse_tree.serialize())
	
	var serialized_file = File.new()
	serialized_file.open_compressed("res://test.story", File.WRITE)
	serialized_file.store_string(serialized_ast)
	serialized_file.close()
	
	time_end = OS.get_ticks_msec()
	var serialize_time = time_end - time_start
	
	if print_results:
		print(serialized_ast)
	
	print()
	print("Attempting to deserialized serialized AST:")
	
	time_start = OS.get_ticks_msec()
		
	serialized_file = File.new()
	serialized_file.open_compressed("res://test.story", File.READ)
	var read_serialized_ast = serialized_file.get_line()
	serialized_file.close()
	
	var json_result = JSON.parse(read_serialized_ast)
	
	time_end = OS.get_ticks_msec()
	var deserialize_time = time_end - time_start
	
	if json_result.error != OK:
		print("Could not deserialize the AST.")
		return
	
	if print_results:
		print(SerializationUtils.deserialize(json_result.result).debug_string(""))
	
	print()
	print("Total compile time: %sms" % str(lex_time + parse_time))
	print("Total serialize time: %sms" % str(serialize_time))
	print("Total deserialize time: %sms" % str(deserialize_time))
	
	return parse_tree

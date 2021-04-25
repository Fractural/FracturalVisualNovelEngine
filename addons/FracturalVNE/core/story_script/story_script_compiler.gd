tool
class_name StoryScriptCompiler
extends Node

signal throw_error(message, error_position)

var lexer: StoryScriptLexer
var parser: StoryScriptParser
var action_tree_builder = StoryScriptActionTreeBuilder

func _init():
	lexer = StoryScriptLexer.new()
	parser = StoryScriptParser.new()
	action_tree_builder = StoryScriptActionTreeBuilder.new()

# Compiles a story script that is given in raw text format
# If succesful, returns the compiled syntax tree
# If it fails to compile, returns a `StoryScriptError`
func compile(script_text: String):
	# Clears console
	print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
	
	print("Compilation Start")
	print("Generating Tokens...")
	
	var lexed_tokens = lexer.generate_tokens(StoryScriptReader.new(script_text))
	
	if lexed_tokens is StoryScriptError:
		print("Compilation Failed")
		return lexed_tokens
		
	print()
	print("Tokens:")
	for token in lexed_tokens:
		print(token)

	print()	
	print("Generating Abstract Syntax Tree...")
	
	var parse_tree = parser.generate_abstract_syntax_tree(StoryScriptTokensReader.new(lexed_tokens))
	
	if parse_tree is StoryScriptError:
		print("Compilation Failed")
		return parse_tree
	
	print()
	print("Abstract Syntax Tree:")
	print(parse_tree)
	
	var action_tree = action_tree_builder.generate_action_tree(parse_tree)
	
	if action_tree is StoryScriptError:
		print("Compilation Failed")
		return action_tree
	
	print()
	print("Action Syntax Tree:")
	print(action_tree)
	
	print()
	print("Compilation Succeeded")
	
	return parse_tree

tool
class_name StoryScriptCompiler
extends Node

signal throw_error(message, error_position)

var error_handler: StoryScriptErrorHandler
var lexer: StoryScriptLexer
var parser: StoryScriptParser

func _init():
	error_handler = StoryScriptErrorHandler.new()
	lexer = StoryScriptLexer.new(error_handler)
	parser = StoryScriptParser.new(error_handler)

func compile(script_text: String) -> StoryActions.Action:
	return parser.parse_tokens(lexer.generate_tokens(StoryScriptReader.new(script_text)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

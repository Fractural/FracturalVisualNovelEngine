class_name StoryScriptParser
extends Reference

var error_handler: StoryScriptErrorHandler

func _init(error_handler_: StoryScriptErrorHandler):
	error_handler = error_handler_

func parse_tokens(tokens: Array) -> StoryActions.Action:
	# TODO: Finish parsing tokens
	return StoryActions.Action.new()

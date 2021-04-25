class_name StoryScriptError
extends Reference

var message: String
var position: StoryScriptToken.Position
var confidence: float

func _init(message_: String, position_, confidence_: float = 1):
	message = message_
	position = position_

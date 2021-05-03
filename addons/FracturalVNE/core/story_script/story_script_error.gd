class_name StoryScriptError
extends Reference

var message: String
var position: StoryScriptToken.Position
var confidence: float

func _init(message_: String, position_ = null, confidence_: float = 0):
	message = message_
	position = position_
	confidence = confidence_

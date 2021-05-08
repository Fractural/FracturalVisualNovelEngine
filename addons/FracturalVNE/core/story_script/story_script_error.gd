class_name StoryScriptError
extends Reference

var message: String
var position: StoryScriptPosition
var confidence: float

func _init(message_: String, position_ = null, confidence_: float = 0):
	message = message_
	position = position_
	confidence = confidence_

func _to_string():
	return "SSErr @" + str(position) + " conf:" + str(confidence) + " " + message

class ErrorStack extends Reference:
	var errors = []
	
	func _init(errors_ = []):
		errors = errors_
	
	func add_error(error: StoryScriptError):
		errors.append(error)
	
	func _to_string():
		var string = "SSErr Stack:"
		for error in errors:
			string += "\n" + str(error)
		return string

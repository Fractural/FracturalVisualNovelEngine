class_name StoryScriptError
extends Reference
# Stores an error that occured in a StoryScript whether during compile time
# or during execution.


var message: String
var position: StoryScriptPosition
var confidence: float


func _init(message_: String, position_ = null, confidence_: float = 0):
	message = message_
	position = position_
	confidence = confidence_


func _to_string():
	return "SSErr: " + str(position) + " conf: " + str(confidence) + " " + message


func runtime_error_string():
	var position_text
	if position != null:
		# StoryScriptPosition uses 0-based numbering so to make it more readable, it will
		# be displayed as 1-based numbering (Since the script editor's line and columns 
		# are numbers starting from 1)
		position_text = "@%-20s" % ["(Line:%s, Col:%s)" % [position.line + 1, position.column + 1]]
	else:
		position_text = " %-20s" % ""
	return "Error: " + position_text + "%-10s" % ["conf: " + str(confidence)] + message


class ErrorStack extends Reference:
	# Stores a stack of StoryScriptErrors and is used to generate stack traces
	# to debug a StoryScript.
	
	
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
	
	
	func runtime_error_string():
		var string = ""
		for i in errors.size():
			string += errors[i].runtime_error_string() + ("\n" if i < errors.size() - 1 else "")
		return string

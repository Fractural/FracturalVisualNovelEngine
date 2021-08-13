extends Reference
# Stores an error that occured in a StoryScript whether during compile time
# or during execution.
# 
# As a rule of thumb, whenever you want to call a function with variables whose
# type you do not know, please check the types before passing the variables through.
# 
# Every function should assume it receieved the correct typed parameters
# and should not have to implement checks for their parameters.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StoryScriptError"]

# ----- Typeable ----- #


const Position = preload("res://addons/FracturalVNE/core/story_script/story_script_position.gd")


var message: String
var position: Position
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
		# FracVNE.StoryScript.Position uses 0-based numbering so to make it more readable, it will
		# be displayed as 1-based numbering (Since the script editor's line and columns 
		# are numbers starting from 1)
		position_text = "@%-20s" % position.to_one_indexed_string()
	else:
		position_text = " %-20s" % ""
	return "Error: " + position_text + "%-10s" % ["conf: " + str(confidence)] + message


class ErrorStack extends Reference:
	# Stores a stack of FracVNE.StoryScript.Errors and is used to generate stack traces
	# to debug a StoryScript.
	
	
	# ----- Typeable ----- #
	
	func get_types() -> Array:
		return ["StoryScriptError"]
	
	# ----- Typeable ----- #
	
	
	var errors = []
	
	
	func _init(errors_ = []):
		errors = errors_
	
	
	func add_error(error):
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

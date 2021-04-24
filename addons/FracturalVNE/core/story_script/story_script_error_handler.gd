tool
class_name StoryScriptErrorHandler

signal throw_error(message, error_position)

func throw_error(message: String, position):
	emit_signal("throw_error", message, position)

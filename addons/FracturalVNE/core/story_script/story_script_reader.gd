class_name StoryScriptReader
extends Reference

const EOF = "EOF"

var _current_index: int = -1
var _raw_text: String

func _init(raw_text_: String):
	_raw_text = raw_text_ + "\n\n"

func consume(steps_ahead: int = 1):
	_current_index += steps_ahead
	if _current_index >= _raw_text.length():
		return EOF
	return _raw_text[_current_index]

func peek(steps_ahead: int = 1):
	if (_current_index + steps_ahead) >= _raw_text.length():
		return EOF
	return _raw_text[_current_index + steps_ahead]

func is_EOF():
	return _current_index >= (_raw_text.length() - 1)

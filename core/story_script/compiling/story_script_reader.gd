extends Reference
# Handles traversing through a string.


const EOF = "EOF"

var _current_index: int = -1
var _raw_text: String


func _init(raw_text_ = null):
	if raw_text_ != null:
		_raw_text = "\n" + raw_text_ + "\n\n"


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


func clone():
	var clone = get_script().new()
	clone._raw_text = _raw_text
	clone._current_index = _current_index
	return clone

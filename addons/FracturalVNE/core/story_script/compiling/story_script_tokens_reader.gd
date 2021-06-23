class_name StoryScriptTokensReader
extends Reference

var EOF
var BOF

var _current_index: int = -1
var _raw_tokens: Array

func _init(raw_tokens_: Array, starting_index: int = -1):
	if starting_index >= raw_tokens_.size() or starting_index < -1:
		assert(false, "Reader starting index (%s) is out of bounds [0, %s]." % [str(starting_index), str(raw_tokens_.size() - 1)])	
	_raw_tokens = raw_tokens_
	_current_index = starting_index
	
	# Set position to last token
	EOF = StoryScriptToken.new("EOF")
	BOF = StoryScriptToken.new("BOF")
	
	if _raw_tokens.size() >= 1:
		EOF.position = _raw_tokens[_raw_tokens.size() - 1].position
		BOF.position = _raw_tokens[0].position

func is_empty():
	return _raw_tokens.size() == 0

func consume(steps_ahead: int = 1):	
	_current_index += steps_ahead
	if _current_index >= _raw_tokens.size() or _current_index < 0:
		return EOF
	return _raw_tokens[_current_index]

func unconsume(steps_back: int = 1):
	_current_index -= steps_back
	if _current_index < 0 or _current_index >= _raw_tokens.size():
		return EOF
	return _raw_tokens[_current_index]

func peek(steps_ahead: int = 1):
	if (_current_index + steps_ahead) >= _raw_tokens.size():
		return EOF
	return _raw_tokens[_current_index + steps_ahead]

func is_EOF():
	return _current_index >= (_raw_tokens.size() - 1)

func clone():
	# Note that this is shallow cloning, which saves on memory usage since
	# only one copy of _raw_tokens is actually stored in memory
	return get_script().new(_raw_tokens, _current_index)

extends Node
class_name InputReader

var text: String setget set_text
var current_index: int

var _text_size: int

func set_text(value: String):
    text = value
    _text_size = text.length()

func peek_ahead(indexes_ahead: int) -> String:
    assert(indexes_ahead >= 1, "indexes_ahead = " + str(indexes_ahead) + ", but indexes_ahead must be >= 1")
    return text[current_index + indexes_ahead]

func peek() -> String:
    return peek_ahead(current_index + 1)

func consume_ahead(indexes_ahead: int) -> String:
    assert(indexes_ahead >= 1, "indexes_ahead = " + str(indexes_ahead) + ", but indexes_ahead must be >= 1")
    current_index += indexes_ahead;
    return text[current_index]

func consume() -> String:
    return consume_ahead(1)

func is_end_of_file() -> bool:
    return current_index >= _text_size - 1
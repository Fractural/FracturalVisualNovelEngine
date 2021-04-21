extends Node
class_name Lexer

var _reader: InputReader
var _token_processors: Array

func _init(__reader: InputReader):
    _reader = __reader

func nextToken():
    var next_char: String = _reader.peek()
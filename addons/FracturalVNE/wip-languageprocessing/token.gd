extends Reference
class_name Token

enum Tokens {
    INT,
    FLOAT,
    FILEPATH,
}

const TokenStrings: Dictionary = {
    0: "INT",
    1: "FLOAT",
    2: "LPAREN",
    3: "RPAREN",
    4: "FILEPATH",
    5: "Character",

}

var type: String
var value

func _init(type_: String, value_):
    type = type_
    value = value_
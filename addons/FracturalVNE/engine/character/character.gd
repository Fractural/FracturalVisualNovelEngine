extends Reference
class_name Character

var name: String
var name_color
var dialogue_color

func _init(name_: String, name_color_ = null, dialogue_color_ = null):
    name = name_
    name_color = name_color_
    dialogue_color = dialogue_color_
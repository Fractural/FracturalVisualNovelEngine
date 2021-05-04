class_name StoryScriptParameter
extends Reference

var name: String
var default_value

func _init(name_: String, default_value_ = null):
	name = name_
	default_value = default_value_

func _to_string():
	return "PARAM %s = %s" %[name, str(default_value)]

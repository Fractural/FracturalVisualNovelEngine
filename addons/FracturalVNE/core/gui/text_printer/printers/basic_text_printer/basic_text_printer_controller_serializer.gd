extends "res://addons/FracturalVNE/core/gui/text_printer/text_printer_controller_serializer.gd"
# Handles serialization for BasicTextPrinterController


func serialize(object):
	var serialized_object = .serialize(object)
	serialized_object["name_text"] = object.name_text_reveal.bbcode_text
	serialized_object["dialogue_text"] = object.dialogue_text_reveal.bbcode_text
	return serialized_object


func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	instance.name_text_reveal.bbcode_text = serialized_object["name_text"]
	instance.dialogue_text_reveal.bbcode_text = serialized_object["dialogue_text"]
	return instance

func _get_controller_prefab():
	return preload("basic_text_printer.tscn")


func _script_path():
	return get_script().get_path().get_base_dir() + "/basic_text_printer_controller.gd"

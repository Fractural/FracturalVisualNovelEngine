extends "res://addons/FracturalVNE/core/actor/actor_controller_serializer.gd"
# Handles serialization for TextPrinterController


func _script_path():
	return get_script().get_path().get_base_dir() + "/text_printer_controller.gd"

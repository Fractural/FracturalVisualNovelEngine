tool
class_name FracVNE_TextPrinter, "res://addons/FracturalVNE/assets/icons/text_printer.svg"
extends "res://addons/FracturalVNE/core/actor/actor.gd"
# Responsible for holding data about TextPrinters and also building them


# ----- Typeable ----- #

func get_types() -> Array:
	return ["Visual"]

# ----- Typeable ----- #


const CharactersDelay = preload("res://addons/FracturalVNE/core/gui/text_printer/printers/components/characters_delay.gd")

export var name_default_char_delay: float = 0
export(Array, Resource) var name_custom_char_delays: Array = [] setget set_name_custom_char_delays

export var dialogue_default_char_delay: float = 0
export(Array, Resource) var dialogue_custom_char_delays: Array = [] setget set_dialogue_custom_char_delays

export var default_name_color: Color = Color.white
export var default_dialogue_color: Color = Color.white

export var controller_prefab_path: String


func _init(cached_ = false, controller_prefab_path_ = "").(cached_):
	controller_prefab_path = controller_prefab_path_
	
	# Default values
	dialogue_custom_char_delays = [
		CharactersDelay.new(",:;", 0.005),
		CharactersDelay.new(".?!", 0.005),
	]
	name_default_char_delay = 0
	dialogue_default_char_delay = 0.01


func _get_controller_prefab_path():
	return controller_prefab_path


func set_name_custom_char_delays(value):
	name_custom_char_delays.resize(value.size())
	name_custom_char_delays = value
	for i in name_custom_char_delays.size():
		if not name_custom_char_delays[i]:
			name_custom_char_delays[i] = FracVNE_CharactersDelay.new()


func set_dialogue_custom_char_delays(value):
	dialogue_custom_char_delays.resize(value.size())
	dialogue_custom_char_delays = value
	for i in dialogue_custom_char_delays.size():
		if not dialogue_custom_char_delays[i]:
			dialogue_custom_char_delays[i] = FracVNE_CharactersDelay.new()


# ----- Serialization ----- #

func serialize():
	var serialized_object = .serialize()
	
	serialized_object["name_default_char_delay"] = name_default_char_delay
	var serialized_name_custom_char_delays = []
	for char_delay in name_custom_char_delays:
		serialized_name_custom_char_delays.append(char_delay.serialize())
	serialized_object["name_custom_char_delays"] = serialized_name_custom_char_delays
	
	serialized_object["dialogue_default_char_delay"] = dialogue_default_char_delay
	var serialized_dialogue_custom_char_delays = []
	for char_delay in dialogue_custom_char_delays:
		serialized_dialogue_custom_char_delays.append(char_delay.serialize())
	serialized_object["dialogue_custom_char_delays"] = serialized_dialogue_custom_char_delays
	
	serialized_object["default_name_color"] = default_name_color
	serialized_object["default_dialogue_color"] = default_dialogue_color
	
	serialized_object["controller_prefab_path"] = controller_prefab_path
	
	return serialized_object


func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	
	instance.name_default_char_delay = serialized_object["name_default_char_delay"]
	var name_custom_char_delays = []
	for serialized_char_delay in serialized_object["name_custom_char_delays"]:
		name_custom_char_delays.append(SerializationUtils.deserialize(serialized_char_delay))
	instance.name_custom_char_delays = name_custom_char_delays
	
	instance.dialogue_default_char_delay = serialized_object["dialogue_default_char_delay"]
	var dialogue_custom_char_delays = []
	for serialized_char_delay in serialized_object["dialogue_custom_char_delays"]:
		dialogue_custom_char_delays.append(SerializationUtils.deserialize(serialized_char_delay))
	instance.dialogue_custom_char_delays = dialogue_custom_char_delays
	
	instance.default_name_color = serialized_object["default_name_color"]
	instance.default_dialogue_color = serialized_object["default_dialogue_color"]
	
	instance.controller_prefab_path = serialized_object["controller_prefab_path"]
	
	return instance

# ----- Serialization ----- #

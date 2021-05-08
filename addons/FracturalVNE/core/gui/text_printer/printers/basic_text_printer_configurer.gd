extends Node

const TextPrinter = preload("res://addons/FracturalVNE/core/gui/text_printer/text_printer.gd")
const CharactersDelay = preload("res://addons/FracturalVNE/core/gui/text_printer/printers/components/characters_delay.gd")

export var text_printer_path: NodePath
onready var text_printer: TextPrinter = get_node(text_printer_path)

func _ready():
	text_printer.dialogue_custom_char_delays = [
		CharactersDelay.new(",:;", 0.05),
		CharactersDelay.new(".?!", 0.05),
	]

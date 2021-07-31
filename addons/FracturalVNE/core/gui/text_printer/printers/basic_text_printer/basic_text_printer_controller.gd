extends "res://addons/FracturalVNE/core/gui/text_printer/text_printer_controller.gd"
# Basic implementation of a TextPrinterController.


const CharactersDelay = preload("res://addons/FracturalVNE/core/gui/text_printer/printers/components/characters_delay.gd")
const TextPrinterController = preload("res://addons/FracturalVNE/core/gui/text_printer/text_printer_controller.gd")
const TextReveal = preload("res://addons/FracturalVNE/core/gui/text_printer/printers/components/text_reveal.gd")

export var name_text_reveal_path: NodePath
export var dialogue_text_reveal_path: NodePath

var active_text_reveal_count: int = 0

onready var name_text_reveal: TextReveal = get_node(name_text_reveal_path)
onready var dialogue_text_reveal: TextReveal = get_node(dialogue_text_reveal_path)


func init(text_printer_ = null, story_director_ = null):
	.init(text_printer_, story_director_)
	# Keep process off until need to animate text
	set_process(true)

	name_text_reveal.init(get_text_printer().name_default_char_delay, get_text_printer().name_custom_char_delays);
	dialogue_text_reveal.init(get_text_printer().dialogue_default_char_delay, get_text_printer().dialogue_custom_char_delays);
	
	# Clear the text fields on startup
	name_text_reveal.bbcode_text = ""
	dialogue_text_reveal.bbcode_text = ""
	
	name_text_reveal.connect("finished_reveal", self, "_on_finish_text_reveal")
	dialogue_text_reveal.connect("finished_reveal", self, "_on_finish_text_reveal")


func _on_finish_text_reveal():
	if active_text_reveal_count > 0:
		active_text_reveal_count -= 1
		if active_text_reveal_count == 0:
			_finished_print_text()


func say(character, text: String, skippable: bool = true):
	.say(character, text, skippable)
	if typeof(character) == TYPE_STRING:
		character = Character.new(character, get_text_printer().default_name_color, get_text_printer().default_dialogue_color)
	
	var name_color: Color = character.name_color if character.name_color != null else get_text_printer().default_name_color
	name_text_reveal.bbcode_text = "[color=#" + name_color.to_html() + "]" + character.name + "[/color]"
	name_text_reveal.start_reveal()

	var dialogue_color: Color = character.dialogue_color if character.dialogue_color != null else get_text_printer().default_dialogue_color
	dialogue_text_reveal.bbcode_text = "[color=#" + character.dialogue_color.to_html() + "]" + text + "[/color]"
	dialogue_text_reveal.start_reveal()
	
	active_text_reveal_count = 2


func narrate(text: String, skippable: bool = true):
	.narrate(text, skippable)
	name_text_reveal.bbcode_text = ""

	dialogue_text_reveal.bbcode_text = text
	dialogue_text_reveal.start_reveal()
	
	active_text_reveal_count = 1


func _on_skip():
	name_text_reveal.stop_reveal()
	dialogue_text_reveal.stop_reveal()


# ----- Serialization ----- #

# basic_text_printer_serializer.gd

# ----- Serialization ----- #

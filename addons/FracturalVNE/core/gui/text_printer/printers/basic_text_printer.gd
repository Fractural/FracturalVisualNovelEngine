extends Node
# Basic implementation of a TextPrinter.


const Character = preload("res://addons/FracturalVNE/core/character/character.gd")
const CharactersDelay = preload("res://addons/FracturalVNE/core/gui/text_printer/printers/components/characters_delay.gd")
const TextPrinter = preload("res://addons/FracturalVNE/core/gui/text_printer/text_printer.gd")
const TextReveal = preload("res://addons/FracturalVNE/core/gui/text_printer/printers/components/text_reveal.gd")

export var text_printer_path: NodePath
export var name_text_reveal_path: NodePath
export var dialogue_text_reveal_path: NodePath

var active_text_reveal_count: int = 0

onready var text_printer: TextPrinter = get_node(text_printer_path)
onready var name_text_reveal: TextReveal = get_node(name_text_reveal_path)
onready var dialogue_text_reveal: TextReveal = get_node(dialogue_text_reveal_path)


func _ready():
	# Keep process off until need to animate text
	set_process(true)

	text_printer.connect("say", self, "_on_say")
	text_printer.connect("narrate", self, "_on_narrate")
	text_printer.connect("skip", self, "_on_skip")
	text_printer.connect("serialize_state", self, "_on_serialize_state")
	text_printer.connect("deserialize_state", self, "_on_deserialize_state")

	name_text_reveal.init(text_printer.name_default_char_delay, text_printer.name_custom_char_delays);
	dialogue_text_reveal.init(text_printer.dialogue_default_char_delay, text_printer.dialogue_custom_char_delays);
	
	# Clear the text fields on startup
	name_text_reveal.bbcode_text = ""
	dialogue_text_reveal.bbcode_text = ""
	
	name_text_reveal.connect("finished_reveal", self, "_on_finish_text_reveal")
	dialogue_text_reveal.connect("finished_reveal", self, "_on_finish_text_reveal")


func _on_finish_text_reveal():
	if active_text_reveal_count > 0:
		active_text_reveal_count -= 1
		if active_text_reveal_count == 0:
			text_printer._finished_print_text()


func _on_say(character, text):
	if typeof(character) == TYPE_STRING:
		character = Character.new(character, text_printer.default_name_color, text_printer.default_dialogue_color)
	
	var name_color: Color = character.name_color if character.name_color != null else text_printer.default_name_color
	name_text_reveal.bbcode_text = "[color=#" + name_color.to_html() + "]" + character.name + "[/color]"
	name_text_reveal.start_reveal()

	var dialogue_color: Color = character.dialogue_color if character.dialogue_color != null else text_printer.default_dialogue_color
	dialogue_text_reveal.bbcode_text = "[color=#" + character.dialogue_color.to_html() + "]" + text + "[/color]"
	dialogue_text_reveal.start_reveal()
	
	active_text_reveal_count = 2


func _on_narrate(text: String):
	name_text_reveal.bbcode_text = ""

	dialogue_text_reveal.bbcode_text = text
	dialogue_text_reveal.start_reveal()
	
	active_text_reveal_count = 1


func _on_skip():
	name_text_reveal.stop_reveal()
	dialogue_text_reveal.stop_reveal()


# ----- Serialization ----- #

func _on_serialize_state(serialized_state):
	serialized_state["name_text"] = name_text_reveal.bbcode_text
	serialized_state["dialogue_text"] = dialogue_text_reveal.bbcode_text


func _on_deserialize_state(serialized_state):
	name_text_reveal.bbcode_text = serialized_state["name_text"]
	dialogue_text_reveal.bbcode_text = serialized_state["dialogue_text"]

# ----- Serialization ----- #

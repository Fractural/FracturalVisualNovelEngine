extends Node

export var _text_printer_path: NodePath
onready var text_printer: TextPrinter = get_node(_text_printer_path)

export var _name_text_reveal_path: NodePath
onready var name_text_reveal: TextReveal = get_node(_name_text_reveal_path)

export var _dialogue_text_reveal: NodePath
onready var dialogue_text_reveal: TextReveal = get_node(_dialogue_text_reveal)

export var default_name_color: Color 
export var default_dialogue_color: Color

func _ready():
	# Keep process off until need to animate text
	set_process(true)

	text_printer.connect("say", self, "_on_say")
	text_printer.connect("narrate", self, "_on_narrate")
	text_printer.connect("skip", self, "_on_skip")

	name_text_reveal._init(text_printer.name_default_char_delay, text_printer.name_custom_char_delays);
	dialogue_text_reveal._init(text_printer.dialogue_default_char_delay, text_printer.dialogue_custom_char_delays);

func _on_say(character: Character, text: String):
	var name_color: Color = character.name_color if character.name_color != null else default_name_color
	name_text_reveal.bbcode_text = "[color=" + name_color.to_html() + "]" + character.name + "[/color]"
	name_text_reveal.start_reveal()

	var dialogue_color: Color = character.dialogue_color if character.dialogue_color != null else default_dialogue_color
	dialogue_text_reveal.bbcode_text = "[color=" + character.text_color.to_html() + "]" + text + "[/color]"
	dialogue_text_reveal.start_reveal()

func _on_narrate(text: String):
	name_text_reveal.bbcode_text = ""

	dialogue_text_reveal.bbcode_text = text
	dialogue_text_reveal.start_reveal()

func _on_skip():
	name_text_reveal.stop_reveal()
	dialogue_text_reveal.stop_reveal()
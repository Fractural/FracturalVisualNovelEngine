extends "res://addons/FracturalVNE/core/gui/history_menu/history_entry_display.gd"


export var name_label_path: NodePath
export var dialogue_label_path: NodePath

onready var name_label: RichTextLabel = get_node(name_label_path)
onready var dialogue_label: RichTextLabel = get_node(dialogue_label_path)


func init(history_entry):
	.init(history_entry)
	
	if history_entry.character != null:
		if typeof(history_entry.character) == TYPE_STRING:
			name_label.bbcode_text = "[right]" + history_entry.character
			dialogue_label.bbcode_text = history_entry.text
		else:
			name_label.bbcode_text = "[right][color=#" + history_entry.character.name_color.to_html() + "]" + history_entry.character.name + "[/color]"
			dialogue_label.bbcode_text = "[color=#" + history_entry.character.dialogue_color.to_html() + "]" + history_entry.text + "[/color]"
	else:
		name_label.bbcode_text = ""
		dialogue_label.bbcode_text = history_entry.text

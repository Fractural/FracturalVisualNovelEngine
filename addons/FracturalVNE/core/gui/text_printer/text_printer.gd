extends Node

# ----- StoryService Info ----- #

var function_definitions = [
	StoryScriptFuncDef.new("skip"),
	StoryScriptFuncDef.new("say", [
		"character",
		"text",
	]),
	StoryScriptFuncDef.new("narrate", [
		"text",
	])
]

func get_service_name():
	return "TextPrinter"

# --- StoryService Info End --- #

const Character = preload("res://addons/FracturalVNE/core/character/character.gd")

signal skip
signal say(character, text)
signal narrate(text)

export var name_default_char_delay: float = 0
export var name_custom_char_delays: Array = []

export var dialogue_default_char_delay: float = 0
export var dialogue_custom_char_delays: Array = []

func skip():
	emit_signal("skip")

func say(character: Character, text: String):
	emit_signal("say", character, text)

func narrate(text: String):
	emit_signal("narrate", text)

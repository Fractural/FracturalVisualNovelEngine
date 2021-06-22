extends Node

const Character = preload("res://addons/FracturalVNE/core/character/character.gd")

export var story_gui_configurer_path: NodePath

onready var story_gui_configurer = get_node(story_gui_configurer_path)

# Optional
var function_definitions

func _post_ready():
	function_definitions = [
	StoryScriptFuncDef.new("Character", [
		StoryScriptParameter.new("name"),
		StoryScriptParameter.new("name_color", story_gui_configurer.get_story_gui().text_printer.default_name_color),
		StoryScriptParameter.new("dialogue_color", story_gui_configurer.get_story_gui().text_printer.default_dialogue_color),
		]),
	]

# Optional
func configure_service(program_node):
	pass

func get_service_name():
	return "CharacterManager"

func Character(name_: String, name_color_, dialogue_color_):
	if typeof(name_color_) == TYPE_STRING:
		name_color_ = Color(name_color_)
	if typeof(dialogue_color_) == TYPE_STRING:
		dialogue_color_ = Color(dialogue_color_)
	return Character.new(name_, name_color_, dialogue_color_)

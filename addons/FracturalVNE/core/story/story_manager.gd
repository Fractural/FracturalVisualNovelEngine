 extends Node
class_name StoryManager

const TextPrinter = preload("res://addons/FracturalVNE/core/gui/text_printer/text_printer.gd")

signal stepped;

var auto_step: bool = false setget set_auto_step

#TODO: Each class below must implement _on_stepped method
var text_printer: TextPrinter # TODO: Write TextPrinter
var animation_manager#: AnimationManager # TODO. Use AnimationPlayer.advance() to skip player if player steps early
var character_manager#: CharacterManager # TODO. SHould use SpriteManager to manage sprite
var sprite_manager#: SpriteManager # TODO
var sound_manager# : SoundManager # TODO

var abstract_syntax_tree;

func _ready():
	pass
	# TODO: Fetch the dependencies (printer, asset_loader, etc)
	
	#connect("stepped", text_printer, "_on_stepped")
	#connect("stepped", animation_manager, "_on_stepped")
	#connect("stepped", character_manager, "_on_stepped")
	#connect("stepped", sprite_manager, "_on_stepped")
	#connect("stepped", sound_manager, "_on_stepped")

# TODO
func load_story(story):
	action = story._load_story_tree()

func set_auto_step(value: bool):
	if auto_step == value:
		return
	
	auto_step = value
	#TODO Make a blocker system and make set auto step only step once blocker is unblocked
	
func step():
	emit_signal("stepped")

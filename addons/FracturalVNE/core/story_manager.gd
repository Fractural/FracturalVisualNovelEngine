extends Node
class_name StoryManager

signal stepped;

var auto_step: bool = false

#TODO: Each class below must implement _on_stepped method
var text_printer#: TextPrinter # TODO: Write TextPrinter
var animation_manager#: AnimationManager # TODO. Use AnimationPlayer.advance() to skip player if player steps early
var character_manager#: CharacterManager # TODO. SHould use SpriteManager to manage sprite
var sprite_manager#: SpriteManager # TODO
var sound_manager# : SoundManager # TODO

var actions: Array

func _ready():
	# TODO: Fetch the dependencies (printer, asset_loader, etc)
	
	connect("stepped", text_printer, "_on_stepped")
	connect("stepped", animation_manager, "_on_stepped")
	connect("stepped", character_manager, "_on_stepped")
	connect("stepped", sprite_manager, "_on_stepped")
	connect("stepped", sound_manager, "_on_stepped")

	actions = []

func load_story(story):
	actions = story._load_story(self)

func step():
	emit_signal("stepped")

extends Node
# Creates and stores all the characters used in a story.


# ----- StoryService ----- #

var function_definitions


func configure_service(program_node):
	characters = []


func get_service_name():
	return "CharacterManager"

# ----- StoryService ----- #


const Character = preload("res://addons/FracturalVNE/core/character/character.gd")

export var reference_registry_path: NodePath
export var story_gui_configurer_path: NodePath

var characters: Array

onready var reference_registry = get_node(reference_registry_path)
onready var story_gui_configurer = get_node(story_gui_configurer_path)


func _enter_tree():
	StoryServiceRegistry.add_service(self)


func _post_ready():
	function_definitions = [
		StoryScriptFuncDef.new("Character", [
			StoryScriptParameter.new("name"),
			StoryScriptParameter.new("name_color", story_gui_configurer.story_gui.text_printer.default_name_color),
			StoryScriptParameter.new("dialogue_color", story_gui_configurer.story_gui.text_printer.default_dialogue_color),
		]),
	]


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		StoryServiceRegistry.remove_service(self)


func add_character(character):
	characters.append(character)


func Character(name_: String, name_color_, dialogue_color_):
	if typeof(name_color_) == TYPE_STRING:
		name_color_ = Color(name_color_)
	if typeof(dialogue_color_) == TYPE_STRING:
		dialogue_color_ = Color(dialogue_color_)
	var new_character = Character.new(name_, name_color_, dialogue_color_)
	new_character._story_init()
	return new_character


# ----- Serialization ----- #

# characters will be populated automatically by Character variables when they 
# are deserialized in a BlockNode.

func serialize_state():
	var character_ids = []
	for character in characters:
		character_ids.append(reference_registry.get_reference_id(character))

	return { 
		"service_name": get_service_name(),
		"character_ids": character_ids, 
	}


func deserialize_state(serialized_state):
	characters = []
	for character_id in serialized_state["character_ids"]:
		characters.append(reference_registry.get_reference(character_id))

# ----- Serialization ----- #

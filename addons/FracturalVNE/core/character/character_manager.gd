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

export var story_gui_configurer_path: NodePath

var characters: Array

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


func get_character_id(character):
	# The index of the characters array acts as the UID
	# of a character. Note that this breaks backwards compatability
	# of save files.
	var id = characters.find(character)
	assert(id > -1, "Character not found in CharacterManager.")
	return id


func get_character(id):
	return characters[id]


func Character(name_: String, name_color_, dialogue_color_):
	if typeof(name_color_) == TYPE_STRING:
		name_color_ = Color(name_color_)
	if typeof(dialogue_color_) == TYPE_STRING:
		dialogue_color_ = Color(dialogue_color_)
	characters.append(Character.new(name_, name_color_, dialogue_color_))
	return characters.back()


# ----- Serialization ----- #

func serialize_state():
	var serialized_characters = []
	for character in characters:
		serialized_characters.append(character.serialize())
	
	return { 
		"service_name": get_service_name(),
		"characters": serialized_characters, 
	}


func deserialize_state(serialized_state):
	characters = []
	for serialized_character in serialized_state["characters"]:
		characters.append(SerializationUtils.deserialize(serialized_character))

# ----- Serialization ----- #

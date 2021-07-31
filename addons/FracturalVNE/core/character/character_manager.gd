extends Node
# Creates and stores all the characters used in a story.


# ----- StoryService ----- #

const FuncDef = FracVNE.StoryScript.FuncDef
const Param = FracVNE.StoryScript.Param

var function_definitions


func configure_service(program_node):
	characters = []


func get_service_name():
	return "CharacterManager"

# ----- StoryService ----- #


const Character = preload("character.gd")

export var reference_registry_path: NodePath
export var text_printer_manager_path: NodePath

var characters: Array

onready var reference_registry = get_node(reference_registry_path)
onready var text_printer_manager = get_node(text_printer_manager_path)


func _post_ready():
	function_definitions = [
		FuncDef.new("Character", [
			Param.new("name"),
			Param.new("name_color", text_printer_manager.get_default_text_printer().default_name_color),
			Param.new("dialogue_color", text_printer_manager.get_default_text_printer().default_dialogue_color),
			Param.new("visual")
		]),
	]


func add_character(character):
	characters.append(character)


# Used in the StoryScript to create a new character that will be serialized when 
# the story is saved. 
func Character(name_, name_color_, dialogue_color_, visual_):
	if typeof(name_color_) == TYPE_STRING:
		name_color_ = Color(name_color_)
	if typeof(dialogue_color_) == TYPE_STRING:
		dialogue_color_ = Color(dialogue_color_)
	
	# Type safety checks
	if typeof(name_) != TYPE_STRING:
		return FracVNE.StoryScript.Error.new("Expected name to be a string.")
	if typeof(name_color_) != TYPE_COLOR:
		return FracVNE.StoryScript.Error.new("Expected name_color to be a Color or a string.")
	if typeof(dialogue_color_) != TYPE_COLOR:
		return FracVNE.StoryScript.Error.new("Expected dialogue_color to be a Color or a string.")
	
	var new_character = Character.new(name_, name_color_, dialogue_color_, visual_)
	reference_registry.add_reference(new_character)
	add_character(new_character)
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

extends Node
# Handles importing stories in the current story.
# This should be placed before all services that traverse the entire
# story since this reconstructs the entire AST.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StoryService", get_service_name()]

# ----- Typeable ----- #


# ----- StoryService ----- #

# Optional
# Configures a service for a new AST.
# (program_node is the root of the AST).
func configure_service(program_node):
	pass


func get_service_name():
	return "StoryImportManager"

# ----- StoryService ----- #


const SSUtils = FracVNE.StoryScript.Utils
const ImportedStory = preload("imported_story.gd")

export var story_loader_path: NodePath
export var story_manager_path: NodePath

var imported_stories: Array = []

onready var story_loader = get_node(story_loader_path)
onready var story_manager = get_node(story_manager_path)


# Call order of functions inside ImportStatement:
# configure_node()
# runtime_initialize():
# 	StoryImportManager.import(self)
#		story_block.configure_node()
#		story_block.runtime_initialize()
func import_story(story_file_path, import_statement_reference_id, position):
	# If the imprort story's file path is the same as the file path of the 
	# current story or the file path of previously imported stories, then 
	# stop importing to prevent a cyclical import that would crash the game.
	var is_cyclical_import = story_file_path == story_manager.story_file_path
	if not is_cyclical_import:
		for imported_story in imported_stories:
			if story_file_path == imported_story.story_file_path:
				is_cyclical_import = true
				break
	if is_cyclical_import:
		push_warning("Cyclical import detected and stopped at %s. Is this intentional?" % position.to_one_indexed_string())
		return null
	 
	imported_stories.append(ImportedStory.new(story_file_path, import_statement_reference_id))
	
	var story_block = story_loader.load_story_block(story_file_path)
	if not SSUtils.is_success(story_block):
		return story_block
	
	return story_block


# ----- Serialization ----- #

func serialize_state() -> Dictionary:
	var serialized_imported_stories = []
	for imported_story in imported_stories:
		serialized_imported_stories = imported_story.serialize()
	return {
		"service_name": get_service_name(),
		"imported_stories": serialized_imported_stories,
	}


func deserialize_state(serialized_state) -> void:
	imported_stories = []
	for serialized_imported_story in serialized_state["imported_stories"]:
		imported_stories.append(SerializationUtils.deserialize(serialized_imported_story))

# ----- Serialization ----- #

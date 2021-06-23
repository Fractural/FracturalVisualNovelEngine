extends Node
# Keeps track of a users past interactions in a story.
# TODO: Make history_manager store only one reference to each charcter.


# ----- StoryService ----- #

func configure_service(program_node):
	history_stack = []


func get_service_name():
	return "HistoryManager"

# ----- StoryService ----- #


export var story_director_path: NodePath

var history_stack = []

onready var story_director = get_node(story_director_path)


func add_entry(history_entry):
	history_stack.append(history_entry)


# ----- Serialization ----- #

# NOTE: We must deserialize the history state last since it may contain
# 		reference IDs that must be converted back to the actual object
#		(such as with the character IDs in SayEntry).

func serialize_state():
	var serialized_history_stack = []
	for entry in history_stack:
		serialized_history_stack.append(entry.serialize())
	
	return {
		"service_name": get_service_name(),
		"history_stack": serialized_history_stack,
	}

func deserialize_state(serialized_state):
	history_stack = []
	for serialized_entry in serialized_state["history_stack"]:
		history_stack.append(SerializationUtils.deserialize(serialized_entry))

# ----- Serialization ----- #

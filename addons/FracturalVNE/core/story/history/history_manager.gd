extends Node
# Keeps track of a users past interactions in a story.
# TODO: Maybe rename HistoryManager to StoryHistoryManager for consistency
# 		(Since other services are called StoryDirector, etc.)


# ----- StoryService ----- #

func configure_service(program_node):
	history_stack = []


func get_service_name():
	return "HistoryManager"

# ----- StoryService ----- #


signal entry_added(history_entry)
signal entry_removed(history_entry)
signal entries_cleared()

export var story_director_path: NodePath
export var serialization_manager_path: NodePath

var history_stack = []

onready var story_director = get_node(story_director_path)
onready var serialization_manager = get_node(serialization_manager_path)


func add_entry(history_entry):
	history_stack.append(history_entry)
	emit_signal("entry_added", history_entry)


func remove_entry(history_entry):
	history_stack.erase(history_entry)
	emit_signal("entry_removed", history_entry)


func clear_entries():
	history_stack.clear()
	emit_signal("entries_cleared")


# ----- Serialization ----- #

# NOTE: We must deserialize the history state last since it may contain
# 		reference IDs that must be converted back to the actual object
#		(such as with the character IDs in SayEntry).

func serialize_state():
	var serialized_history_stack = []
	for entry in history_stack:
		serialized_history_stack.append(serialization_manager.serialize(entry))
	
	return {
		"service_name": get_service_name(),
		"history_stack": serialized_history_stack,
	}


func deserialize_state(serialized_state):
	clear_entries()
	for serialized_entry in serialized_state["history_stack"]:
		add_entry(serialization_manager.deserialize(serialized_entry))

# ----- Serialization ----- #

extends Node


export var entries_holder_path: NodePath
export(Array, PackedScene) var entry_prefabs: Array = []

onready var entries_holder = get_node(entries_holder_path)
onready var history_manager = StoryServiceRegistry.get_service("HistoryManager")


func _ready():
	history_manager.connect("entry_added", self, "_on_entry_added")
	history_manager.connect("entry_removed", self, "_on_entry_removed")
	history_manager.connect("entries_cleared", self, "_on_entries_cleared")


func _get_entry_prefab(history_entry):
	var entry_type = history_entry.get_script().get_path().get_basename().get_file().to_lower().replace("_", "")
	for prefab in entry_prefabs:
		# Checks if the prefab file name contains the type name of the history entry.
		# This check works with any sort of naming style, whether it's
		# PascalCase, camelCase, or snake_case. 
		var prefab_name = prefab.get_path().get_basename().get_file().to_lower().replace("_", "")
		if entry_type in prefab_name:
			return prefab
	return null


func _on_entry_added(history_entry):
	var entry_instance = _get_entry_prefab(history_entry).instance()
	entries_holder.add_child(entry_instance)
	entry_instance.init(history_entry)


func _on_entry_removed(history_entry):
	for i in entries_holder.get_child_count():
		if entries_holder.get_child(i).entry == history_entry:
			entries_holder.get_child(i).queue_free()
			break


func _on_entries_cleared():
	for entry_instance in entries_holder.get_children():
		entry_instance.queue_free()

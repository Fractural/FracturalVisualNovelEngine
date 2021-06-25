extends Node

var current_script_path: String = ""
var compiled: bool = false
var saved: bool = false

var service_already_exists: bool = false
var entered_tree_before: bool = false 

# TODO: Figure out if autoload works in editor. I doubt it tbh, but this persitent 
#		data is only used for the standalone so it doesn't really matter.

func _enter_tree():
	if entered_tree_before:
		return
	entered_tree_before = true
	
	if StoryServiceRegistry.has_service(self):
		service_already_exists = true
		queue_free()
	else:
		StoryServiceRegistry.add_persistent_service(self)

func _notification(what):
	if what == NOTIFICATION_PREDELETE and not service_already_exists:
		StoryServiceRegistry.remove_service(self)

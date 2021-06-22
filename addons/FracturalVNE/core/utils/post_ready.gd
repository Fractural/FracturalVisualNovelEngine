extends Node

signal post_ready()

func _enter_tree():
	StoryServiceRegistry.add_service(self)

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		StoryServiceRegistry.remove_service(self)

# Called when the node enters the scene tree for the first time.
func _ready():
	propagate_call("_post_ready")
	emit_signal("post_ready")

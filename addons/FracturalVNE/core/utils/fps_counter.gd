extends Node


export var label_path: NodePath

onready var label = get_node(label_path)


# Called when the node enters the scene tree for the first time.
func _process(delta) -> void:
	label.text = "FPS: %s" % str(Engine.get_frames_per_second())

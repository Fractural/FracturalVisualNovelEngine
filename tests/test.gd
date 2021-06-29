tool
extends Node

func _ready():
	print(get_path())
	print("IS IN SCENE TAB? " + str(_is_in_editor_scene_tab(get_parent())))

func _is_in_editor_scene_tab(parent):
	if Engine.is_editor_hint():
		# Only tested so far to work on Godot 3.3
		if parent.name == "@@5903":
			return true
		elif parent == null:
			return false
		return _is_in_editor_scene_tab(parent.get_parent())
	return false

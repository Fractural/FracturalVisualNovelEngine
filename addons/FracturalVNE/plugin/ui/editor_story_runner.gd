extends Node
# Runs a play test scene from the editor for the in-editor StoryScriptEditor.


# ----- Typeable ----- #

func is_type(type: String) -> bool:
	return get_types().has(type)

static func get_types() -> Array:
	return ["StoryRunner", "EditorStoryRunner"]

# ----- Typeable ----- #


func run(story_file_path: String, quit_to_scene: PackedScene = null):
	# TODO: Implement running a story scene from the editor
	pass

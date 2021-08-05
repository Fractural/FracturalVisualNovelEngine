extends Node
# Manages scene changes and transitions between scenes.

# TODO: Create an "add_child(child)" method to SceneManager that
# 		adds a child to a given node while also calling "post_ready"
#		on the object. Maybe use a Command design pattern to implement
#		this, where each Command is another custom call (like "_post_ready()")
#		to the node.


# ----- Typeable ----- #
func get_types() -> Array:
	return ["SceneManager"]

# ----- Typeable ----- #


signal scene_loaded(loaded_scene)
signal scene_readied(readied_scene)

export var initial_scene: PackedScene


func goto_initial_scene():
	if initial_scene != null:
		goto_scene(initial_scene)


func goto_scene(scene):
	# If the scene is a scene path, load the PackedScene from the path
	if typeof(scene) == TYPE_STRING:
		scene = load(scene)
	
	# Yield to prevent a newly loaded scene from immediately calling 
	# "goto_scene()" again in " _ready()".
	yield (get_tree(), "idle_frame")
	
	get_tree().current_scene.queue_free()
	
	var new_scene = scene.instance()
	
	emit_signal("scene_loaded", new_scene)
	
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	
	emit_signal("scene_readied", new_scene)


func transition_to_scene(scene):
	# TODO: Finish adding transitions to scenes
	goto_scene(scene)

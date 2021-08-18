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


signal node_added(node)
signal node_removed(node)
signal scene_loaded(loaded_scene)
signal scene_readied(readied_scene)

const FracUtils = FracVNE.Utils

export var is_self_contained: bool = false
# By default this SceneManager lets the DIContainer
# load the intial scene.
export var auto_load_initial_scene: bool = false
export var initial_scene: PackedScene

# current_scene will only be used if we are not running in
# self contained mode.
var current_scene setget set_current_scene, get_current_scene


func _ready():
	get_tree().connect("node_added", self, "_on_node_added")
	get_tree().connect("node_removed", self, "_on_node_removed")
	
	if auto_load_initial_scene:
		print("autoloading initial scene")
		goto_initial_scene()


func set_current_scene(new_scene) -> void:
	if is_self_contained:
		current_scene = new_scene
	else:
		get_tree().current_scene = new_scene


func get_current_scene() -> Node:
	if is_self_contained:
		return current_scene
	else:
		return get_tree().current_scene


func get_root() -> Node:
	if is_self_contained:
		return self
	else:
		return get_tree().root


func goto_initial_scene():
	if initial_scene != null:
		goto_scene(initial_scene)


func goto_scene(scene):
	# If the scene is a scene path, load the PackedScene from the path
	if typeof(scene) == TYPE_STRING:
		scene = load(scene)
	
	if get_current_scene() != null:
		get_current_scene().queue_free()
	
	# We cannot immediately create the next scene
	# since we have to wait for the current scene
	# to free itself (It's queue_freed after all).
	yield(get_tree(), "idle_frame")
	
	var new_scene = scene.instance()
	
	emit_signal("scene_loaded", new_scene)
	
	get_root().add_child(new_scene)
	set_current_scene(new_scene)
	
	emit_signal("scene_readied", new_scene)


func transition_to_scene(scene):
	# TODO: Finish adding transitions to scenes
	goto_scene(scene)


func _on_node_added(added_node: Node):
	if is_self_contained and not FracUtils.has_parent(added_node, self):
		# If we are in self contained mode and the added node
		# is not a child of the SceneManager, then it's not our
		# SceneManager's node so we are not emitting a signal for it.
		return
	emit_signal("node_added", added_node)


func _on_node_removed(removed_node: Node):
	if is_self_contained and not FracUtils.has_parent(removed_node, self):
		# If we are in self contained mode and the removed_nod
		# is not a child of the SceneManager, then it's not our
		# SceneManager's node so we are not emitting a signal for it.
		return
	emit_signal("node_removed", removed_node)

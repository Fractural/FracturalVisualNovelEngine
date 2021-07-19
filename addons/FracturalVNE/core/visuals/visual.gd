extends Node2D


# ----- Typeable ----- #

func is_type(type: String) -> bool:
	return get_types().has(type)


static func get_types() -> Array:
	return ["Visual"]

# ----- Typeable ----- #


export var visual_animator_path: NodePath

var visual_animator
var is_hide_animation: bool = false


func _ready():
	if visual_animator == null:
		visual_animator = get_node(visual_animator_path)
	visual_animator.connect("animation_finished", self, "_on_animation_finished")


func init(story_director):
	visual_animator = get_node(visual_animator_path)
	visual_animator.init(story_director)


func show(animation = null, animation_action = null):
	visible = true
	if animation != null:
		visual_animator.play_animation(animation, animation_action)


func hide(animation = null, animation_action = null):
	if animation != null:
		visual_animator.play_animation(animation, animation_action)
		is_hide_animation = true
	else:
		visible = false


# If we are animating the hiding of a visual, we want to only hide the 
# visual once the hiding animation finishes. 
func _on_animation_finished(animation_name, skipped):
	if is_hide_animation:
		visible = false
		is_hide_animation = false

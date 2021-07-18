extends Node2D


# ----- Typeable ----- #

func is_type(type: String) -> bool:
	return get_types().has(type)


static func get_types() -> Array:
	return ["Visual"]

# ----- Typeable ----- #


export var visual_animator_path: NodePath

onready var visual_animator = get_node(visual_animator_path)

var is_hide_animation: bool = false


func _ready():
	visual_animator.connect("animation_finished", self, "_on_animation_finished")


func init(name_):
	name = name_


func show(animation = null):
	visible = true
	if animation != null:
		visual_animator.play_animation(animation)


func hide(animation = null):
	if animation != null:
		visual_animator.play_animation(animation)
		is_hide_animation = true
	else:
		visible = false


# If we are animating the hiding of a visual, we want to only hide the 
# visual once the hiding animation finishes. 
func _on_animation_finished(animation_name, skipped):
	if is_hide_animation:
		visible = false
		is_hide_animation = false

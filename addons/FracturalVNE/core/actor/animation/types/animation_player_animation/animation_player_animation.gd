extends "res://addons/FracturalVNE/core/actor/animation/actor_animation.gd"
# Visual animation that uses an animation player to animate


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("AnimationPlayerActorAnimation")
	return arr

# ----- Typeable ----- #


export var animation_player_path: NodePath

onready var animation_player: AnimationPlayer = get_node(animation_player_path)


func _ready():
	animation_player.connect("animation_finished", self, "_on_animation_player_animation_finished")
	set_process(false)


func animate(visual_holder_):
	# Note that the visual_holder should be the animation_player's root node.
	.animate(visual_holder_)
	animation_player.root_node = visual_holder_.get_path()
	animation_player.play()


func _on_animation_finished(skipped):
	if skipped:
		animation_player.seek(animation_player.current_animation_length, true)
	
	._on_animation_finished(skipped)


func _on_animation_player_animation_finished(animation_name):
	_on_animation_finished(false)

extends Node


signal animation_finished(animation_name)

export var visual_path: NodePath
export var animation_player_path: NodePath

onready var visual = get_node(visual_path)
onready var animation_player: AnimationPlayer = get_node(animation_player_path)

# This holder is moved during animations and then the entire Visual
# is then repositioned to this holder's position after the animation ends.
# This allows animations to permenantly affect the position of the Visual
# and allow future animations to also modify the position of the Visual
# since the visual_holder will always be at origin (0,0) before
# each animation is played.
# 
# The visual_holder should be the animation_player's root node.
onready var visual_holder = animation_player.root_node


func _ready():
	animation_player.connect("animation_finished", self, "_on_animation_finished")


# All animaitons played on a visual must operate on the visual_holder.
func play_animation(animation):
	animation_player.add_animation("CurrentAnimation", animation)
	animation_player.play("CurrentAnimation")


func skip_current_animation():
	animation_player.seek(animation_player.current_animation_length)
	# "AnimationPlayer.animation_finished" signal is not called if we 
	# skip to the end, therefore we must manually call the listener method.
	_on_animation_finished("CurrentAnimation")


func _on_animation_finished(animation_name):
	if animation_name == "CurrentAnimation":
		animation_player.remove_animation("CurrentAnimation")
	
	# Move the visual to the visual_holder's position to
	# reset the visual_holder's position to (0, 0) which allows 
	# a future animation to play starting from (0, 0).
	visual.global_position = visual_holder.global_posittion
	visual_holder.position = Vector2.ZERO 
	
	emit_signal("animation_finished", animation_name)

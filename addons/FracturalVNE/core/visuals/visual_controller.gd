extends Node
# Handles playing animations on a visual.


export var animation_player_path: NodePath
export var sprite_path: NodePath

onready var animation_player = get_node(animation_player_path)
onready var sprite = get_node(sprite_path)


func set_sprite(texture):
	sprite.texture = texture


# All animaitons played on a visual must operate on a Node2D named "Character".
func play_animation(animation):
	animation_player.add_animation("CurrentAnimation", animation)
	animation_player.play("CurrentAnimation")


func skip_current_animation():
	animation_player.seek(animation_player.current_animation_length)
	# "AnimationPlayer.animation_finished" signal is not called if we 
	# skip to the end, therefore we must manually call the listener method.
	_animation_finished("CurrentAnimation")


func _animation_finished(animation_name):
	if animation_name == "CurrentAnimation":
		animation_player.remove_animation("CurrentAnimation")

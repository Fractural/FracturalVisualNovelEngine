extends Node


signal animation_finished(animation_name, skipped)

export var visual_path: NodePath
export var animation_player_path: NodePath
export var story_director_dep_path: NodePath

var curr_animation_action

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
onready var visual_holder = animation_player.get_node(animation_player.root_node)
onready var story_director_dep = get_node(story_director_dep_path)


func _ready():
	animation_player.connect("animation_finished", self, "_on_animation_finished", [false])


func init(story_director_):
	story_director_dep = get_node(story_director_dep_path)
	story_director_dep.dependency_path = story_director_.get_path()


# All animaitons played on a visual must operate on the visual_holder.
func play_animation(animation, animation_action = null):
	if curr_animation_action != null:
		story_director_dep.dependency.remove_step_action(curr_animation_action)
	curr_animation_action = animation_action
	story_director_dep.dependency.add_step_action(curr_animation_action)
	
	animation_player.add_animation("CurrentAnimation", animation)
	animation_player.play("CurrentAnimation")


func skip_current_animation():
	# 2nd argument makes the AnimationPlayer update itself after seeking 
	animation_player.seek(animation_player.current_animation_length, true)
	# "AnimationPlayer.animation_finished" signal is not called if we 
	# skip to the end, therefore we must manually call the listener method.
	_on_animation_finished("CurrentAnimation", true)


func _on_animation_finished(animation_name, skipped):
	if animation_name == "CurrentAnimation":
		animation_player.remove_animation("CurrentAnimation")
	
	# Move the visual to the visual_holder's position to
	# reset the visual_holder's position to (0, 0) which allows 
	# a future animation to play starting from (0, 0).
	visual.global_position = visual_holder.global_position
	visual_holder.position = Vector2.ZERO
	
	if not skipped and curr_animation_action != null:
		story_director_dep.dependency.remove_step_action(curr_animation_action)
		curr_animation_action = null
	
	emit_signal("animation_finished", animation_name, skipped)

extends Node


signal animation_finished(animation_name, skipped)

export var visual_path: NodePath
export var visual_holder_path: NodePath
export var story_director_dep_path: NodePath

var curr_visual_animation
var curr_animation_action

onready var visual = get_node(visual_path)

# This holder is moved during animations and then the entire Visual
# is then repositioned to this holder's position after the animation ends.
# This allows animations to permenantly affect the position of the Visual
# and allow future animations to also modify the position of the Visual
# since the visual_holder will always be at origin (0,0) before
# each animation is played.
onready var visual_holder = get_node(visual_holder_path)
onready var story_director_dep = get_node(story_director_dep_path)


func init(story_director_):
	story_director_dep = get_node(story_director_dep_path)
	story_director_dep.dependency_path = story_director_.get_path()


func play_animation(visual_animation, animation_action = null):
	if curr_animation_action != null:
		story_director_dep.dependency.remove_step_action(curr_animation_action)
	curr_animation_action = animation_action
	story_director_dep.dependency.add_step_action(curr_animation_action)
	
	if curr_visual_animation != null:
		curr_visual_animation.queue_free()
		curr_visual_animation = null
	curr_visual_animation = visual_animation
	curr_visual_animation.connect("animation_finished", self, "_on_animation_finished")
	
	add_child(curr_visual_animation)
	curr_visual_animation.animate(visual_holder)


func _on_animation_finished(skipped):
	if not skipped and curr_animation_action != null:
		story_director_dep.dependency.remove_step_action(curr_animation_action)
	curr_animation_action = null
	
	# Move the visual to the visual_holder's position to
	# reset the visual_holder's position to (0, 0) which allows 
	# a future animation to play starting from (0, 0).
	visual.global_position = visual_holder.global_position
	visual_holder.position = Vector2.ZERO
	
	curr_visual_animation.queue_free()
	curr_visual_animation = null

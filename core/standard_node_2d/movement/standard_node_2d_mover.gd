extends Node
# Controls the movement of a StandardNode2D.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StandardNode2DMover"]

# ----- Typeable ----- #


const MovementAction = preload("res://addons/FracturalVNE/core/standard_node_2d/movement/move_action.gd")

export var standard_node_2d_path: NodePath

var target_position
var target_scale
var target_rotation
var starting_position: Vector2
var starting_scale: Vector2
var starting_rotation: float
var travel_curve: Curve
var duration: float
var story_director
var curr_move_action

var _curr_time: float

onready var standard_node_2d = get_node(standard_node_2d_path)


func _ready() -> void:
	set_process(false)


func init(story_director_):
	story_director = story_director_


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_destructor()


func _destructor():
	if curr_move_action != null and story_director != null:
		story_director.remove_step_action(curr_move_action)


func _process(delta) -> void:
	if _curr_time < duration:
		_curr_time += delta
		var progress = _curr_time / duration
		if target_position != null:
			standard_node_2d.standard_position = starting_position.linear_interpolate(target_position, travel_curve.interpolate(progress))
		if target_rotation != null:
			standard_node_2d.standard_rotation = lerp(starting_rotation, target_rotation, travel_curve.interpolate(progress))
		if target_scale != null:
			standard_node_2d.standard_scale = starting_position.linear_interpolate(target_scale, travel_curve.interpolate(progress))
	else:
		_on_move_finished(false)


func move(target_position_, target_scale_, target_rotation_, travel_curve_: Curve = null, duration_: float = 0):
	if curr_move_action != null:
		story_director.remove_step_action(curr_move_action)
		curr_move_action = null
	if travel_curve_ != null:
		# We have a transition so we have to add a move_action
		# step action. Any action that does not take time should not
		# add a step action to the story_director.
		curr_move_action = MovementAction.new(self)
		story_director.add_step_action(curr_move_action)
	
	set_process(true)
	target_position = target_position_
	target_scale = target_scale_
	target_rotation = target_rotation_
	
	duration = duration_
	travel_curve = travel_curve_

	starting_position = standard_node_2d.standard_position
	starting_scale = standard_node_2d.standard_scale
	starting_rotation = standard_node_2d.standard_rotation
	
	_curr_time = 0
	
	if travel_curve_ == null or duration_ == 0:
		# We do not have a transition or have a duration of 0, therefore we move immediately
		_on_move_finished(false)
		


func _on_move_finished(skipped):
	if target_position != null:
		standard_node_2d.standard_position = target_position
	if target_scale != null:
		standard_node_2d.standard_scale = target_scale
	if target_rotation != null:
		standard_node_2d.standard_rotation = target_rotation
	
	if not skipped and curr_move_action != null:
		story_director.remove_step_action(curr_move_action)
	curr_move_action = null
	
	set_process(false)

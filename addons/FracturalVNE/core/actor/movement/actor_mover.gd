extends Node
# Controls the movement of an Actor
# TODO: Implement rotation and scaling


export var actor_path: NodePath

var target_position: Vector2
var starting_position: Vector2
var travel_curve: Curve
var duration: float
var story_director

var _curr_move_action
var _curr_time: float

onready var actor = get_node(actor_path)


func _ready():
	set_process(false)


func init(story_director_):
	story_director = story_director_


func _process(delta):
	if _curr_time < duration:
		_curr_time += delta
		actor.position = starting_position.linear_interpolate(target_position, travel_curve.interpolate(_curr_time / duration))
	else:
		_on_move_finished(false)
		set_process(false)


func move(target_position_: Vector2, travel_curve_: Curve = null, duration_: float = 0, move_action = null):
	if _curr_move_action != null:
		story_director.remove_step_action(_curr_move_action)
	_curr_move_action = move_action
	story_director.add_step_action(_curr_move_action)
	
	set_process(true)
	target_position = target_position_
	duration = duration_
	travel_curve = travel_curve_
	starting_position = actor.position
	
	_curr_time = 0
	
	if travel_curve_ == null or duration_ == 0:
		# We do not have a transition or have a duration of 0, therefore we move immediately
		_on_move_finished(false)
		


func _on_move_finished(skipped):
	actor.position = target_position
	
	if not skipped and _curr_move_action != null:
		story_director.remove_step_action(_curr_move_action)
	_curr_move_action = null
	
	set_process(false)

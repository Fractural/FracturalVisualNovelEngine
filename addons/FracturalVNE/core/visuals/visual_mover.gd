extends Node
# Controls the movement of a Visual


export var visual_path: NodePath
export var story_director_dep_path: NodePath

var target_position: Vector2
var starting_position: Vector2
var travel_curve: Curve
var duration: float

var _curr_move_action
var _curr_time: float

onready var visual = get_node(visual_path)
onready var story_director_dep = get_node(story_director_dep_path)


func init(story_director):
	story_director_dep = get_node(story_director_dep_path)
	story_director_dep.dependency_path = story_director.get_path()


func _process(delta):
	if _curr_time < duration:
		_curr_time += delta
		visual.position = starting_position.linear_interpolate(target_position, travel_curve.interpolate(_curr_time / duration))
	else:
		_on_move_finished(false)
		set_process(false)


func move(target_position_: Vector2, travel_curve_: Curve = null, duration_: float = 0, move_action = null):
	if _curr_move_action != null:
		story_director_dep.dependency.remove_step_action(_curr_move_action)
	_curr_move_action = move_action
	story_director_dep.dependency.add_step_action(_curr_move_action)
	
	set_process(true)
	target_position = target_position_
	duration = duration_
	travel_curve = travel_curve_
	starting_position = visual.position
	
	_curr_time = 0
	
	if travel_curve_ == null or duration_ == 0:
		# We do not have a transition or have a duration of 0, therefore we move immediately
		_on_move_finished(false)
		


func _on_move_finished(skipped):
	visual.position = target_position
	
	if not skipped:
		story_director_dep.dependency.remove_step_action(_curr_move_action)
	_curr_move_action = null
	
	set_process(false)

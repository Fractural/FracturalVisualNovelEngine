extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/stepped_node/stepped_node.gd"
# TODO: Finish the rest the show statement.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("pause")
	return arr

# ----- Typeable ----- #


const PauseAction = preload("pause_action.gd")

var duration

var _curr_pause_timer
var _curr_pause_action
var _finished


func _init(position_ = null, duration_ = null).(position_):
	duration = duration_


func execute():
	_finished = false
	
	var duration_result = duration.evaluate()
	
	if not is_success(duration_result) or not (duration_result is float or duration_result is int):
		throw_error(stack_error(duration_result, "Expected a valid number for the duration."))
		return
	
	_curr_pause_action = PauseAction.new(self, true)
	get_runtime_block().get_service("StoryDirector").add_step_action(_curr_pause_action)
	get_runtime_block().get_service("StoryDirector").start_step(self)
	
	# Might be inefficient if there is a lot of pause statements that last a short time (leading to the creation
	# and destruciton of a lot of timers)
	_curr_pause_timer = get_runtime_block().get_service("TimerRegistry").create_timer(duration_result)
	
	yield(_curr_pause_timer, "timeout")
	
	_on_pause_finished(false)


func is_auto_step():
	# Pause statements will automatically step, meaning you can save a save state on
	# them but they will immediately play when you load a save state on them. 
	return true


func _on_pause_finished(skipped):
	if not _finished:
		_finished = true
		
		get_runtime_block().get_service("TimerRegistry").remove_timer(_curr_pause_timer)
		
		get_runtime_block().get_service("StoryDirector").step()
		# Remove pause_action last to prevent no actions being present (Since no actions
		# after removal is used by the auto atepper to check if the current step has finished.)
		# Not sure if this has any side effects.
		if not skipped:
			get_runtime_block().get_service("StoryDirector").remove_step_action(_curr_pause_action)
		emit_signal("executed")
		

func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "PAUSE %ss" % duration 
	return string


func propagate_call(method, arguments = [], parent_first = false):
	if parent_first:
		.propagate_call(method, arguments, parent_first)
	
	duration.propagate_call(method, arguments, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)


# ----- Serialization ----- #

func serialize():
	var serialized_object = .serialize()
	serialized_object["duration"] = duration.serialize()
	
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.duration = SerializationUtils.deserialize(serialized_object["duration"])
	
	return instance

# ----- Serialization ----- #

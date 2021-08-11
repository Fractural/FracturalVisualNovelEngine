extends Node
# Test double for StoryDirector.


# ----- StoryService Info ----- #

signal	_called__get_service_name()
var		_return__get_service_name
func get_service_name():
	emit_signal("_called__get_service_name")
	return _return__get_service_name


signal	_called__configure_service(program_node)
var		_return__configure_service
func configure_service(program_node):
	emit_signal("_called__configure_service", program_node)
	return _return__configure_service

# --- StoryService Info End --- #


signal	_called___ready()
var		_return___ready
func _ready():
	emit_signal("_called___ready")
	return _return___ready


signal	_called__start_step(ast_node)
var		_return__start_step
func start_step(ast_node):
	emit_signal("_called__start_step", ast_node)
	return _return__start_step


signal	_called__set_auto_step_duration(new_value)
var		_return__set_auto_step_duration
func set_auto_step_duration(new_value):
	emit_signal("_called__set_auto_step_duration", new_value)
	return _return__set_auto_step_duration


signal	_called__set_step_state(new_value)
var		_return__set_step_state
func set_step_state(new_value):
	emit_signal("_called__set_step_state", new_value)
	return _return__set_step_state


signal	_called__try_step()
var		_return__try_step
func try_step():
	emit_signal("_called__try_step")
	return _return__try_step


signal	_called__step()
var		_return__step
func step():
	emit_signal("_called__step")
	return _return__step


signal	_called__skip(override_auto_step)
var		_return__skip
func skip(override_auto_step: bool = false):
	emit_signal("_called__skip", override_auto_step)
	return _return__skip


func release_queued_overridden_steps():
	# number_of_steps is a temp variable that allows us to set queued_overridden_steps
	# to 0 while still being able to iterate through the number of queued_overridden_steps.
	# queued_overridden_steps must be 0 to prevent a recursive call from happening
	# which is caused by step() calling release_queued_overridden_steps() when
	# queued_overridden_steps > 0.
	var number_of_steps = queued_overridden_steps
	queued_overridden_steps = 0
	for i in number_of_steps:
		step()


func add_step_action(step_action):
	curr_active_step_actions.append(step_action)


func remove_step_action(step_action):
	curr_active_step_actions.erase(step_action)
	
	# If we have two consecutive show statements in the start of a
	# story, right after the second statement removes the step action
	# of the first statement, the total step action will be zero for a moment.
	#
	# The start of the program is the only case like this that I can 
	# think of, so I'm adding a check to prevent that.
	#
	# Not sure if this is the best way to go about it. (Maybe if more edge
	# cases like this are found I can then make a better solution). 
	if (not FracVNE.Utils.is_type(curr_stepped_node, "ProgramNode")
		and curr_active_step_actions.size() == 0):
		if curr_stepped_node.is_auto_step():
			step()
		else:
			# Completed autostepped steps are not considered
			# a normal completed step.
			_normal_step_completed()


func call_label(label_name: String, arguments = []):
	if label_dict.has(label_name):
		label_dict[label_name].execute(arguments)
	else:
		return FracVNE.StoryScript.Error.new("Cannot call \"%s\" label since the label could not be found." % [label_name])


func jump_to_label(label_name: String):
	if label_dict.has(label_name):
		label_dict[label_name].execute()
	else:
		return FracVNE.StoryScript.Error.new("Cannot jump to \"%s\" label since the label could not be found." % [label_name])


func add_label(label_node):
	if not label_dict.has(label_node.name):
		label_dict[label_node.name] = label_node
	else:
		return FracVNE.StoryScript.Error.new("Cannot add \"%s\" label since label named \"%s\" already exists." % [label_node.name, label_node.name])


func _normal_step_completed():
	if step_state == StepState.AUTO_STEP:
		_auto_step_timer.start()

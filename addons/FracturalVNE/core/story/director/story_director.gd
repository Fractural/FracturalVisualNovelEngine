extends Node
# Controls the flow of a story by moving the story a step at a time.
# Each step pauses the game until the user clicks the screen to progress.
# This is useful for letting users play through the game and read
# the text at their own pace.


# ----- StoryService Info ----- #

const FuncDef = FracVNE.StoryScript.FuncDef
const Param = FracVNE.StoryScript.Param

var function_definitions = [
	FuncDef.new("step"),
	FuncDef.new("start_step", [
		Param.new("ast_node"),
	]),
	FuncDef.new("call_label", [
		Param.new("label_name"),
		Param.new("arguments"),
	]),
	FuncDef.new("jump_to_label", [
		Param.new("label_name"),
	]),
	FuncDef.new("add_label", [
		Param.new("label_node"),
	]),
]


func get_service_name():
	return "StoryDirector"


func configure_service(program_node):
	# Reset the story director when a new story tree is loaded
	label_dict = {}
	curr_active_step_actions = []

# --- StoryService Info End --- #


enum StepState {
	MANUAL,
	AUTO_STEP,
	SKIPPING,
}

signal stepped()

# Wait duration after a step is completed
export var auto_step_duration: float = 0.5 setget set_auto_step_duration

# Wait duration between steps and skips
export var skip_speed: float = 0.05

var label_dict: Dictionary
var curr_stepped_node
var step_state: int = StepState.MANUAL setget set_step_state
var curr_active_step_actions: Array
var _auto_step_timer: Timer
var _skip_timer: Timer

# If true this will only allow skipping the current active
# actions while preventing stepping to the next node -- even if
# the current node is an autostep node.
#
# For each step attempted while paused, the queue_steps increases by 1.
# This feature has so far bene used by the SaveStateManager to enable
# saving on pause statements.
var override_step: bool = false
# Number of steps ran while override_step is true.
var queued_overridden_steps: int

# curr_node_executed prevents repeated stepping if the program terminates on an executable node that
# is not steppable. (This means the current step node never reaches another step node to replace
# it as curr_stepped_node).
var curr_node_executed: bool = false


func _ready() -> void:
	_auto_step_timer = Timer.new()
	add_child(_auto_step_timer)
	_auto_step_timer.connect("timeout", self, "try_step")
	_auto_step_timer.wait_time = auto_step_duration
	_auto_step_timer.one_shot = true
	
	# Skipping seems to just be the fastest version of auto stepping according to renpy.
	# TODO DISCUSS: Maybe try to skip each frame?
	
	# TODO DISCUSS: Refactor out skipping to a custom timer inside process()
	#				I'm pretty sure a regular timer node cannot fire multiple times 
	#				in one frame, therefore when the timer overshoots, some time is lost.
	_skip_timer = Timer.new()
	add_child(_skip_timer)
	_skip_timer.connect("timeout", self, "try_step")
	_skip_timer.wait_time = skip_speed


func start_step(ast_node):
	curr_stepped_node = ast_node
	curr_node_executed = false


func set_auto_step_duration(new_value):
	auto_step_duration = new_value
	
	if _auto_step_timer != null:
		_auto_step_timer.wait_time = new_value


func set_step_state(new_value):
	step_state = new_value
	
	if curr_stepped_node == null:
		return
	
	match step_state:
		StepState.AUTO_STEP:
			if curr_active_step_actions.size() == 0:
				try_step()
		StepState.SKIPPING:
			try_step()
			_skip_timer.start()
	
	if step_state != StepState.SKIPPING:
		_skip_timer.stop() 


# Attempts to skip if there are actions currently playing
# and steps if no actions are playing
func try_step():
	if curr_active_step_actions.size() > 0:
		skip()
	else:
		step()


func step():
	# If we are saving and we are skipping, we do not want to step, 
	# even if the statement normally automatically steps (Like with
	# pause statements, which automatically step after they are finished).
	# Therefore in those cases we would enabled override_step to allow skipping
	# but not stepping. 
	# This allows us to use pause statements as save points since they will
	# be assigned to curr_stepped_node whenever they are running.
	if override_step:
		queued_overridden_steps += 1
		return
	
	if queued_overridden_steps > 0:
		release_queued_overridden_steps()
	
	# TODO DISCUSS: Consider decoupling story director from nodes to follow single responsibility principle.
	#		That is, a story director should not know about the existance of a node and instead
	#		would operate using events and callbacks to step.
	#		Though tbh this is not much of a priority right now since even renpy
	#		expected you to use it's own programming language.
	if not curr_node_executed:
		curr_node_executed = true
		# This SteppedNode type check is to
		# prevent crashes when there are no stepped nodes,
		# which places the program node as a stepped node.
		#
		# TODO DISCUSS: Maybe just make the program node a stepped node
		#				insttead of doing this check?
		if FracVNE.Utils.is_type(curr_stepped_node, "SteppedNode"): 
			curr_stepped_node.step()
			emit_signal("stepped")
	else:
		# TODO: Exit the story when the last node is reached
		return


# Skips all current active step actions. If override_auto_step
# is true, this also prevents auto stepped nodes from automatically
# calling the next step, and will queue their steps instead to be
# released manually by release_queued_overridden_steps.
func skip(override_auto_step: bool = false):
	if override_auto_step:
		override_step = true
	
	var active = curr_active_step_actions;
	
	var i = 0
	var curr_active_step_actions_size = curr_active_step_actions.size()
	while i < curr_active_step_actions.size() and curr_active_step_actions_size > 0:
		while curr_active_step_actions[i].skippable: 
			curr_active_step_actions[i].skip()
			curr_active_step_actions.remove(i)
			curr_active_step_actions_size -= 1
			if i >= curr_active_step_actions.size() or curr_active_step_actions_size <= 0:
				break
		i += 1
		curr_active_step_actions_size -= 1
	
	# When pause is removed it causes 0 statements to be left, which
	# makes auto step activate. How can we get around this?
	
	if override_auto_step:
		override_step = false


# Executes step() for the number times step was queued while override_step
# was true.
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

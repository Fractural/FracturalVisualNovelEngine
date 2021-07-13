extends Node
# Controls the flow of a story by moving the story a step at a time.
# Each step pauses the game until the user clicks the screen to progress.
# This is useful for letting users play through the game and read
# the text at their own pace.


# ----- StoryService Info ----- #

var function_definitions = [
	StoryScriptFuncDef.new("step"),
	StoryScriptFuncDef.new("start_step", [
		"ast_node"
	]),
	StoryScriptFuncDef.new("call_label", [
		"label_name",
		"arguments",
	]),
	StoryScriptFuncDef.new("jump_to_label", [
		"label_name"
	]),
	StoryScriptFuncDef.new("add_label", [
		"label_node"
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
var _auto_step_timer: Timer
var _skip_timer: Timer
var curr_active_step_actions: Array

# curr_node_executed prevents repeated stepping if the program terminates on an executable node that
# is not steppable. (This means the current step node never reaches another step node to replace
# it as curr_stepped_node).
var curr_node_executed: bool = false


func _ready():
	_auto_step_timer = Timer.new()
	add_child(_auto_step_timer)
	_auto_step_timer.connect("timeout", self, "try_step")
	_auto_step_timer.wait_time = auto_step_duration
	_auto_step_timer.one_shot = true
	
	# Skipping seems to just be the fastest version of auto stepping according to renpy.
	# TODO: Maybe try to skip each frame?
	
	# TODO: Refactor out skipping to a custom timer inside process()
	#		I'm pretty sure a regular timer node cannot fire multiple times 
	#		in one frame, therefore when the timer overshoots, some time is lost.
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
	# TODO: Consider decoupling story director from nodes to follow single responsibility principle.
	#		That is, a story director should not know about the existance of a node and instead
	#		would operate using events and callbacks to step.
	#		Though tbh this is not much of a priority right now since even renpy
	#		expected you to use it's own programming language.
	if curr_stepped_node.runtime_next_node != null and not curr_node_executed:
		emit_signal("stepped")
		
		curr_node_executed = true
		
		curr_stepped_node.runtime_next_node.execute()
	else:
		# TODO: Exit the story when the last node is reached
		return


func skip():
	for i in range(curr_active_step_actions.size() - 1, -1, -1):
		if curr_active_step_actions[i].skippable:
			curr_active_step_actions[i].skip()
			curr_active_step_actions.remove(i)
	
	if step_state == StepState.AUTO_STEP:
		_auto_step_timer.start()


func add_step_action(step_action):
	curr_active_step_actions.append(step_action)


func remove_step_action(step_action):
	curr_active_step_actions.erase(step_action)
	if curr_active_step_actions.size() == 0:
		_step_completed()


func call_label(label_name: String, arguments = []):
	if label_dict.has(label_name):
		label_dict[label_name].execute(arguments)
	else:
		return StoryScriptError.new("Cannot call \"%s\" label since the label could not be found." % [label_name])


func jump_to_label(label_name: String):
	if label_dict.has(label_name):
		label_dict[label_name].execute()
	else:
		return StoryScriptError.new("Cannot jump to \"%s\" label since the label could not be found." % [label_name])


func add_label(label_node):
	if not label_dict.has(label_node.name):
		label_dict[label_node.name] = label_node
	else:
		return StoryScriptError.new("Cannot add \"%s\" label since label named \"%s\" already exists." % [label_node.name, label_node.name])


func _step_completed():
	if step_state == StepState.AUTO_STEP:
		_auto_step_timer.start()

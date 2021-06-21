extends Node

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
	label_dict = {}

# --- StoryService Info End --- #

signal stepped()

export var auto_step_duration: float = 0.5 setget set_auto_step_duration
export var skip_speed: float = 0.05

var label_dict: Dictionary
var curr_stepped_node
var auto_step: bool = false
var skipping: bool = false
var _auto_step_timer: Timer
var _skip_timer: Timer

func _ready():
	_auto_step_timer = Timer.new()
	add_child(_auto_step_timer)
	_auto_step_timer.connect("timeout", self, "step")
	_auto_step_timer.wait_time = auto_step_duration
	
	_skip_timer = Timer.new()
	add_child(_skip_timer)
	_skip_timer.connect("timeout", self, "step")
	_skip_timer.wait_time = skip_speed

func execute(ast_node):
	ast_node.execute()

func start_step(ast_node):
	curr_stepped_node = ast_node
	if skipping:
		_skip_timer.start()
	elif auto_step:
		_auto_step_timer.start()

func set_auto_step_duration(new_value):
	auto_step_duration = new_value
	_auto_step_timer.wait_time = new_value

func step():
	# TODO: Add support for skipping the execution of a current node.
	#		
	#		This is useful for play animation nodes, since the animated object must
	#		snap to it's final position if the animation is skipped.
	#
	# 		Maybe create a function that can be called on each node
	#		that terminates whatever action they are currently doing.
	#		Something like "terminate_execute" ?
	if curr_stepped_node.runtime_next_node != null:
		emit_signal("stepped")
		curr_stepped_node.runtime_next_node.execute()
	else:
		return

func call_label(label_name: String, arguments = []):
	if label_dict.has(label_name):
		label_dict[label_name].execute(arguments)
	else:
		return StoryScriptError.new("Cannot call %s label since the label could not be found." % [label_name])

func jump_to_label(label_name: String):
	if label_dict.has(label_name):
		label_dict[label_name].execute()
	else:
		return StoryScriptError.new("Cannot jump to %s label since the label could not be found." % [label_name])

func add_label(label_node):
	if not label_dict.has(label_node.name):
		label_dict[label_node.name] = label_node
	else:
		return StoryScriptError.new("Cannot add %s label since label named %s already exists." % [label_node.name, label_node.name])

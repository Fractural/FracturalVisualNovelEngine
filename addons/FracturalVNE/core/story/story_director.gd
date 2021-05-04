extends Node
class_name StoryDirector

signal stepped()

var label_dict: Dictionary
var _curr_step_callback: FuncRef

var function_definitions = [
	# DEMO
	StoryScriptFuncDef.new("step"),
	StoryScriptFuncDef.new("start_step", [
		"step_callback"
	]),
]

func configure_service(program_node):
	label_dict = {}

func start_step(step_callback):
	_curr_step_callback = step_callback

func step():
	emit_signal("stepped")
	_curr_step_callback.call_func()

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

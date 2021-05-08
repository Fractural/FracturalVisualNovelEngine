extends Node

# ----- StoryService Info ----- #

var function_definitions = [
	# DEMO
	StoryScriptFuncDef.new("step"),
	StoryScriptFuncDef.new("start_step", [
		"step_callback"
	]),
]

func get_service_name():
	return "StoryDirector"

func configure_service(program_node):
	label_dict = {}

# --- StoryService Info End --- #





signal stepped()

var label_dict: Dictionary
var curr_stepped_node

func execute(ast_node):
	ast_node.execute()

func start_step(ast_node):
	curr_stepped_node = ast_node

func step():
	emit_signal("stepped")
	if curr_stepped_node.runtime_next_node != null:
		curr_stepped_node.runtime_next_node.execute()
	curr_stepped_node = null

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

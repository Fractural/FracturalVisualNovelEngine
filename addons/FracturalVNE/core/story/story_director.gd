extends Node
class_name StoryDirector

signal stepped()

var _curr_step_callback: FuncRef

func configure_service(program_node):
	pass

func start_step(step_callback):
	_curr_step_callback = step_callback

func step():
	emit_signal("stepped")
	_curr_step_callback.call_func()

func add_label(label_node):
	pass

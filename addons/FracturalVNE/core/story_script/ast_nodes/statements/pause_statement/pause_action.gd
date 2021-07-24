extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# Action for animating a Visualr


var pause_statement


func _init(pause_statement_, skippable_ = true).(skippable_):
	# To avoid memory leaks, we must obtain only weak references of
	# nodes from the AST. Otherwise we would create a cylical dependency. 
	pause_statement = weakref(pause_statement_)


func skip():
	pause_statement.get_ref()._on_pause_finished(true)

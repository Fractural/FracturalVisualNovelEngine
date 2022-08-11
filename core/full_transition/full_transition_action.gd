extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# Step action for full transitions.


var full_transition_statement


func _init(full_transition_statement_, skippable_ = false).(skippable_):
	full_transition_statement = full_transition_statement_


func skip():
	full_transition_statement.skip_transition()

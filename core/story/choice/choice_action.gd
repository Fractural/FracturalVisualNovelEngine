extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# Step action for choices. 


var choice_statement


# Choices by default should never be skippable
func _init(choice_statement_, skippable = false).(skippable):
	choice_statement = weakref(choice_statement_)


func skip():
	choice_statement.get_ref()._finished_choice(true)

extends Node
# Builds a ChoiceManager for testing.


const ChoiceManager = preload("res://addons/FracturalVNE/core/story/choice/choice_manager.gd")

var choice_manager


func build():
	choice_manager = ChoiceManager.new()
	return choice_manager


func default(direct):
	return self

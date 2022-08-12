extends Reference
# Holds the different fake classes for StoryDirector.


const StoryDirector = preload("res://addons/FracturalVNE/core/story/director/story_director.gd")


class TestSkip:
	var step_actions: Array = []
	
	
	func _init():
		pass
	
	
	func skip_all_step_actions():
		for step_action in step_actions:
			step_action.skip()
		step_actions.clear()
	
	
	func add_step_action(_object, args: Array):
		step_actions.append(args[0])
	
	
	func remove_step_action(_object, args: Array):
		step_actions.erase(args[0])

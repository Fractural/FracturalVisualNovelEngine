extends Reference
# Holds the different fake classes for StoryDirector.


const StoryDirector = preload("res://addons/FracturalVNE/core/story/director/story_director.gd")


class TestSkip extends WAT.FakeMock:
	var step_actions: Array = []
	
	
	func _init(direct).(direct, StoryDirector):
		_bind_mock_function("add_step_action")
		_bind_mock_function("remove_step_action")
	
	
	func skip_all_step_actions():
		for step_action in step_actions:
			step_action.skip()
		step_actions.clear()
	
	
	func add_step_action(_object, args: Array):
		step_actions.append(args[0])
	
	
	func remove_step_action(_object, args: Array):
		step_actions.erase(args[0])

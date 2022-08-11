extends Reference
# A marker that represents a running actions. Only actions that take
# a certain duration should add themselves to StoryDirector. Immediate
# actions should not register anything.


var skippable: bool


func _init(skippable_ = true):
	skippable = skippable_


func skip():
	pass

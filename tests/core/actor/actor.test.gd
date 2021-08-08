extends WAT.Test
# Unit tests for the Actor class.


const Actor = preload("res://addons/FracturalVNE/core/actor/actor.gd")
var FakeActor = preload("res://tests/core/actor/fake_actor/fake_actor.gd")


func title():
	return "Given a FakeActor to test Actor"


# Feature: Serialization
#	Given an Actor
#	When Actor.serialize() is called
#	Then Actor.serialize() returns the persistent data about the Actor
#		 serialized into a dicitonary. 
func test_serialization() -> void:
	describe("When calling serialize() and deserialize()")
	var actor = Actor.new(true)
	var serialized_actor = actor.serialize()
	
	asserts.is_true(FracVNE.Utils.is_type(serialized_actor, "Dictionary"), "Then the serialized actor is a Dictionary.")
	asserts.is_true(serialized_actor.get("cached") == true, "Then the serialized actor stores the \"cached\" property correctly.")
	
	var deserialized_actor = SerializationUtils.deserialize(serialized_actor)
	
	asserts.is_true(FracVNE.Utils.is_type(deserialized_actor, "Actor"), "Then the deserialized actor is an Actor.")
	asserts.is_true(FracVNE.Utils.is_type(deserialized_actor, "Actor"), "Then the deserialized actor is an Actor.")
	asserts.is_true(deserialized_actor.cached == true, "Then the deserialized actor's has the correct \"cached\" property.")


func test_instantiation() -> void:
	describe("When calling instantiate_controller()")
	var actor = FakeActor.new(true)
	var controller = actor.instantiate_controller(MockStoryDirector.new())
	print("Types: " + str(controller.get_types()))
	asserts.is_true(FracVNE.Utils.is_type(controller, "ActorController"), "The instantiated controller is an ActorController")


class MockStoryDirector extends Reference:
	func _init():
		pass
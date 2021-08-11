extends WAT.Test
# Unit tests for the Actor class.


const Actor = preload("res://addons/FracturalVNE/core/actor/actor.gd")
const StoryDirector = preload("res://addons/FracturalVNE/core/story/director/story_director.gd")
const FakeActor = preload("res://tests/core/actor/fake_actor/fake_actor.gd")

var actor


func title():
	return "Actor via FakeActor"


func start():
	actor = FakeActor.new(true)


func test_serialization() -> void:
	describe("When calling serialize() and deserialize()")
	var serialized_actor = actor.serialize()
	
	asserts.is_true(FracVNE.Utils.is_type(serialized_actor, "Dictionary"), "Then the serialized actor is a Dictionary.")
	asserts.is_true(serialized_actor.get("cached") == true, "Then the serialized actor stores the \"cached\" property correctly.")
	
	var deserialized_actor = SerializationUtils.deserialize(serialized_actor)
	
	asserts.is_true(FracVNE.Utils.is_type(deserialized_actor, "Actor"), "Then the deserialized actor is an Actor.")
	asserts.is_true(FracVNE.Utils.is_type(deserialized_actor, "Actor"), "Then the deserialized actor is an Actor.")
	asserts.is_true(deserialized_actor.cached == true, "Then the deserialized actor's has the correct \"cached\" property.")


func test_instantiation() -> void:
	describe("When calling instantiate_controller()")
	
	var mock_story_director = direct.script(StoryDirector)
	var controller = actor.instantiate_controller(mock_story_director.double())
	
	asserts.is_true(FracVNE.Utils.is_type(controller, "ActorController"), "The instantiated controller is an ActorController")

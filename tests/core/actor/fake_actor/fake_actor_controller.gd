extends "res://addons/FracturalVNE/core/actor/actor_controller.gd"
# Fakes an ActorController


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("FakeActorController")
	return arr

# ----- Typeable ----- #


func init(text_printer_ = null, story_director_ = null):
	.init(text_printer_, story_director_)

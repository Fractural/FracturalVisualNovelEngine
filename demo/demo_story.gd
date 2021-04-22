extends Story
class_name DemoStory

func start():
	auto_step(ON)

	define_character("Bob", Color.blue)
	define_character("Me", Color.red)

	say("Bob", "Hey there!")

	narrate("Bob had just arrived")

	say("Me", "Hi Bob!")
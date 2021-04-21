extends Reference
class_name StoryActions

class WaitForStep:
	const NAME = "Step"

	func perform(story_manager):
		pass

# CharacterManager Actions
class LoadCharacterAssets:        
	var directory_path: String

	func _init(directory_path_: String):
		directory_path = directory_path_

	func perform(story_manager):
		story_manager.character_manager.load_character_assets(directory_path)

class DefineCharacter:
	var character_name: String
	var text_color: Color

	func _init(character_name_: String, text_color_: Color):
		character_name = character_name_
		text_color = text_color_

	func perform(story_manager):
		story_manager.character_manager.define_character(character_name, text_color)

# SpriteManager Actions
class DefineSprite:
	var sprite_name: String

	func _init(sprite_name_: String):
		sprite_name = sprite_name_

	func perform(story_manager):
		story_manager.sprite_manager.define_sprite(sprite_name)

# TextPrinter Actions
class Say:
	var character_name: String
	var text: String

	func _init(character_name_: String, text_: String):
		character_name = character_name_
		text = text_

	func perform(story_manager): 
		story_manager.text_printer.say(character_name, text)

class Narrate:
	var text: String

	func _init(text_: String):
		text = text_

	func perform(story_manager):
		story_manager.text_printer.narrate(text)

# AnimationManager Actions
class ToggleVisibility:
	var sprite_name: String
	var show: bool

	func _init(sprite_name_: String, show_: bool):
		sprite_name = sprite_name_
		show = show_
	
	func perform(story_manager):
		story_manager.sprite_manager.toggle_visibility(sprite_name, show)

class AnimateVisibility:
	var sprite_name: String
	var animation_name: String
	var show: bool

	func _init(sprite_name_: String, animation_name_: String, show_: bool):
		sprite_name = sprite_name_
		animation_name = animation_name_
		show = show_

	func perform(story_manager):
		story_manager.animation_manager.animate(sprite_name, ("show_" if show else "hide_") + animation_name)

class Animate:
	var sprite_name: String
	var animation_name: String

	func _init(sprite_name_: String, animation_name_: String):
		sprite_name = sprite_name_
		animation_name = animation_name_

	func perform(story_manager):
		story_manager.animation_manager.animate(sprite_name, animation_name)

class Move:
	var sprite_name: String
	var position: Vector2

	func _init(sprite_name_: String, position_: Vector2):
		sprite_name = sprite_name_
		position = position_
	
	func perform(story_manager):
		story_manager.animation_manager.move(sprite_name, position);

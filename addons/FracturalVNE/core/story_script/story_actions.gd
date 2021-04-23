extends Reference
class_name StoryActions

class Action:
	var previous_action: Action = null
	var next_action: Action = null

class Start extends Action:
	const TYPE = "Start"

class End extends Action:
	const TYPE = "End"
	

# CharacterManager Actions
class LoadCharacterAssets extends Action:      
	const TYPE = "LoadCharacterAssets"  
	
	var directory_path: String

	func _init(directory_path_: String):
		directory_path = directory_path_

	func perform(story_manager):
		story_manager.character_manager.load_character_assets(directory_path)

class DefineCharacter extends Action:
	const TYPE = "DefineCharacter"

	var character_name: String
	var name_color: Color
	var dialogue_color: Color

	func _init(character_name_: String, name_color_: Color, dialogue_color_: Color):
		character_name = character_name_
		name_color = name_color_
		dialogue_color = dialogue_color_

	func perform(story_manager):
		story_manager.character_manager.define_character(character_name, name_color, dialogue_color)

# SpriteManager Actions
class DefineSprite extends Action:
	const TYPE = "DefineSprite"

	var sprite_name: String

	func _init(sprite_name_: String):
		sprite_name = sprite_name_

	func perform(story_manager):
		story_manager.sprite_manager.define_sprite(sprite_name)

# TextPrinter Actions
class Say extends Action:
	const TYPE = "Say"

	var character_name: String
	var text: String

	func _init(character_name_: String, text_: String):
		character_name = character_name_
		text = text_

	func perform(story_manager): 
		story_manager.text_printer.say(character_name, text)

class Narrate extends Action:
	const TYPE = "Narrate"

	var text: String

	func _init(text_: String):
		text = text_

	func perform(story_manager):
		story_manager.text_printer.narrate(text)

# AnimationManager Actions
class ToggleVisibility extends Action:
	const TYPE = "ToggleVisibility"

	var sprite_name: String
	var show: bool

	func _init(sprite_name_: String, show_: bool):
		sprite_name = sprite_name_
		show = show_
	
	func perform(story_manager):
		story_manager.sprite_manager.toggle_visibility(sprite_name, show)

class AnimateVisibility extends Action:
	const TYPE = "AnimateVisibility"

	var sprite_name: String
	var animation_name: String
	var show: bool

	func _init(sprite_name_: String, animation_name_: String, show_: bool):
		sprite_name = sprite_name_
		animation_name = animation_name_
		show = show_

	func perform(story_manager):
		story_manager.animation_manager.animate(sprite_name, ("show_" if show else "hide_") + animation_name)

class Animate extends Action:
	const TYPE = "Animate"

	var sprite_name: String
	var animation_name: String

	func _init(sprite_name_: String, animation_name_: String):
		sprite_name = sprite_name_
		animation_name = animation_name_

	func perform(story_manager):
		story_manager.animation_manager.animate(sprite_name, animation_name)

class Move extends Action:
	const TYPE = "Move"

	var sprite_name: String
	var position: Vector2

	func _init(sprite_name_: String, position_: Vector2):
		sprite_name = sprite_name_
		position = position_
	
	func perform(story_manager):
		story_manager.animation_manager.move(sprite_name, position);

# Actions that complete one after another
# ActionBlocks are not created by the user but are instead, used inside of if statements, etc
class ActionBlock extends Action:
	const TYPE = "ActionBlock"

	var actions: Array

	func _init(actions_: Array):
		actions = actions_

class LabelActionBlock extends Action:
	const TYPE = "LabelActionBlock"

	var action_block: ActionBlock
	var name: String

	func _init(action_block_: ActionBlock, name_: String):
		action_block = action_block_
		name = name_

# Actions that complete simultaneously
class InstantActionBlock extends Action:
	const TYPE = "InstantActionBlock"

	var action_block: ActionBlock

	func _init(action_block_: ActionBlock):
		action_block = action_block_
		
class IfStatement extends Action:
	const TYPE = "IfStatement"
	
	var condition: Condition
	var action_block: ActionBlock

	func _init(condition_: Condition, action_block_: ActionBlock):
		condition = condition_
		action_block = action_block_

class EndBlock:
	const TYPE = "EndBlock"

# Conditions

class Condition:
	var _decision_manager

	func _init(decision_manager_):
		_decision_manager = decision_manager_

	func is_true():
		pass

class FlagCondition extends Condition:
	var flag_name: String

	func _init(decision_manager_, flag_name_: String).(decision_manager_):
		flag_name = flag_name_

	func is_true():
		_decision_manager.has_identifier(flag_name)
extends Reference
class_name Story

const ON = true;
const OFF = false;

var _actions: Array

var _auto_step: bool = false

func _load_story() -> Array:
	_actions = []
	start()
	return _actions

func _add_action(action):
	_actions.append(action)
	if _auto_step:
		step()

# Called when story is started 
func start():
	pass

func auto_step(state: bool):
	_auto_step = state

func step():
	_actions.append(StoryActions.WaitForStep.new())

# CharacterManager
func load_character_assets(directory_path: String):
	_add_action(StoryActions.LoadCharacterAssets.new(directory_path))

func define_character(character_name: String, text_color: Color):
	_add_action(StoryActions.DefineCharacter.new(character_name, text_color))
	
# SpriteManager
func define_sprite(sprite_name: String):
	_add_action(StoryActions.DefineSprite.new(sprite_name))

# TextPrinter
func say(character_name: String, text: String):
	_add_action(StoryActions.Say.new(character_name, text))

func narrate(text: String):
	_add_action(StoryActions.Narrate.new(text))

# AnimationManager
func show(sprite_name: String):
	_add_action(StoryActions.ToggleVisibility.new(sprite_name, true))

func show_animate(sprite_name: String, animation_name: String):
	_add_action(StoryActions.AnimateVisibility.new(sprite_name, animation_name, true))

func hide(sprite_name: String):
	_add_action(StoryActions.ToggleVisibility.new(sprite_name, false))

func hide_animate(sprite_name: String, animation_name: String):
	_add_action(StoryActions.AnimateVisibility.new(sprite_name, animation_name, false))

func move(sprite_name: String, position: Vector2):
	_add_action(StoryActions.Move.new(sprite_name, position))

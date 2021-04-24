# Work on custom compiler first
#extends Reference
#class_name Story
#
#const ON = true;
#const OFF = false;
#
#var _action: StoryActions.Action
#var _action_stream = []
#
#var _auto_step: bool = false
#
#var _block_start_stack: Array
#
#func _load_story_tree() -> StoryActions.Action:
#	_block_start_stack = []
#
#	_action_stream = [
#		_add_action(StoryActions.Start.new())
#	]
#
#	start()
#	return _action
#
#func _add_action(action):
#	# TODO: Set previous and next action correctly
#	# Consider cases like having an action after an action group 
#	# var previous_action = _action_stream[_action_stream.length() - 1]
#	# previous_action.next_action = action
#	# action.previous_action = _previous_action
#	pass
#
## Color Utils
#
#func hsv(hsv_text: String) -> Color:
#	return Color(hsv_text)
#
#func rgb(r: int, g: int, b: int) -> Color:
#	return Color8(r, g, b)
#
## Called when story is started. The user should override this function with their own implementation
#func start():
#	pass
#
#func exists(flag: String) -> StoryActions.Condition:
#	return StoryActions.FlagCondition.new(flag)
#
## TODO FIRST: Implement if. You need to make system that keep track of all if begining and end statements and forms appropriate if groups. We need to code all of the Abstract Syntax Tree generation first before we can start writing the story_manager to traverse the tree every step
#func if_(condition: StoryActions.Condition):
#	var if_statement = StoryActions.IfStatement.new()
#	_action_stream.append(action)
#	_block_start_stack.append(_action_stream.length() - 1)
#
## TODO FIRST: Split story into a story and a parser class. The story is only an input reader/lexer that generates the tokens
## Parser will parse the tokens (Actions).
## Making a separate parser class will make it easier to implmement custom language, since then we only have to build a lexer.
#
## Terminates all blocks, such as if statements, labels, and instant action blocks
#func end_block():
#	_action_stream.append(StoryActions.EndBlock.new())
#
#	# Pop off the last item since it is the most recent start block index
#	var start_index = _block_start_stack.pop_back()
#	# We justed added the EndBlock, therefore the last block is the length()
#	var end_index = _action_stream.length() - 1
#
#	var paired_block = _action_stream[start_index]
#
#	match paired_block.TYPE:
#		["IfStatement", "LabelActionBlock", "InstantActionBlock"]:
#			paired_block.action_block = _get_action_block(start_index, end_index)
#
## Godot compares objects using reference by default: 
## https://godotengine.org/qa/56169/object-equality-comparisons-equivalent-overriding-comparator
#func _get_action_block(start_index, end_index):
#	var actions = []
#
#	# ASSUMPTION: We always start from the most nested block, therefore we will never have to parse an "EndBlock" action
#
#	# Consume the EndBlock action
#	_action_stream[end_index] = null
#
#	# Loop through each action that's inside of the block (Which is the area between the start block and the end block)
#	for i in range(start_index + 1, end_index - 1):
#		if _action_stream[i] != null:
#			actions.append(_action_stream[i])
#
#			# Consume the action
#			_action_stream[i] = null
#
#	return StoryActions.ActionBlock.new(actions)
#
## Labels will use ActionGroup
#func label():
#	pass
#
## TODO: Create groups (Which are actions that are run together and should use InstantActionGroup)
## Group creates an instant action group
#func group():
#	pass
#
## CharacterManager
#
#func load_character_assets(directory_path: String):
#	_add_action(StoryActions.LoadCharacterAssets.new(directory_path))
#
#func define_character(character_name: String, name_color = null, dialogue_color = null):
#	_add_action(StoryActions.DefineCharacter.new(character_name, name_color, dialogue_color))
#
## SpriteManager
#
#func define_sprite(sprite_name: String):
#	_add_action(StoryActions.DefineSprite.new(sprite_name))
#
## TextPrinter
#
#func say(character_name: String, text: String = ""):
#	# We want say to narrate when only the first string arguement is given
#	# or when the character_name is empty
#	if text == "" or character_name == "":
#		narrate(character_name)
#	else:
#		_add_action(StoryActions.Say.new(character_name, text))
#
#func narrate(text: String):
#	_add_action(StoryActions.Narrate.new(text))
#
## AnimationManager
#
#func show(sprite_name: String):
#	_add_action(StoryActions.ToggleVisibility.new(sprite_name, true))
#
#func show_animate(sprite_name: String, animation_name: String):
#	_add_action(StoryActions.AnimateVisibility.new(sprite_name, animation_name, true))
#
#func hide(sprite_name: String):
#	_add_action(StoryActions.ToggleVisibility.new(sprite_name, false))
#
#func hide_animate(sprite_name: String, animation_name: String):
#	_add_action(StoryActions.AnimateVisibility.new(sprite_name, animation_name, false))
#
#func move(sprite_name: String, position: Vector2):
#	_add_action(StoryActions.Move.new(sprite_name, position))

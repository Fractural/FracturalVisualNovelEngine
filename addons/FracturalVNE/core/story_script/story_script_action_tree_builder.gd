class_name StoryScriptActionTreeBuilder
extends Reference

var current_token_position: StoryScriptToken.Position

func generate_action_tree(abstract_syntax_tree) -> StoryScriptActions.Action:
	# TODO: Finish creating action tree
	return StoryScriptActions.Action.new()

func error(message: String, position: StoryScriptToken.Position = current_token_position) -> StoryScriptError:
	return StoryScriptError.new(message, position)

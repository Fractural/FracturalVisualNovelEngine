class_name StoryScriptParser
extends Reference

var constructs = StoryScriptConstants.new()

var reader: StoryScriptTokensReader

func _init():
	pass

func generate_abstract_syntax_tree(reader_: StoryScriptTokensReader):
	reader = reader_

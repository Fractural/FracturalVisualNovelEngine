extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_construct.gd"
# Parses a SoundStatement.


const SoundStatement = preload("sound_statement.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("SoundStatement")
	return arr


func get_keywords() -> Array:
	return ["sound"]


func parse(parser):
	var checkpoint = parser.save_reader_state()
	
	var sound_keyword = parser.expect_token("keyword", "sound")
	if not parser.is_success(sound_keyword):
		return parser.error(sound_keyword, 0)
	
	var channel = parser.expect("Expression")
	if not parser.is_success(channel):
		return parser.error("Expected an expression to after \"sound\" in a sound statement.", 1, checkpoint)
	
	var sound = parser.expect("Expression")
	if not parser.is_success(sound):
		return parser.error("Expected a second expression after the first expression in sound statement.", 1, checkpoint)
	
	if not parser.is_success(parser.expect_token("punctuation", "newline")):
		return parser.error("Expected a new line to conclude a statement.")
	
	return SoundStatement.new(sound_keyword.position, channel, sound)

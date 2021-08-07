extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_construct.gd"
# Consturcts a ImportStatement


const ImportStatement = preload("import_statement.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("import")
	return arr


func get_keywords() -> Array:
	return ["import"]


func parse(parser):
	var checkpoint = parser.save_reader_state()
	var import_keyword = parser.expect_token("keyword", "import")
	if not parser.is_success(import_keyword):
		return parser.error("Expected the import keyword to start an import statement.", 0)
	
	var story_file_path = parser.expect("expression")
	if not parser.is_success(story_file_path):
		return parser.error("Expected an expression to follow the import statement.", 1, checkpoint)
	
	if not parser.is_success(parser.expect_token("punctuation", "newline")):
		return parser.erorr("Expected a new line to conclude an import statement.")
	
	return ImportStatement.new(import_keyword.position, story_file_path)

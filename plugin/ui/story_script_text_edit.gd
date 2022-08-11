tool
extends TextEdit
# A special TextEdit for editing StoryScript files in.


# TODO: Allow each construct to specify the color it wants
#		for it's keywords. This would make it easier to
#		add keywords to the text edit instead of having
#		to edit this script everytime a new keyword is used
#		in a construct.

const NodeConstructConstants = preload("res://addons/FracturalVNE/core/story_script/node_construct_constants.gd")

var constructs = NodeConstructConstants.new().CONSTRUCTS

var keywords = []
var operators = []
var punctuation = []

const FracUtils = FracVNE.Utils

export var text_edit_theme: Resource
export var error_label_path: NodePath
export var caret_position_label_path: NodePath
export var dep__persistent_data_path: NodePath

onready var error_label: RichTextLabel = get_node(error_label_path)
onready var caret_position_label: Label = get_node(caret_position_label_path)
onready var persistent_data = FracUtils.get_valid_node_or_dep(self, dep__persistent_data_path, persistent_data)


func _ready() -> void:
	if FracUtils.is_in_editor_scene_tab(self):
		return
	
	connect("cursor_changed", self, "_on_cursor_changed")
	error_label.connect("meta_clicked", self, "_on_error_label_clicked")
	clear_error()
	
	load_text_edit_theme()


func _on_cursor_changed():
	caret_position_label.text = "(%3s,%3s)" % [str(cursor_get_line() + 1), str(cursor_get_column() + 1)]


func load_text_edit_theme(new_theme: Resource = text_edit_theme):
	if new_theme == null:
		return
	
	for construct in constructs:
		if construct.has_method("get_keywords"):
			_add_array(keywords, construct.get_keywords())
		if construct.has_method("get_operators"):
			_add_array(operators, construct.get_operators())
		if construct.has_method("get_punctuation"):
			_add_array(punctuation, construct.get_punctuation())
	
	highlight_all_occurrences = true
	
	add_font_override("font", text_edit_theme.font)

	add_color_override("background_color", text_edit_theme.background_color)
	
#	var normal_style_box = StyleBoxFlat.new()
#	normal_style_box.bg_color = text_edit_theme.foreground_color
#	add_stylebox_override("normal", normal_style_box)
	
	add_color_override("symbol_color", text_edit_theme.symbol_color)
	
	add_color_override("font_color", text_edit_theme.text_color)
	
	add_color_region('#', '', text_edit_theme.comment_color)
	add_color_override("line_number_color", text_edit_theme.line_number_color)
	
	for keyword in keywords:
		add_keyword_color(keyword, text_edit_theme.keyword_color)
	
	add_color_override("function_color", text_edit_theme.function_color)
	
	add_color_override("selection_color", text_edit_theme.selection_color)
	
	add_color_region('"', '"', text_edit_theme.string_color)
	
	add_color_override("number_color", text_edit_theme.number_color)


func display_error(error: FracVNE.StoryScript.Error):
	# As of now there is no way to highlight a line, therefore we cannot highlight
	# an error in the code right now
	error_label.bbcode_text = '[url={"line":%s, "column":%s}]error(%s,%s): %s[/url]' % [str(error.position.line), str(error.position.column), str(error.position.line + 1), str(error.position.column + 1), error.message]


func clear_error():
	error_label.bbcode_text = ""


func _add_array(array: Array, added_array: Array):
	for added_elem in added_array:
		if not array.has(added_elem):
			array.append(added_elem)


func _on_error_label_clicked(meta):
	var meta_dictionary = parse_json(meta)
	cursor_set_line(meta_dictionary["line"], true)
	cursor_set_column(meta_dictionary["column"], true)


func _setup_editor_assets(assets_registry):
	add_font_override("font", assets_registry.load_asset(get_font("font")))
	error_label.add_font_override("normal_font", assets_registry.load_asset(error_label.get_font("normal_font")))
	caret_position_label.add_font_override("font", assets_registry.load_asset(caret_position_label.get_font("font")))

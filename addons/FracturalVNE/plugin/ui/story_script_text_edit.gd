tool
class_name StoryScriptTextEdit 
extends TextEdit

const ACCENT_1_KEYWORDS = [ "if", "else", "define" ]
const ACCENT_2_KEYWORDS = [ "label", "jump", "==", ">", "<", ">=", "<=" ]
const ACCENT_3_KEYWORDS = [ "Character", "Sprite" ]
const ACCENT_4_KEYWORDS = [ "class" ]

export var text_edit_theme: Resource
export var error_label_path: NodePath
export var caret_position_label_path: NodePath

onready var error_label: RichTextLabel = get_node(error_label_path)
onready var caret_position_label: Label = get_node(caret_position_label_path)

func _ready():
	connect("cursor_changed", self, "_on_cursor_changed")
	error_label.connect("meta_clicked", self, "_on_error_label_clicked")
	
	load_text_edit_theme()

func _setup_editor_assets(assets_registry):
	add_font_override("font", assets_registry.load_asset(get_font("font")))
	error_label.add_font_override("normal_font", assets_registry.load_asset(error_label.get_font("normal_font")))
	caret_position_label.add_font_override("font", assets_registry.load_asset(caret_position_label.get_font("font")))

func _on_cursor_changed():
	caret_position_label.text = "(%3s,%3s)" % [str(cursor_get_line() + 1), str(cursor_get_column() + 1)]

func load_text_edit_theme(new_theme: Resource = text_edit_theme):
	if new_theme == null:
		return
		
	add_font_override("font", text_edit_theme.font)

	add_color_override("background_color", text_edit_theme.background_color)
	
#	var normal_style_box = StyleBoxFlat.new()
#	normal_style_box.bg_color = text_edit_theme.foreground_color
#	add_stylebox_override("normal", normal_style_box)
	
	add_color_override("font_color", text_edit_theme.foreground_color)
	
	add_color_region('#', '', text_edit_theme.comment_color)
	add_color_override("line_number_color", text_edit_theme.comment_color)
	
	for keyword in ACCENT_1_KEYWORDS:
		add_keyword_color(keyword, text_edit_theme.accent_1_color)

	for keyword in ACCENT_2_KEYWORDS:
		add_keyword_color(keyword, text_edit_theme.accent_2_color)

	for keyword in ACCENT_3_KEYWORDS:
		add_keyword_color(keyword, text_edit_theme.accent_3_color)

	for keyword in ACCENT_4_KEYWORDS:
		add_keyword_color(keyword, text_edit_theme.accent_4_color)
		
	add_color_override("function_color", text_edit_theme.accent_3_color)
		
	add_color_region('"', '"', text_edit_theme.string_color)
	
	add_color_override("number_color", text_edit_theme.number_color)

func display_error(message: String, position: StoryScriptToken.Position):
	# As of now there is no way to highlight a line, therefore we cannot highlight
	# an error in the code right now
	error_label.bbcode_text = '[url={"line"=%s, "column"=%s}]at %s error(%s,%s): %s[/url]' % [str(position.line + 1), str(position.column + 1), position.file_path, str(position.line + 1), str(position.column + 1), message]

func _on_error_label_clicked(meta):
	cursor_set_line(meta.line, true)
	cursor_set_column(meta.column, true)

func clear_error():
	error_label.bbcode_text = ""

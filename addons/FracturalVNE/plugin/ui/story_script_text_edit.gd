tool
class_name StoryScriptTextEdit 
extends TextEdit

export var text_edit_theme: Resource

const ACCENT_1_KEYWORDS = [ "if", "else", "define" ]
const ACCENT_2_KEYWORDS = [ "label", "jump", "==", ">", "<", ">=", "<=" ]
const ACCENT_3_KEYWORDS = [ "Character", "Sprite" ]
const ACCENT_4_KEYWORDS = [ "class" ]

func _ready():
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

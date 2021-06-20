extends Control

signal save_slot_pressed(slot_id)

export var screenshot_rect_path: NodePath
export var date_label_path: NodePath
export var button_path: NodePath

onready var screenshot_rect: TextureRect = get_node(screenshot_rect_path)
onready var date_label: Label = get_node(date_label_path)
onready var button: Button = get_node(button_path)

var save_slot
var slot_id: int

func _ready():
	button.connect("pressed", self, "_on_button_pressed")

func _on_button_pressed():
	emit_signal("save_slot_pressed", slot_id)

func init(save_slot_, slot_id_ = null):
	save_slot = save_slot_
	if slot_id_ != null:
		slot_id = slot_id_

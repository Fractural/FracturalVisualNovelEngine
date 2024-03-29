extends Control
# Controls a single save slot. Each save slot displays a thumbnail image and
# the date that it was created.


signal save_slot_pressed(slot_id)

const WEEKDAYS = [
	"Sunday",
	"Monday",
	"Tuesday",
	"Wednesday",
	"Thursday",
	"Friday",
	"Saturday",
]

export var thumbnail_rect_path: NodePath
export var date_label_path: NodePath
export var button_path: NodePath
export var slot_label_path: NodePath

var save_slot
var slot_id: int

onready var thumbnail_rect: TextureRect = get_node(thumbnail_rect_path)
onready var date_label: Label = get_node(date_label_path)
onready var button: Button = get_node(button_path)
onready var slot_label: Label = get_node(slot_label_path)


func _ready() -> void:
	button.connect("pressed", self, "_on_button_pressed")


func construct(slot_id_, save_slot_ = null):
	save_slot = save_slot_
	slot_id = slot_id_
	
	if save_slot == null:
		date_label.text = "Empty"
		thumbnail_rect.texture = null
	else:
		date_label.text = _get_date_string(save_slot.saved_date)
		thumbnail_rect.texture = save_slot.thumbnail
	slot_label.text = "Slot " + str(slot_id)


func _on_button_pressed():
	emit_signal("save_slot_pressed", slot_id)


func _get_date_string(date):
	var hour: int = date["hour"]
	var PM: bool = false
	if date["hour"] > 12:
		hour -= 12
		PM = true
	return "%s/%s/%s, %s, %s:%s " % [date["month"], date["day"], str(date["year"]).right(2), WEEKDAYS[date["weekday"]], hour, date["minute"]] + ("PM" if PM else "AM")

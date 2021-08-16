extends Node
# Displays an integer.


signal changed(new_value)

export var label_path: NodePath
export var spin_box_path: NodePath

onready var label: Label = get_node(label_path)
onready var spin_box: SpinBox = get_node(spin_box_path)


func _ready() -> void:
	spin_box.connect("value_changed", self, "_on_value_changed")


func init(label_text: String, initial_value: int):
	label.text = label_text
	spin_box.value = initial_value


func _on_value_changed(new_value: int) -> void:
	emit_signal("changed", new_value)

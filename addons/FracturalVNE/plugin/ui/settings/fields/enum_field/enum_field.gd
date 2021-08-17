tool
extends Node
# Displays an enum.


signal changed(new_value)

export var label_path: NodePath
export var options_button_path: NodePath

var label: Label
var options_button: OptionButton


func _ready() -> void:
	options_button.connect("item_selected", self, "_on_item_selected")


func init(label_text: String, original_value: int, enum_values: Array):
	label = get_node(label_path)
	options_button = get_node(options_button_path)
	
	label.text = label_text
	options_button.clear()
	for value in enum_values:
		options_button.add_item(value)
	options_button.select(original_value)


func _on_item_selected(index: int) -> void:
	emit_signal("changed", index)

extends Button


const MockBuilder = preload("mock_builder.gd")

var builder = MockBuilder.new("res://addons/FracturalVNE/core", "res://tests/core")


func _ready():
	connect("pressed", self, "_on_pressed")


func _on_pressed():
	builder.build_all_mocks()

extends Node


export var enum_field_prefab: PackedScene
export var int_field_prefab: PackedScene

var loaded_tabs: Array = []



func _ready():
	refresh()


func refresh():
	loaded_tabs = []
	# TODO NOW: FInish


func add_enum_field():
	var field = enum_field_prefab.instance()
	field.init()
	# TODO NOW: Finish

tool
extends Node


export var tree_path: NodePath

onready var tree = get_node(tree_path)


func _ready() -> void:
	var icon = preload("res://addons/FracturalVNE/assets/icons/add.svg")
	
	var root = tree.create_item()
	tree.set_hide_root(false)
	var child1 = tree.create_item(root)
	child1.set_text(0, "Child1")
	child1.set_icon(1, icon)
	var child2 = tree.create_item(root)
	child2.set_text(0, "Child2")
	child2.set_icon(1, icon)
	var subchild1 = tree.create_item(child1)
	subchild1.set_text(0, "Subchild1")
	subchild1.set_icon(1, icon)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta) -> void:
#	pass

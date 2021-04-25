class_name StoryScriptASTNode
extends Reference

var type: String
var children: Array

func _init(type_: String, children_: Array = []):
	type = type_
	children = children_

func add_child(node: StoryScriptASTNode):
	children.append(node)

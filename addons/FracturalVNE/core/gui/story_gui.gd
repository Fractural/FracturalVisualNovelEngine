extends Node

export var story_director_path: NodePath
export var story_manager_path: NodePath
export var story_history_path: NodePath

onready var story_director = get_node(story_director_path)
onready var story_manager = get_node(story_manager_path)
onready var story_history = get_node(story_history_path)

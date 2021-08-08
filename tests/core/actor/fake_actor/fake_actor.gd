extends "res://addons/FracturalVNE/core/actor/actor.gd"
# Fakes an Actor


func _init(cached: bool = false).(cached):
	pass


func _get_controller_prefab():
	return preload("fake_actor.tscn")

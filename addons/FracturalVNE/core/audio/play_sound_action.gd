extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# Action for playing a sound


var story_audio_channel_controller


func _init(story_audio_channel_controller_, skippable_ = true).(skippable_):
	story_audio_channel_controller = story_audio_channel_controller_


func skip():
	story_audio_channel_controller.skip_current_sound()

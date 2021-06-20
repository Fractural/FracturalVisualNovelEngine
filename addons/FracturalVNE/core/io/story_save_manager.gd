extends Node

const SaveState = preload("res://addons/FracturalVNE/core/io/save_state.gd")

signal state_saved(save_state)

const MAX_SAVE_SLOTS = 6
const SAVE_FILES_DIRECTORY = "user://saves/"

var save_slots = []

func _ready():
	preload_save_slots()

func save_state(save_state, save_slot_id: int):
	save_slots[save_slot_id] = save_state
	var save_file = File.new()
	save_file.open_compressed(SAVE_FILES_DIRECTORY + "save_slot_" + str(save_slot_id + 1) + ".save", File.WRITE)
	save_file.store_line(save_state.serialize())
	save_file.close()
	emit_signal("state_saved", save_state)

func get_save_slot(save_slot_id: int):
	return save_slots[save_slot_id]

func has_save_slot(save_slot_id: int):
	return save_slots.has(save_slot_id)

func preload_save_slots():
	save_slots = []
	for i in range(MAX_SAVE_SLOTS):
		var save_file = File.new()
		var save_file_path = SAVE_FILES_DIRECTORY + "/save_slot_" + str(i + 1) + ".save"
		
		if save_file.file_exists(save_file_path):
			save_file.open_compressed(save_file_path, File.READ)
			assert(save_file == OK, "Could not load save slot #%s." % str(i + 1))
			save_slots.append(SerializationUtils.deserialize(save_file.get_line()))
			save_file.close()
		else:
			save_slots.append(null)

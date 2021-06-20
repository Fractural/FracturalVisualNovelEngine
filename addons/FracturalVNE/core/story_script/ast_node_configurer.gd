extends Node

# ----- StoryService Info ----- #

var program_node

func get_service_name():
	return "ASTNodeConfigurer"

func configure_service(program_node_):
	program_node = program_node_
	curr_reference_id = 0

# --- StoryService Info End --- #





var curr_reference_id = 0

func next_reference_id():
	curr_reference_id += 1
	return curr_reference_id - 1

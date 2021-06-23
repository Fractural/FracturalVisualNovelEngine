extends Node
# Responsible for assigning references IDs (essentially UIDs) for each node
# If the tree has not been changed, all nodes should still receive the same
# reference ids. However even a tiny modification can alter the ids that are
# assigned.


# ----- StoryService ----- #

var program_node

func get_service_name():
	return "ASTNodeIDDistributor"

func configure_service(program_node_):
	program_node = program_node_
	curr_reference_id = 0

# ----- StoryService ----- #


var curr_reference_id = 0


func next_reference_id():
	curr_reference_id += 1
	return curr_reference_id - 1

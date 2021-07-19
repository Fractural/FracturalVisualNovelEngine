extends Node
# Controls the creation and destruction of timers that
# can be used within AST nodes, since AST nodes cannot
# create timers by themselves.


# ----- StoryService ----- #

func configure_service(program_node):
	for timer in timers:
		timer.queue_free()
	timers.clear()


func get_service_name():
	return "TimerRegistry"

# ----- StoryService ----- #


var timers: Array = []


func create_timer(duration, start_timer = true):
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = duration
	timers.append(timer)
	
	if start_timer:
		timer.start()
	
	return timer


func remove_timer(timer):
	timers.erase(timer)

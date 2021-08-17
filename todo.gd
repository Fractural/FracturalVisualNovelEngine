# TODO NOW:
#	[ ] Write a remove statement that can remove Visuals
#		Example syntax:
#			define bob = Visual(...)
#			show bob
#			remove bob 			# Deletes the VisualController

# TODO NEXT:


# TODO QUEUE:
#	[ ]	Add type checking for StoryScript binded functions 
#		into the Block's function handling part. We would also
#		have to add an parameter in StoryScript.Param._init() to 
#		accept a type as a string. If this parameter is blank
#		then the StoryScript.Param will accept any type. 
#	[ ] Refactor transitions to take in parameters
#		[ ] Maybe add support for loading animations directly as transitions?
#			Seems too niche though...
#	[ ] Make it optional to add dialog from a printer to the dialog history)
#		[ ] Add lazy loading that only loads the entire story when the game reaches the load statement.
#			Maybe we would have to keep track of the lazy loads in an array in the serialized state and then
#			loaded the current loaded lazy loads whenever the state is deserialized. This array will basically
#			keep track of all loaded storyscripts and also the order they loaded in.
#		[ ]	Create and compile a default .story file that users can then
#			load in for useful global variables.
#			[ ]	PosLeft and PosRight to represent Vector2 on right and left side of
#				the screen. These constants could then be used in move statements.
#	[ ] Refactor all services to have a get_types() method.
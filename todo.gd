# TODO NOW:
#	[ ] Add C# support
#		Make service locator have two service lists -- One for CSharp services and
# 		one for GDScript services.
#
#		Maybe still have the locator parse it's children for services. 
#		If a child is a CSharp class or a GDScript to CSharp wrapper class , then it adds it to the CSharp services.
#		If the child is a GDScript class or a CSharp to GDScript wrapper class, then it adds it to the GDScript services.
#
#		To do this we need to figure out how to differentiate C# vs GDSCript class. IIRC they are two different builtin types.
#		(GDScript and MonoScript? -- Look this up to be sure)
#
#		Maybe make all dependency.gd have two dependencies -
#		a "gdscript_dependency" and a "csharp_dependency".
#		FracVNE.TryGetValidNodeOrDep(self, path, curent, dependency_type = GDSCRIPT) -> csharp_dependency
#		FracVNE.try_get_valid_node_or_dep(self, path, current, dependency_type = CSHARP) -> gdscript_dep

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

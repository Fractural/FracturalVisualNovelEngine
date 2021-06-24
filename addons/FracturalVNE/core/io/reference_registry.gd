extends Node
# Tracks reference objects and can serialize and deserialize them. Used for
# serializing references between objects, since everything that uses a registered
# reference object will only have to store the object's reference ID.


var references: Array = []


func add_reference(reference):
	if not references.has(reference):
		references.append(references)


#func remove_reference(reference)


# ----- Serializeable Reference Template ----- #

# Overridable method that can be called after initialization to add the 
# reference to the ReferenceRegistry. Objects added to the ReferenceRegistry will be
# serialized and saved when the story's state is saved. Objects like
# Characters would have to be registered as a reference.
#
# By being optional method to call, developers can still instantiate instances
# of these reference objects that are not tracked.
func _register_reference():
	# Add instance to the ReferenceRegistry
	StoryServiceRegistry.get_service("ReferenceRegistry").add_reference(self)


# Virtual method that is implemented by references that hold other references
# (meaning they depend on other references). When a reference is deserialized, 
# we may need references that have not yet been deserialized, therefore we 
# defer all fetching of the dependent references to "_fetch_dependencies()", 
# which is called on all references once all references have been serialized. 
func _fetch_dependencies():
	_real_init()


# Virtual method that is used by reference objects to initialize themselves
# once their data is set. In normal objects, initialization would occur in
# "_init()" since you set up the objects' data at the start of "_init()". 
# However since serializeable references finish setting up their data 
# after "_fetch_dependencies()", we need a dedicated method for initializing
# the object's state.
func _real_init():
	pass

# ----- Serializeable Reference Template ----- #

extends Node
# Tracks reference objects and can serialize and deserialize them. Used for
# serializing references between objects, since everything that uses a registered
# reference object will only have to store the object's reference ID.


# ----- StoryService ----- #

func get_service_name():
	return "ReferenceRegistry"

# ----- StoryService ----- #


var references: Array = []


func add_reference(reference: Object):
	if not references.has(reference):
		references.append(reference)


func remove_reference(reference: Object):
	references.erase(reference)


func get_reference(id: int):
	return references[id]


func get_reference_id(reference: Object):
	return references.find(reference)


# ----- Serialization ----- #

func serialize_state():
	var serialized_references = []
	for reference in references:
		serialized_references.append(reference.serialize())
	
	return {
		"service_name": get_service_name(),
		"references": serialized_references,
	}


func deserialize_state(serialized_state):
	references = []
	for serialized_reference in serialized_state["references"]:
		references.append(SerializationUtils.deserialize(serialized_reference))
	
	# Assign dependent references after all references are deserialized.
	# Ensures that whatever references are needed exist when requested for.
	for reference in references:
		if reference.has_method("_fetch_dependencies"):
			reference._fetch_dependencies()

# ----- Serialization ----- #


## ----- Serializeable Reference Template ----- #
#
## Virtual method that is implemented by references that hold other references
## (meaning they depend on other references). When a reference is deserialized, 
## we may need references that have not yet been deserialized, therefore we 
## defer all fetching of the dependent references to "_fetch_dependencies()", 
## which is called on all references once all references have been serialized. 
#func _fetch_dependencies():
#	_post_setup_init()
#
#
## Virtual method that is used by reference objects to initialize themselves
## once their data is set. In normal objects, initialization would occur in
## "_init()" since you set up the objects' data at the start of "_init()". 
## However since serializeable references finish setting up their data 
## after "_fetch_dependencies()", we need a dedicated method for initializing
## the object's state.
#func _post_setup_init():
#	pass
#
## ----- Serializeable Reference Template ----- #

extends Reference
# Template for creating builders that are responsible for
# building some object.


const FracUtils = FracVNE.Utils

# Store all the dependencies needed
# to build an instance of the target object.
var dependency_one: Reference
var other_dependency: int


# build() should return an instance of the object that 
# this builder is reponsible for building. This instance
# should be built with the dependencies that are stored in the
# builder class as member variables.
func build():
	pass


# For each dependency, create an inject_...() function.
# The return value of all inject functions should
# be self (the builder) to allow chaining inject methods.
func inject_dependency_one(dependency_one_):
	# Be sure to not create orphan nodes!
	# If you are adding a node type, be sure
	# to delete the node before setting the new type.
	# 
	# The try_free() method in FracUtils attempts to
	# free the object passed in if there is any,
	# which ensures no memory leaks.
	FracUtils.try_free(dependency_one)
	dependency_one = dependency_one_
	return self


func inject_other_dependency(other_dependency_: int):
	# If a dependnecy is guaranteed to be
	# a primitive type or a builtin Reference type,
	# then you do not need to worry about 
	# freeing it since Godot automatically 
	# frees those objects when they are no longer
	# referenced.
	other_dependency = other_dependency_
	return self


# default() constructs an object with blank dummy dependencies.
# default() should also return self to allow chaining inject
# methods after it.
# default() must take in a single argument of direct. This is 
# the script director used in testing and can be used to
# create blank doubles if default object-based 
# dependencies must be assigned.
func default(direct):
	# You should use the inject_...() methods to 
	# assign these dependencies since the 
	# inject() methods also clear any existing objects
	# to prevent memory leaks with orphan nodes. 
	inject_dependency_one(direct.script_blank(Reference))
	inject_other_dependency(12340)
	return self

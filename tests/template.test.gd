# \/\/ UNCOMMENT \/\/ #
# extends WAT.Test
# Template for creating tests.


# Optional
# This is mostly kept in all tests since you may need FracUtils for
# equality checking, type checking, reparenting, etc.
const FracUtils = FracVNE.Utils


func title():
	# Returns the name of the test. If this is a unit test, then write
	# the name of the class/object that you are unit testing.
	return "Name"


# Name unit tests as test_feature_name, where feature_name
# is the name of the feature being tested.
func test_feature():
	# \/\/ UNCOMMENT \/\/ #
	# describe("context")
	# Use describe() to add a context to the test. describe() should
	# hold a "When" statement to set up the scenario this test takes
	# place in.
	
	# Optional
	# ----- Setup ----- #
	
	# Perform any setup needed here for this test.
	
	# ----- Setup ----- #
	
	
	# Perform the actual test here.
	# Put asserts here to check if the test succeeded
	
	
	# Optional
	# ----- Cleanup ----- #
	
	# Clean up all the objects you've made for the  test here.
	# You can use FracUtils.try_free(object) to free a variables
	# you set, event if that variable was originally null.
	#
	# There is no need to free() doubles, since doubles are automatically
	# managed by WAT.
	#
	# Also be careful of not creating an orphan nodes by 
	# forgetting to free a node!
	
	# ----- Cleanup ----- #
	
	# \/\/ REMOVE \/\/ #
	pass
	

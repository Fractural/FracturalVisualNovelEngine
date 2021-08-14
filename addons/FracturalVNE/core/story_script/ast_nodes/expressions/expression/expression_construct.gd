extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node/node_construct.gd"
# Parses an expression.


func get_parse_types() -> Array:
	return ["Expression"]


# Expression Parsing Classes:
#
# Expression								Handles Binary Operators
#  -> Expression Component					Handles Unary Operators
#      -> Value Component					Handles Function Calls and Parenthesized Expressions
#      		-> Constant Value Component		Handles Literals
# 
# Note that binary expressions will be parsed from right to left.
func parse(parser):
	# The following code will use ASCII visuals to explain
	# what is going on.
	#
	# Legend:
	# [_] = Empty
	# +, -, ÷, * = Add operator, Subtract operator, Divide operator, Multiply operator
	#
	# Binary operator:
	#
	#	                      +
	#	                     / \
	#	                    3   5
	#	Left-hand side (lhs)^   ^ Right-hand side (rhs)
	#
	# Each binary operator has a left-hand side and a right-hand side.
	# Each side can hold either a value or another binary operator.
	#
	# With this, you can build trees using operators.
	# 
	# Operator tree:
	#
	#	           + <--- Root operator
	#	          / \
	#	         /   \
	#	        /     \
	#	       /       \
	#	      /         \
	#	     -           +
	#	    / \         / \
	#	   /   \       /   \
	#	  ÷     *     3     -
	#	 / \   / \         / \
	#	4   6 4   3       3   3
	#
	# An operator tree is a tree build by binary operators.
	# 
	# To evaluate the value of a tree you evaluate the root node (either an operator or a number).
	# 
	# To evaluate an operator you first evaluate the operator's 
	# right-hand side, then evaluate it's left-hand side, and then
	# execute the operation of the root node using both evaluated sides 
	# and finally return the result.
	#
	# To evaluate a number you just return the number as the result.
	var checkpoint = parser.save_reader_state()
	
	# Is the next token a value?
	var lhs = parser.expect("ExpressionComponent")
	if not parser.is_success(lhs):
		return lhs
	
	while true:
		var curr_operator = parser.expect("BinaryOperator")
		if not parser.is_success(curr_operator):
			# Expression only contains one value so just return that one value.
			break;
		
		# Note: operator should always be a binary operator therefore should
		# always have a precedence
		var curr_operator_precedence: int = curr_operator.get_precedence()
		
		var rhs = parser.expect("ExpressionComponent")
		if not parser.is_success(rhs):
			parser.load_reader_state(checkpoint)
			return parser.error("Expected an expression on the right side of the binary operator.")
		
		# Given the lhs is an binary operator, try and steal the number that is the deepest 
		# you can get on the right-side of the lhs operator.
		var rightmost_operator = _find_rightmost_stealable_operator(lhs, curr_operator_precedence)
		
		if rightmost_operator != null:
			# Steal the rhs of the rightmost_statement since the current
			# operator has a higher precedence
			#
			# Visualization:
			# 
			#         Left hand side (lhs)
			#         \/
			#	      +        *   <----- Current operator (curr_operator)
			#	     / \      / \
			#	    /   \   [_]  5 <----- Right-hand side (right_operand)
			#      /     \
			#	  -       +   <------ Right-most operator (rightmost_operoator)
			#	 / \     / \
			#	4   3   1   3 <------ We want to steal this (rightmost_operator.right_operand)
			#
			# The rightmost_operator exists, which means we have an operator tree
			# build on the left-hand side.
			#
			# Stealing the rightmost_operator's right-hand side:
			# 
			#         Left hand side (lhs)
			#         \/
			#	      +         *   <----- Current operator (curr_operator)
			#	     / \       / \
			#	    /   \     3   5
			#      /     \    
			#	  -       +   <------ Right most operator (rightmost_operoator)
			#	 / \     / \
			#	4   3   1  [_] <------ rightmost_operator.right_operand is STOLEN by curr_operator's left-hand-side.
			#
			curr_operator.left_operand = rightmost_operator.right_operand
			curr_operator.right_operand = rhs
			
			# Rebinding:
			# 
			#         Left hand side (lhs)
			#         \/
			#	      +       [_] 
			#	     / \     [_|_]
			#	    /   \   [_] [_]
			#      /     \
			#	  -       +   <------ Right-most operator (rightmost_operoator)
			#	 / \     / \
			#	4   3   1   * <----- Current operator (rightmost_operator.right_operand = curr_operator)
			#              / \
			#             3   5
			#
			# Rebind the current operator underneath the rhs of
			# the rightmost operator.
			rightmost_operator.right_operand = curr_operator
		else:
			# rightmost_operator is null if 
			# - the lhs is not an operator, so we cannot steal a right-side value
			# - the lhs has a higher precedence than the rhs, so we don't want to 
			#   steal it's right-side value
			#
			# Left-hand side (or anything along the right of the left-hand side operator tree) 
			# has a higher precedence than the current operator:
			# 
			#	         !!!
			#	         \/
			#		      *        -   <----- Current operator (curr_operator)
			#		     / \      / \
			#		    /   \   [_]  5 <----- Right-hand side (right_operand)
			#	       /     \
			#		  -       - <------ Right-most operator (rightmost_operoator)
			#		 / \     / \
			#		4   3   1   3
			#
			#	 	Multiplication (*) precedence > Subtraction (-) precedence
			#	
			#		OR
			#
			#		Along the right of the left-hand-side operator tree:
			#			      +        -   <----- Current operator (curr_operator)
			#			     / \      / \
			#			    /   \   [_]  5 <----- Right-hand side (right_operand)
			#		       /     \
			#			  -       * <---!!!
			#			 / \     / \
			#			4   3   1   3
			#	
			#	 	Multiplication (*) precedence > Subtraction (-) precedence
			# 
			# OR 
			# 
			# Left-hand side is not an operator:
			#
			#      Left hand side (lhs)
			#      \/
			#	   3     *   <-- current operator (curr_operator)
			#	        / \
			#	      [_]  5 <-- Right-hand side (rhs)
			#
			# When we do not have a right-hand side operator,
			# we do not have an operator tree built yet.
			# Therefore we can just assign the left-hand
			# side to the current_operator's left-hand side,
			# and assign the right-hand side to the current_operator's
			# right-hand side.
			curr_operator.left_operand = lhs
			curr_operator.right_operand = rhs
			lhs = curr_operator
		
	return lhs


# Finds the rightmost stealable operator given a value and a precedence level.
# `curr_value` can be either a binary operator or just a normal value
#
# You can steal a rightmost value if the `checked_precedence` > the rightmost 
# value's precedence
func _find_rightmost_stealable_operator(curr_value, checked_precedence: int):
	if not Utils.is_type(curr_value, "BinaryOperator"):
		return null
	if curr_value.get_precedence() >= checked_precedence:
		return null
	
	var rhs = curr_value.right_operand
	rhs = _find_rightmost_stealable_operator(rhs, checked_precedence)
	if rhs == null:
		return curr_value
	return rhs

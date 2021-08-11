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
		
		# rightmost_operator is null if 
		# - the lhs is not an operator, so we cannot steal a right-side value
		# - the lhs has a higher precedence than the rhs, so we don't want to 
		#   steal it's right-side value
		if rightmost_operator != null:
			# Steal the rhs of the rightmost_statement since the current
			# operator has a higher precedence
			curr_operator.left_operand = rightmost_operator.right_operand
			curr_operator.right_operand = rhs
			
			# Rebind rightmost_operator to use the current operator on its 
			# right-side, which makes the current operator be evaluated first
			# when the tree is traversed.
			rightmost_operator.right_operand = curr_operator
			
		else:
			curr_operator.right_operand = rhs
			curr_operator.left_operand = lhs
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

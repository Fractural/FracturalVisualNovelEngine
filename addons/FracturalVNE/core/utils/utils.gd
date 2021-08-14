extends Reference
# Static utility class for general purpose functions.


# A constant that maps the type ID to the string for it's name.
# we won't need to include TYPE_OBJECT since we will handle it differently.
const TYPE_TO_STR_MAPPING = {
	TYPE_NIL: "Null",
	TYPE_BOOL: "bool",
	TYPE_INT: "int",
	TYPE_REAL: "float",
	TYPE_STRING: "String",
	TYPE_VECTOR2: "Vector2",
	TYPE_RECT2: "Rect2",
	TYPE_VECTOR3: "Vector3",
	TYPE_TRANSFORM2D: "Transform2D",
	TYPE_PLANE: "Plane",
	TYPE_QUAT: "Quat",
	TYPE_AABB: "AABB",
	TYPE_BASIS: "Basis",
	TYPE_TRANSFORM: "Transform",
	TYPE_COLOR: "Color",
	TYPE_NODE_PATH: "NodePath",
	TYPE_RID: "RID",
	TYPE_OBJECT: "Object",
	TYPE_DICTIONARY: "Dictionary",
	TYPE_ARRAY: "Array",
	TYPE_RAW_ARRAY: "PoolByteArray",
	TYPE_INT_ARRAY: "PoolIntArray",
	TYPE_REAL_ARRAY: "PoolRealArray",
	TYPE_STRING_ARRAY: "PoolStringArray",
	TYPE_VECTOR2_ARRAY: "PoolVector2Array",
	TYPE_VECTOR3_ARRAY: "PoolVector3Array",
	TYPE_COLOR_ARRAY: "PoolColorArray",
}

const STR_TO_TYPE_MAPPING = {
	"Null": TYPE_NIL,
	"bool": TYPE_BOOL,
	"int": TYPE_INT,
	"float": TYPE_REAL,
	"String": TYPE_STRING,
	"Vector2": TYPE_VECTOR2,
	"Rect2": TYPE_RECT2,
	"Vector3": TYPE_VECTOR3,
	"Transform2D": TYPE_TRANSFORM2D,
	"Plane": TYPE_PLANE,
	"Quat": TYPE_QUAT,
	"AABB": TYPE_AABB,
	"Basis": TYPE_BASIS,
	"Transform": TYPE_TRANSFORM,
	"Color": TYPE_COLOR,
	"NodePath": TYPE_NODE_PATH,
	"RID": TYPE_RID,
	"Object": TYPE_OBJECT,
	"Dictionary": TYPE_DICTIONARY,
	"Array": TYPE_ARRAY,
	"PoolByteArray": TYPE_RAW_ARRAY,
	"PoolIntArray": TYPE_INT_ARRAY,
	"PoolRealArray": TYPE_REAL_ARRAY,
	"PoolStringArray": TYPE_STRING_ARRAY,
	"PoolVector2Array": TYPE_VECTOR2_ARRAY,
	"PoolVector3Array": TYPE_VECTOR3_ARRAY,
	"PoolColorArray": TYPE_COLOR_ARRAY,
}


# Gives the type of an object.
static func get_type_name(object):
	match typeof(object):
		TYPE_OBJECT:
			if object.has_method("get_types"):
				return object.get_types()[0]
			return object.get_class()
		_:
			return TYPE_TO_STR_MAPPING[typeof(object)]


# Checks if the object matches all the types
# specified in the types String array.
static func is_types(object, types: Array):
	for type in types:
		if not is_type(object, type):
			return false
	return true


# Checks if the object is a certain type.
static func is_type(object, type: String):
	if _is_custom_type_builtin(object, type):
		return true
	if STR_TO_TYPE_MAPPING.has(type):
		return typeof(object) == STR_TO_TYPE_MAPPING[type]
	if object is Object:
		if object == null:
			# We've already checked for if the type is == null
			# in the STR_TO_TYPE_MAPPING check. Therefore we 
			# can guarantee that the type is not null and 
			# the object is null, which would return false,
			# since a null object is not an object. 
			return false
		if ClassDB.is_parent_class(object.get_class(), type):
			return true
		if object.has_method("get_types"):
			return object.get_types().has(type)
	return false


# Helper method for adding more type classifications
# to builtin types. (Such as assigning the Literal type
# to Strings, ints, and floats)
static func _is_custom_type_builtin(object, type):
	match type:
		"Number":
			return object is int or object is float
		"Literal":
			return (object is int or object is float or object is String)
	return false


# Checks if the object can be casted to a certain type.
static func can_cast(object, type: String):
	if is_type(object, type):
		return true
	return object is Object and object.has_method("get_cast_types") and object.get_cast_types().has(type)


# Attempts to cast an object into specified type.
# If the object cannot be casted then this returns null.
static func implicit_cast(object, type):
	# If an array is passed, then try to cast the object
	# into every type in the array
	if type is Array:
		for type_string in type:
			var result = implicit_cast(object, type_string)
			if result != null:
				return result
	
	var builtin_cast_result = _try_custom_cast_builtin(object, type)
	if builtin_cast_result != null:
		return builtin_cast_result
	if is_type(object, type):
		return object
	elif can_cast(object, type):
		return object.cast(type)
	return null


# Helper method used by implicit_cast() to cast
# a builtin type into something. Since we cannot
# add methods onto builtin types, we instead do
# the builtin type casting here.
static func _try_custom_cast_builtin(object, type):
	# Manual conversion of a builtin:
	match type:
		_:
			pass
	return null


# Checks if two values are the same 
static func equals(value, other_value) -> bool:
	if is_type(value, "Equatable"):
		return value.equals(other_value)
	elif value is Array and other_value is Array:
		# Array element equality
		if value.size() == other_value.size():
			for i in value.size():
				if not equals(value[i], other_value[i]):
					return false
			return true
		else:
			return false
	else:
		# Use the builtin Godot equality check.
		# Note that this will use a reference check
		# by default if the compared values are
		# both Objects.
		return value == other_value


# Checks if the property (a variable defined in a class) 
# of an object equals some value. This will use and equals() 
# function if the object supports equality comparisons.
static func property_equals(object, property: String, value) -> bool:
	var property_value = object.get(property)
	if property_value != null:
		return equals(property_value, value)
	# The property does not exist
	return false


# Reparents a node to a new_parent and returns
# the original parent..
static func reparent(node: Node, new_parent: Node):
	var original = node.get_parent()
	node.get_parent().remove_child(node)
	new_parent.add_child(node)
	return original


# Attempts to free an object.
# Returns true if the object is sucessfully freed.
static func try_free(object):
	if object != null and is_instance_valid(object):
		if object is Array:
			# If object is an array then we will try to 
			# free all elements in an array
			# 
			# Arrays themselves are automatically freed
			# therefore we do not need to free "object".
			# 
			# Note that this implementation supports
			# freeing nested arrays aswell
			for elem in object:
				try_free(elem)
			return true
		elif object is Dictionary:
			# Support for freeing all elements in
			# a dictionary (both keys and values).
			for value in object.values():
				try_free(value)
			for key in object.keys():
				try_free(key)
			return true
		elif not object is Reference:
			object.free()
			return true
	return false

# Gets a node if the orignal_variable is null. 
# If an onready node variable was assigned a node reference 
# before its onready was called, this mehtod would keep
# this reference that it was assigned instead of
# attempting to fetch a new one using node_path.
static func get_node_if_var_null(base_node, node_path, original_variable):
	if original_variable != null:
		return original_variable
	if node_path.is_empty():
		return null
	return base_node.get_node(node_path)


# Snakecase conversions sou/rce:
# https://gist.github.com/me2beats/443b40ba79d5b589a96a16c565952419

# Converts a string from snake-case to camel-case.
static func snake2camel(string: String) -> String:
	var result = PoolStringArray()
	var prev_is_underscore = false
	for ch in string:
		if ch=='_':
			prev_is_underscore = true
		else:
			if prev_is_underscore:
				result.append(ch.to_upper())
			else:
				result.append(ch)
			prev_is_underscore = false


	return result.join('')


# Converts a string from snake-case to pascal-case.
static func snake2pascal(string: String) -> String:
	var result = snake2camel(string)
	result[0] = result[0].to_upper()
	return result


# Converts a string from camel-case to snake-case.
static func camel2snake(string: String) -> String:
	var result = PoolStringArray()
	for ch in string:
		if ch == ch.to_lower():
			result.append(ch)
		else:
			result.append('_'+ch.to_lower())

	return result.join('')


# Converts a string from pascal-case to snake-case.
static func pascal2snake(string: String) -> String:
	var result = PoolStringArray()
	for ch in string:
		if ch == ch.to_lower():
			result.append(ch)
		else:
			result.append('_'+ch.to_lower())
	result[0] = result[0][1]
	return result.join('')


# Checks if a given node is currently in the editor scene tab.
# This has only been tested in Godot v3.3.2.
static func is_in_editor_scene_tab(node):
	if Engine.is_editor_hint():
		# Only tested so far to work on Godot 3.3
		if node == null:
			return false
		elif node.name == "@@5903":
			return true
		return is_in_editor_scene_tab(node.get_parent())
	return false

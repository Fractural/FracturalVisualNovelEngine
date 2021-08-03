extends Reference
# Static utility class for general purpose functions.


# A constant that maps the type ID to the string for it's name.
# we won't need to include TYPE_OBJECT since we will handle it differently.
const TYPE_STR_MAPPING = {
	TYPE_NIL: "Null",
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


# Gives the type of an object.
static func get_type_name(object):
	match typeof(object):
		TYPE_OBJECT:
			if object.has_method("get_types"):
				return object.get_types()[0]
			return object.get_class()
		_:
			return TYPE_STR_MAPPING[typeof(object)]


# Checks if the object is a certain type.
static func is_type(object, type):
	if TYPE_STR_MAPPING.has(typeof(object)):
		return typeof(object) == TYPE_STR_MAPPING[object]
	elif object is Object:
		if object.has_method("get_types"):
			return object.get_types().has(type)
		else:
			return object.get_class() == type
	else:
		assert(false, "Unkown type \"%s\"." % type)


# Checks if the object can be casted to a certain type.
static func can_cast(object, type):
	if is_type(object, type):
		return true
	return object is Object and object.has_method("can_cast") and object.can_cast(type)


# Attempts to cast an object into specified type.
# If the object cannot be casted then this returns null.
static func implicit_cast(object, type):
	if can_cast(object, type):
		return object.cast(type)
	return null


# Reparents a node to a new_parent.
static func reparent(node: Node, new_parent: Node):
	node.get_parent().remove_child(node)
	new_parent.add_child(node)


# Snakecase conversions source:
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

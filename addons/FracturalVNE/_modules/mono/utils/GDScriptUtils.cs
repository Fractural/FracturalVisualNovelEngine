using Godot;
using System;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// Utilities used by Fractural Studios.
/// </summary>
namespace Fractural.Utils
{
	/// <summary>
	/// Utilities for Godot Nodes.
	/// </summary>
	public static class GDScriptUtils
	{
		// Bridges the custom GDScipt typing system
		// into the C# world.

		/// <summary>
		/// Checks the type of a GDScript class.
		/// Only use this when you want compatability 
		/// with GDScript classes.
		/// </summary>
		/// <param name="obj">Object being checked</param>
		/// <returns>Type of "obj" as a string</returns>
		public static string GetTypeName(object obj)
		{
			if (obj is Godot.Object gdObj && gdObj.GetScript() is Godot.GDScript && gdObj.HasMethod("get_types"))
			{
				// GDScript custom type name
				return (gdObj.Call("get_types") as string[])[0];
			}
			return obj.GetType().Name;
		}

		/// <summary>
		/// Check the type of a GDScript class.
		/// Only use this when you want compatability
		/// with GDScript classes.
		/// </summary>
		/// <param name="obj">Object being checked</param>
		/// <param name="type">Type that we want to check</param>
		/// <returns>True if "obj" is "type"</returns>
		public static bool IsType(object obj, string type)
		{
			if (obj is Godot.Object gdObj && gdObj.GetScript() is Godot.GDScript && gdObj.HasMethod("get_types"))
			{
				// GDScript custom type checking
				return Array.Exists((gdObj.Call("get_types") as string[]), typeString => typeString == type);
			}
			return obj.GetType().Name == "type";
		}

		/// <summary>
		/// Attempts to free a Godot Object.
		/// </summary>
		/// <returns>True if the object could be freed</returns>
		public static bool TryFree(Godot.Object obj)
		{
			if (obj != null && !(obj is Reference))
			{
				obj.Free();
				return true;
			}
			return false;
		}

		/// <summary>
		/// Attempts to free a collection of Godot Objects.
		/// </summary>
		/// <param name="collection">Collection to be freed</param>
		/// <returns>True if all elements in "collection" could be freed</returns>
		public static bool TryFree(this IEnumerable<Godot.Object> collection)
		{
			foreach (Godot.Object obj in collection)
			{
				if (!TryFree(obj))
				{
					return false;
				}
			}
			return true;
		}
		
		// The rest of the Utils methods are not
	}
}
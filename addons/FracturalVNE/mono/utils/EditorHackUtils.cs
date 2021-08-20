using System;
using Godot;

namespace Fractural.Utils
{
	/// <summary>
	/// Utils for peeking around the Godot editor, such
	/// as digging through the tree.
	/// </summary>
	public static class EditorHackUtils
	{
		public delegate bool PrintTreeCondition();
		public static void SearchTree(Node parent, PrintTreeCondition condition)
		{
			foreach (Node child in parent.GetChildren())
				SearchTree(child, condition);
			if (condition())
			{
				GD.Print(String.Format("Found Node at: \"{0}\"", parent.GetPath()));
			}
		}
	}
}
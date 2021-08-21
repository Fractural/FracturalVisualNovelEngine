using System.Xml.Serialization;
using System.Diagnostics;
using Godot;
using System;
using Fractural.Utils;

namespace Fractural.DependencyInjection
{
	[Tool]
	public class Dependency : Node
	{
		[Export]
		private Resource classTypeRes;
		public IClassTypeRes ClassTypeRes => (IClassTypeRes) classTypeRes;
		[Export]
		public NodePath DependencyPath { get; set; }
		public object DependencyObject { get; set; }

		public override void _Ready()
		{
			if (NodeUtils.IsInEditorSceneTab(this))
				return;
			
			Debug.Assert(ClassTypeRes != null, "Expected a ClassTypeRes for a Dependency node.");
			
			if (DependencyObject == null && DependencyPath != null)
			{
				var node = GetNode(DependencyPath);
				if (node is Dependency dependencyNode)
				{
					DependencyObject = dependencyNode.DependencyObject;
				} else
					DependencyObject = node;
			}
			
			Debug.Assert(DependencyObject.GetType() == ClassTypeRes.Type, $"Expected the injected dependency to be of type {ClassTypeRes.Type}.");
		}
	}
}
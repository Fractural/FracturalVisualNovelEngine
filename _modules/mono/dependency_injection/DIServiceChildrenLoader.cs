using Godot;
using System;

namespace Fractural.DependencyInjection
{
	/// <summary>
	/// Loads it's children as services for the DIContainer.
	/// </summary>
	public class DIServiceChildrenLoader : Node
	{
		public DIContainer DIContainer;

		[Export]
		private NodePath diContainerPath;

		public override void _Ready()
		{
			DIContainer = GetNode<DIContainer>(diContainerPath);
			foreach (NodePath path in GetChildren())
				DIContainer.AddDependency(GetNode(path));
		}
	}
}
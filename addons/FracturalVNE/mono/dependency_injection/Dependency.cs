using Godot;
using System;
using MonoCustomResourceRegistry;
using Fractural.Utils;

namespace Fractural.DependencyInjection
{
	[Tool]
	public class Dependency : Node, IRegisteredResource
	{
		[Export]
		private Resource classTypeRes;
		public IClassTypeRes ClassTypeRes => (IClassTypeRes) classTypeRes;
		[Export]
		public NodePath DependencyPath { get; set; }

		public override void _Ready()
		{
			GD.Print("DEPENDENCY READY");
			GD.Print(ClassTypeRes.DependencyType.FullName);
		}
	}
}
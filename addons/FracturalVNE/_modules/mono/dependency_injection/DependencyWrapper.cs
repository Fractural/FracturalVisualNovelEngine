using Godot;
using System;

namespace Fractural.DependencyInjection
{
	public class DependencyWrapper : IGDScriptWrapper
	{
		public Godot.Object Source { get; }

		public DependencyWrapper(Godot.Node dependency)
		{
			Source = dependency;
		}

		public string DependencyName
		{
			get
			{
				return (string) Source.Get("dependency_name");
			}
			set
			{
				Source.Set("dependency_name", value);
			}
		}

		public NodePath DependencyPath
		{
			get
			{
				return (NodePath) Source.Get("dependency_path");
			}
			set
			{
				Source.Set("dependency_path", value);
			}
		}

		public Godot.Object DependencyObject
		{
			get
			{
				return (Godot.Object) Source.Get("dependency");
			}
			set
			{
				Source.Set("dependency", value);
			}
		}

		public object CSharpDependencyObject
		{
			get
			{
				return (object) Source.Get("csharp_dependency");
			}
			set
			{
				Source.Set("csharp_dependency", value);
			}
		}
	}
}
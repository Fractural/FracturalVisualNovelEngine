using Godot;
using System;
using Fractural.DependencyInjection;

#if TOOLS
namespace Fractural.Mono
{
	public class PluginExtension : Reference
	{
		public EditorPlugin Plugin { get; set; }

		public PluginExtension() {}

		public PluginExtension(EditorPlugin plugin)
		{
			Plugin = plugin;
			Init();
		}

		private void Init()
		{
			Plugin.AddCustomType(nameof(Dependency), nameof(Node), GD.Load<Script>("res://addons/FracturalVNE/mono/dependency_injection/Dependency.cs"), );
		}
	}
}
#endif
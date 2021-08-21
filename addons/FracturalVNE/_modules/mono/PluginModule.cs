using System.Diagnostics.Tracing;
using Godot;
using System;
using Fractural.DependencyInjection;
using Fractural.Plugin.AssetsRegistry;
using Fractural.Utils;

#if TOOLS
namespace Fractural.Mono
{
	public class PluginModule : Reference
	{
		public static string PluginAbsolutePath = "res://addons/FracturalVNE/";

		public EditorPlugin Plugin { get; set; }
		public IAssetsRegistry AssetsRegistry { get; set; }

		public PluginModule() {}

		public PluginModule(EditorPlugin plugin)
		{
			Plugin = plugin;
			AssetsRegistry = new EditorAssetsRegistry(plugin);
			Init();
		}

		private void Init()
		{
			EngineUtils.UpdateVersionPreprocessorDefines();
			Plugin.AddCustomType(nameof(Dependency), 
				nameof(Node), 
				GD.Load<Script>(PluginAbsolutePath + "_modules/mono/dependency_injection/Dependency.cs"), 
				AssetsRegistry.LoadAsset<Texture>(PluginAbsolutePath + "assets/icons/dependency.svg")
				);
		}
	}
}
#endif
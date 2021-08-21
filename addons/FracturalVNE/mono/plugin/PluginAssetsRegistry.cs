using System.Security.AccessControl;
using System.Runtime.Serialization;
using System.Runtime.InteropServices;
using System.Threading.Tasks.Dataflow;
using System.Linq;
using System.Diagnostics;
using System;
using Godot;
using Fractural.Utils;
using Fractural.Information;
using System.Collections.Generic;

namespace Fractural.Plugin.AssetsRegistry
{
	public interface IAssetsRegistry 
	{
		float Scale { get; }

		/// <summary>
		/// Loads the scaled veresion of an asset from a
		/// given path.
		/// </summary>
		/// <param name="path"></param>
		/// <typeparam name="T"></typeparam>
		/// <returns></returns>
		T LoadAsset<T>(string path) where T : class;

		/// <summary>
		/// Loads the scaled version of an existing asset.
		/// </summary>
		/// <param name="asset"></param>
		/// <typeparam name="T"></typeparam>
		/// <returns></returns>
		T LoadAsset<T>(T asset) where T : class;
	}

	public class AssetProcessingAssetsRegistry : IAssetsRegistry
	{
		public float Scale { get; set; } = 1;
		public Dictionary<object, object> LoadedAssets { get; private set; }
		public List<AssetProcessor> Processors;

		public T LoadAsset<T>(string path) where T : class
		{
			return LoadAsset<T>(ResourceLoader.Load<T>(path));
		}

		public T LoadAsset<T>(T asset) where T : class
		{
			if (LoadedAssets.ContainsKey(asset))
				return (T) LoadedAssets[asset];
			foreach (AssetProcessor processor in Processors)
			{
				if (processor.CanProcess(asset))
				{
					T result = (T) processor.Process(asset);
					LoadedAssets.Add(asset, result);
					return result;
				}
			}
			GD.PushError($"Cannot scale asset of type {asset.GetType().FullName}");
			return default(T);
		}
	}

	public class EditorAssetsRegistry : IAssetsRegistry
	{
		const string PluginAbsolutePathPrefix = "res://addons/FracturalVNE";
		
		private EditorPlugin plugin;

		private float cachedEditorScale = -1;
		public float Scale
		{
			get
			{
				if (EngineUtils.CurrentVersionInfo >= "3.3")
					return plugin.GetEditorInterface().GetEditorScale();
				else
				{
					if (cachedEditorScale == -1)
					{
						if (EngineUtils.CurrentVersionInfo >= "3.1")
							return CalculateCurrentEditorScale_3_0();
						else if (EngineUtils.CurrentVersionInfo >= "3.0")
							return CalculateCurrentEditorScale_3_1();
						else
						{
							GD.PushError($"Could not fetch editor scale for the current Godot version. ({EngineUtils.CurrentVersionInfo})");
							return 1;
						}
					}
					else
						return cachedEditorScale;
				}
			}
		}

		private IAssetsRegistry assetsRegistry;

		public EditorAssetsRegistry(IAssetsRegistry assetsRegistry, EditorPlugin plugin)
		{
			this.plugin = plugin;
			this.assetsRegistry = assetsRegistry;
		}
		
		private float CalculateCurrentEditorScale_3_0()
		{
			EditorSettings editorSettings = plugin.GetEditorInterface().GetEditorSettings();
			
			int displayScale = (int) editorSettings.GetSetting("interface/editor/display_scale");
			float customDisplayScale = (int) editorSettings.GetSetting("interface/editor/custom_display_scale");

			switch (displayScale)
			{
				case 0:
					if (OS.GetName() == "OSX")
						return OS.GetScreenMaxScale();
					else
					{
						int screen = OS.GetCurrentScreen();
						if (OS.GetScreenDpi(screen) >= 192 && OS.GetScreenSize(screen).x > 2000)
							return 2.0f;
						else
							return 1.0f;
					} 
				case 1:
					return 0.75f;
				case 2:
					return 1.0f;
				case 3:
					return 1.25f;
				case 4:
					return 1.5f;
				case 5:
					return 1.5f;
				case 6:
					return 2.0f;
				default:
					return customDisplayScale;
			}
		}

		private float CalculateCurrentEditorScale_3_1()
		{
			EditorSettings editorSettings = plugin.GetEditorInterface().GetEditorSettings();

			int dpiMode = (int) editorSettings.GetSetting("interface/editor/hidpi_mode");

			switch (dpiMode)
			{
				case 0:
					int screen = OS.GetCurrentScreen();
					if (OS.GetScreenDpi(screen) >= 192 && OS.GetScreenSize(screen).x > 2000)
						return 2.0f;
					else
						return 1.0f;
				case 1:
					return 0.75f;
				case 2:
					return 1.0f;
				case 3:
					return 1.5f;
				case 4:
					return 2.0f;
				default:
					return 1;
			}
		}
	}
}
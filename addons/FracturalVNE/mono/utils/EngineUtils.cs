using System.Linq;
using Godot;
using System;
using System.Collections;
using System.Collections.Generic;
using Fractural.Information;

/// <summary>
/// Utilities used by Fractural Studios.
/// </summary>
namespace Fractural.Utils
{
	/// <summary>
	/// Utilities for Engine related things.
	/// </summary>
	public static class EngineUtils
	{
		public static VersionInfo CurrentVersionInfo
		{
			get
			{
				return new VersionInfo(
					(int) Engine.GetVersionInfo()["major"],
					(int) Engine.GetVersionInfo()["minor"],
					(int) Engine.GetVersionInfo()["patch"]
				);
			}
		}
	}
}
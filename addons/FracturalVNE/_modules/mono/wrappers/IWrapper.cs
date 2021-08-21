using Godot;
using System;

namespace Fractural.GDScriptWrappers
{
	public interface IGDScriptWrapper
	{
		Godot.Object Source { get; }
	}
}
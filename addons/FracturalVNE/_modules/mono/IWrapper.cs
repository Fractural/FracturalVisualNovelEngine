using Godot;
using System;

namespace Fractural.VisualNovelEngine
{
    public interface IGDScriptWrapper
    {
        Godot.Object Source { get; }
    }
}
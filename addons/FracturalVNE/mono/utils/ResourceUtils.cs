using Godot;
using System;

namespace Fractural.Utils
{
	public static class ResourceUtils
	{
		public static T ExportTypeSetter<T>(Resource value)
		{
			if (value is T castedValue)
				return castedValue;
			return default(T);
		}
	}
}
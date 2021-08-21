using Godot;
using System;

namespace Fractural
{
	public interface IClassTypeRes
	{
		Type DependencyType { get; }
	}

	/// <summary>
	/// A resouce to store a class type.
	/// By using resources to represent types, we can rename classes
	/// while keeping already existing references to the type.
	/// 
	/// Only one ClassTypeRes should exist for each C# class.
	/// </summary>
	/// <typeparam name="T"></typeparam>
	public class ClassTypeRes<T> : Resource, IClassTypeRes
	{
		public Type DependencyType => typeof(T);
	}
}
using System.IO;
using Godot;
using System;


public class SelfContainedStory : WAT.Test
{
    [Test]
	public void Test()
	{
		Describe("This is a test");
		Assert.IsTrue(true, "Asserts true!");
	}
}

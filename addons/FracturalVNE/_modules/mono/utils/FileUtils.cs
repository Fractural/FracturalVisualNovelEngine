using Godot;
using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace Fractural.Utils
{
	public static class FileUtils
	{
		public static List<string> GetDirFiles(
			string rootPath, 
			bool searchSubDirectories = true, 
			string[] fileExtensions = null)
		{
			return GetDirContents(rootPath, searchSubDirectories, fileExtensions).files;
		}

		public static List<string> GetDirDirectories(
			string rootPath, 
			bool searchSubDirectories = true, 
			string[] fileExtensions = null)
		{
			return GetDirContents(rootPath, searchSubDirectories, fileExtensions).directories;
		}

		public static (List<string> files, List<string> directories) GetDirContents(
			string rootPath, 
			bool searchSubDirectories = true,
			string[] fileExtensions = null)
		{
			var hashSet = fileExtensions == null ? null : new HashSet<string>(fileExtensions);
			return GetDirContents(rootPath, searchSubDirectories, hashSet);
		}

		public static (List<string> files, List<string> directories) GetDirContents(
			string rootPath, 
			bool searchSubDirectories = true, 
			HashSet<string> fileExtensions = null)
		{
			var files = new List<string>();
			var directories = new List<string>();
			var dir = new Directory();

			Debug.Assert(rootPath != "", "Expected rootPath to not be empty!");

			var error = dir.Open(rootPath);
			if (error == Error.Ok)
			{
				dir.ListDirBegin(true, false);
				AddDirContents(dir, files, directories, searchSubDirectories, fileExtensions);
			}
			else
			{
				GD.PushWarning($"GetDirContents(): An error occured when trying to access the path. Error code: \"{error}\" ");
			}
			
			return (files, directories);
		}

		private static void AddDirContents(
			Directory directory, 
			List<string> files, 
			List<string> directories, 
			bool searchSubDirectories = true,
			HashSet<string> fileExtensions = null)
		{
			var fileName = directory.GetNext();

			while (fileName != "")
			{
				var path = directory.GetCurrentDir() + "/" + fileName;
				if (directory.CurrentIsDir())
				{
					var subDir = new Directory();
					subDir.Open(path);
					subDir.ListDirBegin(true, false);
					directories.Add(path);

					if (searchSubDirectories)
					{
						AddDirContents(subDir, files, directories, searchSubDirectories, fileExtensions);
					}
				}
				else
				{
					if (fileExtensions == null)
						files.Add(path);
					else
					{
						if (!Engine.EditorHint)
							path = path.TrimSuffix(".import");
						if (fileExtensions.Contains(path.GetExtension()))
							files.Add(path);
					}	
				}

				fileName = directory.GetNext();
			}

			directory.ListDirEnd();
		}
	}
}
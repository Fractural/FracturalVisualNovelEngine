using System.Linq;

namespace Fractural.Utils
{
	/// <summary>
	/// Utility class for C# related functions.
	/// </summary>
	public static class CSharpUtils
	{
		public static int CombineHashCodes(int h1, int h2)
		{
			return ((h1 << 5) + h1) ^ h2;
		}

		public static string TrimSuffix(this string str, string trimmedString)
		{
			return str.Substring(0, str.LastIndexOf(trimmedString));
		}

		public static string TrimPrefix(this string str, string trimmedString)
		{
			return str.Substring(str.IndexOf(trimmedString) + trimmedString.Length);
		}

		/// <summary>
		/// Gets the extension of a file path (excluding the period).
		/// </summary>
		/// <param name="filePath">File path as a string</param>
		/// <returns>Extension of the file (excluding the period)</returns>
		public static string GetExtension(this string filePath)
		{
			return filePath.Split('.').Last();
		}
	}
}
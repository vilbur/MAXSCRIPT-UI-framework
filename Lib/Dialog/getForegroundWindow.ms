/*
*/ 
(
	fn getForegroundWindow =
	(
		local source  = "using System;"
		source += "using System.Runtime.InteropServices;"
		source += "public class Window"
		source += "{"
		source += "	[DllImport(\"user32.dll\")]"
		source += "	public static extern IntPtr GetForegroundWindow();"
		source += "}"

		local csharpProvider = dotNetObject "Microsoft.CSharp.CSharpCodeProvider"
		local compilerParams = dotNetObject "System.CodeDom.Compiler.CompilerParameters"
		compilerParams.GenerateInMemory = true
		compilerParams.ReferencedAssemblies.Add "System.dll"
		local compilerResults = csharpProvider.CompileAssemblyFromSource compilerParams #(source)
		compilerResults.CompiledAssembly.CreateInstance "Window"
	)
	if NOT isKindOf ::window dotNetObject do window = getForegroundWindow()
)

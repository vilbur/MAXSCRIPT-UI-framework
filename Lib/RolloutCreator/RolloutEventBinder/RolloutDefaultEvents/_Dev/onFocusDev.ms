clearListener()

(
	fn getWindowClass =
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
	if NOT isKindOf ::window dotNetObject do window = getWindowClass()
)

try destroyDialog ::focus_test catch()
rollout focus_test "Focus Test"
(
	local prevFocus = true, currFocus = true
	timer clock interval:100
	--label lblFocus "IN FOCUS"

  	on clock tick do
  	(
		--lblFocus.text = if focus_test.hwnd == (window.getForegroundWindow()) then "IN FOCUS" else "OUT OF FOCUS"
		if focus_test.hwnd == ( window .getForegroundWindow()) then print "IN FOCUS" else print "OUT OF FOCUS"
		
		if focus_test.hwnd == ( window.getForegroundWindow()) then focus_test.height = 256 else focus_test.height = 64
		
		
		
		
  	)
)
CreateDialog focus_test






/** Test Script
 */
macroscript macro_prefix_this_is_macroscript_name
category:	"_Foo-Category"
buttonText:	"Prefix Test Script"
toolTip:	"tooltip prefix tooltip text"
icon:	"menu:true|across:4"
(
	on isVisible	return 1>0


	on execute do (
		print "Command executed"
	)

	on AltExecute type do (
		print "Hello world"
	)
)


filein (getFilenamePath(getSourceFileName()) + "/include_file.ms")

/** Prefix Test Script
 */
macroscript:	macro_prefix_this_is_macroscript_name
buttonText:	"Prefix Test Script"
category:	"_Foo-Category "
toolTip:	"tooltip prefix "
icon:	"menu:true "
(
	on isVisible do	true
	on isEnabled do	true
	on isChecked do	true

	on execute do (
		print "executed"
	)
	on AltExecute do (
		print "on AltExecute"
	)
)

/** Prefix This can be also used as button text
 */
macroscript:	macro_prefix_This_can_be_also_used_as_button_text
buttonText:	"Prefix This can be also used as button text"
category:	"_Foo-Category "
toolTip:	"tooltip prefix "
icon:	"menu:true "
(

	on execute do (
		print "executed"
	)
)


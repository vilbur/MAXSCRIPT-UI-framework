/** Prefix Test Script
 */
macroscript		macro_prefix_this_is_macroscript_name
toolTip:	"tooltip prefix"
icon:	"menu:true"
buttonText:	"Prefix Test Script"
category:	"_Foo-Category"
(
	on isEnabled do	true
	on isChecked do	true
	on isVisible do	return true

	on execute do (
		print "Command executed"
	)

	on AltExecute type do (
		print "Hello world"
	)
)

/** Prefix This can be also used as button text
 */
macroscript		macro_prefix_This_can_be_also_used_as_button_text
toolTip:	"tooltip prefix"
icon:	"menu:true"
buttonText:	"Prefix This can be also used as button text"
category:	"_Foo-Category"
(
	on isVisible do	return true

	on AltExecute type do (
		print "If command start with quotes, then double must be used quotes"
	)
)


/** Test Script
 */
macroscript macro_prefix_this_is_macroscript_name
category:	"_Foo-Category"
buttonText:	"Test Script"
toolTip:	"tooltip prefix tooltip text"
icon:	"menu:true|across:4"
(
	on isVisible	do 1 > 0
	on isChecked	do true
	on isEnabled	do true or false
	on isIndeterminate	do false

	on execute do (
		print "Command executed"
	)

	on AltExecute type do (
		print "Hello world"
	)
)

/** macroscript name is button text
 */
macroscript macro_prefix_macroscript_name_is_button_text
category:	"_Foo-Category"
buttonText:	"macroscript name is button text"
toolTip:	"tooltip prefix"
icon:	"menu:true"
(
	on isVisible	do 1 > 0
	on isChecked	do true
	on isEnabled	do true

	on execute do (
		print "If command start with quotes, then double must be used quotes"
	)
)

/** general keys used as variables
 */
macroscript macro_prefix_general_keys_used_as_variables
category:	"_Foo-Category"
buttonText:	"general keys used as variables"
toolTip:	"tooltip prefix"
icon:	"menu:true"
(
	on isVisible	do 1 > 0
	on isChecked	do true
	on isEnabled	do true

	on execute do (
		print "general keys used as variables"
	)

	on AltExecute type do (
		print "macro_prefix_general_keys_used_as_variables"
	)
)

/** [tooltip prefix Tooltip as hidden button text]
 */
macroscript macro_prefix_hidden_button_text
category:	"_Foo-Category"
buttonText:	"[tooltip prefix Tooltip as hidden button text]"
toolTip:	"tooltip prefix Tooltip as hidden button text"
icon:	"menu:true"
(
	on isVisible	do 1 > 0
	on isChecked	do true
	on isEnabled	do true

	on execute do (
		print "hiddenbuttontext"
	)
)


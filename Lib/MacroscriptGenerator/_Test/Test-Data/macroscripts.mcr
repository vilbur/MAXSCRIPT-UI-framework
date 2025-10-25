/** Test Script
 */
macroscript macro_prefix_this_is_macroscript_name
category:	"_Test-Category"
toolTip:	"tooltip prefix tooltip text"
icon:	"menu:true|across:4"
buttonText:	"Test Script"
(
	on isIndeterminate	do false
	on isVisible	do 1 > 0
	on isEnabled	do true or false
	on isChecked	do true

	on AltExecute type do
	(
		print "Hello world"
	)
)

/** macroscript name is button text
 */
macroscript macro_prefix_macroscript_name_is_button_text
category:	"_Test-Category"
toolTip:	"tooltip prefix"
icon:	"menu:true"
buttonText:	"macroscript name is button text"
(
	on isVisible	do 1 > 0
	on isEnabled	do true
	on isChecked	do true
)

/** general keys used as variables
 */
macroscript macro_prefix_general_keys_used_as_variables
category:	"_Test-Category"
toolTip:	"tooltip prefix"
icon:	"menu:true"
buttonText:	"general keys used as variables"
(
	on isVisible	do 1 > 0
	on isEnabled	do true
	on isChecked	do true

	on AltExecute type do
	(
		print "macro_prefix_general keys used as variables"
	)
)

/** [tooltip prefix Tooltip as hidden button text]
 */
macroscript macro_prefix_hidden_button_text
category:	"_Test-Category"
toolTip:	"tooltip prefix Tooltip as hidden button text"
icon:	"menu:true"
buttonText:	"[tooltip prefix Tooltip as hidden button text]"
(
	on isVisible	do 1 > 0
	on isEnabled	do true
	on isChecked	do true
)


/** Prefix Test Script
 */
macroscript this_is_macroscript_name
category:	"_Foo-Category"
buttonText:	"Prefix Test Script"
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

/** Prefix macroscript name is button text
 */
macroscript macroscript_name_is_button_text
category:	"_Foo-Category"
buttonText:	"Prefix macroscript name is button text"
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

/** Prefix general keys used as variables
 */
macroscript general keys used as variables
category:	"_Foo-Category"
buttonText:	"Prefix general keys used as variables"
toolTip:	"tooltip prefix"
icon:	"menu:true"
(
	on isVisible	do 1 > 0
	on isChecked	do true
	on isEnabled	do true

	on execute do (
		print "Prefix general keys used as variables"
	)

	on AltExecute type do (
		print "general keys used as variables"
	)
)

/** Prefix [Prefix [{buttontext}]]
 */
macroscript hidden button text
category:	"_Foo-Category"
buttonText:	"Prefix [Prefix [{buttontext}]]"
toolTip:	"tooltip prefix"
icon:	"menu:true"
(
	on isVisible	do 1 > 0
	on isChecked	do true
	on isEnabled	do true

	on execute do (
		print "hiddenbuttontext"
	)
)


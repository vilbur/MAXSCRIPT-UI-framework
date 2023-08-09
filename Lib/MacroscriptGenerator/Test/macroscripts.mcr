/** Prefix Test Script
 */
macroscript macro_prefix_this_is_macroscript_name
category:	"_Foo-Category"
buttonText:	"Prefix Test Script"
toolTip:	"tooltip prefix tooltip text"
icon:	"menu:true|across:4"
(
	on isVisible	do 1>0
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

/** Prefix This can be also used as button text
 */
macroscript macro_prefix_This_can_be_also_used_as_button_text
category:	"_Foo-Category"
buttonText:	"Prefix This can be also used as button text"
toolTip:	"tooltip prefix"
icon:	"menu:true"
(
	on isVisible	do 1>0
	on isChecked	do true
	on isEnabled	do true

 on execute do (
		print "If command start with quotes, then double must be used quotes"
	)
)

/** Prefix This is buttontext and executed value as it is
 */
macroscript macro_prefix_This_is_buttontext_and_executed_value_as_it_is
category:	"_Foo-Category"
buttonText:	"Prefix This is buttontext and executed value as it is"
toolTip:	"tooltip prefix"
icon:	"menu:true"
(
	on isVisible	do 1>0
	on isChecked	do true
	on isEnabled	do true

 on execute do (
		print "Prefix This is buttontext and executed value as it is"
	)

 on AltExecute type do (
		print "This_is_buttontext_and_executed_value_as_it_is"
	)
)

/** Prefix White Space Is Removed If Execute Value Is Missing
 */
macroscript macro_prefix_White_Space_Is_Removed_If_Execute_Value_Is_Missing
category:	"_Foo-Category"
buttonText:	"Prefix White Space Is Removed If Execute Value Is Missing"
toolTip:	"tooltip prefix"
icon:	"menu:true"
(
	on isVisible	do 1>0
	on isChecked	do true
	on isEnabled	do true

 on execute do (
		print "White Space Is Removed If Execute Value Is Missing"
	)
)


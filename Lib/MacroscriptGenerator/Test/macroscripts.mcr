/** Test Script
 */
macroscriptthis_is_macroscript_name
category:""
buttonText:"Test Script"
toolTip:""
icon:""
(
	on isVisible	do 1>0
	on isChecked	do true	and	true
	on isEnabled	do true or false
	on isIndeterminate	do false

	on execute do (
		print "Command executed"
	)

	on AltExecute type do (
		print"Hello world"
	)
)

/** This can be also used as button text
 */
macroscriptThis_can_be_also_used_as_button_text
category:""
buttonText:"This can be also used as button text"
toolTip:""
icon:""
(
	on isVisible	do 1>0
	on isChecked	do true
	on isEnabled	do true
	on isIndeterminate	do 

	on execute do (
		
	)

	on AltExecute type do (
		print"If command start with quotes, then double must be used quotes"
	)
)


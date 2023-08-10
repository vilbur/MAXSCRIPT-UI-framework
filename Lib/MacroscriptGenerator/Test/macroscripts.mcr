/** Prefix this is macroscript name
 */
macroscript macro_prefix_this_is_macroscript_name
category:	"_Foo-Category"
buttonText:	"Prefix this is macroscript name"
toolTip:	"tooltip prefix"
icon:	"menu:true"
(
	on isVisible	do 1>0
	on isChecked	do true
	on isEnabled	do true

 on execute do (
		print "this_is_macroscript_name"
	)
)


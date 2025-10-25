/** Button Text
 */
macroscript Test_macro_1
category:	"_Test-Category"
buttonText:	"Button Text"
(
	on isVisible	do true

	on execute do
	(
		messageBox "Macro Executed"
	)

	on altExecute type do
	(
		messageBox "Alternate Executed"
	)
)


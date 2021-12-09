clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Dialog/Dialog.ms" ) 

/*  Import callback methods
  
	CallbackNoParam()
	CallbackWithValue(val)
	CallbackWith2Params(arg_1) (arg_2)
*/ 


--include "Library/MAXSCRIPT-UI-framework/Lib/Dialog/Rollout/EventsList/_Test/inlcude_test_callbacks.ms"

/*------ CREATE FLOAT    ER DIALOG ------*/
Dialog	= Dialog_v title:"Test" ini:(getFilenamePath(getSourceFileName()) + "2_DialogEventTest.ini") --load:true




/** Dockdialog
 */
function dockdialog =
(
	Dialog.dock #left
)

/*  
	SET CUSTOM EVENTS
*/

Dialog.Events.add #open	"print(\"#open\")"
Dialog.Events.add #close	"print(\"#close\")"
Dialog.Events.add #moved	"print(\"#moved\")"
Dialog.Events.add #resized	"print(\"#resized\")"
Dialog.Events.add #docked	"print(\"#docked\")"

--Dialog.Events.add #oktoclose	"CallbackNoParam()"
--
Dialog.Events.add #lbuttondblclk	"dockdialog()"
--Dialog.Events.add #lbuttondown	"CallbackWithValue(val)"


/* CREATE DIALOG */
Dialog.create()

Dialog.register()




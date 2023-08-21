clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/Dialog/Dialog.ms" ) -- "./../../../Lib/Dialog/Dialog.ms"

/* DIALOG */
Dialog 	    = Dialog_v title:"Test"

_Controls   = Dialog.Controls group:"Main Controls"

_Controls.Default #across 1
/*------------------------------------------------------------------------------

	CALLACKS

--------------------------------------------------------------------------------*/
/** MACRO CALLBACK
 */
macroscript	_test_control_callback_macro
category:	"_Test"
(
	format "Macro:EventFired:	% \n" EventFired
)
/** 0 PRAMAS
 */
function CallbackNoParam = (format "\nCallbackNoParam()\nEventFired:	% \n" EventFired)

/** 1 PARAMETER
 */
function Callback1Param val = (format "Callback1Param()\nval: % \n" val)

/** 2 PARAMETERS
 */
function Callback2Params arg_1 arg_2 = (format "Callback2Params()\narg_1: % \narg_2: % \n" arg_1 arg_2)

/** 3 PARAMETERS
 */
function Callback3Params arg_1 arg_2 arg_3 = (format "Callback3Params()\narg_1: %\narg_2: %\narg_3: %\n" arg_1 arg_2 arg_3)


/*------------------------------------------------------------------------------

	DEFINE EVENTS

--------------------------------------------------------------------------------*/


/*------ BUTTON ------*/
_Button = _Controls.control #button "Button"
_Button.Event #pressed	"macros.run \"_Test\" \"_test_control_callback_macro\"" tooltip:"Test Tooltip"

-- _Button.Event #pressed "CallbackNoParam"
--_Button.Event #pressed "Callback1Param(\"Value in callback\")"
--_Button.Event #pressed "Callback1Param" params:"Value in pram string"
--_Button.Event #pressed "Callback2Params" params:#("Value A", "Value B")

/*------ CECKBUTTON ------*/

-- CheckButton	= _Controls.control #checkbutton "CheckButton"
-- CheckButton.Event #changed "Callback2Params" params:"Value in pram string"

/*------ SPINNER ------*/
-- Spinner	= _Controls.control #spinner "Spinner"
-- Spinner.Event #changed "Callback3Params()" params:"Value in pram string"



/*------ EDITTEXT ------*/
--_EditText = _Controls.control #editText "EditTextControl" across:1 -- #Mode:#getSavePath is default
--
--_EditText.Event #changed ("testCallback")
--_EditText.Event #entered ("testCallback") -- Called when the user enters text in the edit box and then presses ENTER or TAB to move the cursor out of the field.
--
--
/*------ BROWSEATH ------*/
-- _OpenFileName = _Controls.control #browsePath "OpenFileName" params:#( #mode,#getOpenFileName, #tooltip, "Test Tooltip" )

-- _OpenFileName.Event #changed ("Callback1Param")
-- _OpenFileName.Event #entered ("Callback1Param") -- Called when the user enters text in the edit box and then presses ENTER or TAB to move the cursor out of the field.

/*------ RADIOBUTTONS ------*/
--_RadioButtons = _Controls.control #radioButtons "RadioButtons"	items:#("Item 1","Item 2")

--_RadioButtons.Event #changed ("Callback1Param")

/*------ CHECKBOX ------*/
/*------ DROPDOWN ------*/
/*------ SLIDER ------*/
/*------ COLORPICKER ------*/
/*------ BITMAP ------*/
/*------ BROWSEATH ------*/
/*------ LISTBOX ------*/
/*------ MULTILISTBOX ------*/




/* DIALOG CREATE */
Dialog.create()
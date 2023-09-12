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
	format "Macro:EventFired:	% \n" EventFired.get(#val)
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


/*==============================================================================

		PRAMATERER OF EVENT DEFINING RULES

================================================================================*/

/*------------------------------------------------------------------------------
	NO ARGUMENTS PASSED TO CALLBACK
--------------------------------------------------------------------------------*/
/*
	if callback has brackets "()"
*/
CheckButton	= _Controls.control #checkbutton "No prarams"
CheckButton.Event #CHANGED "CallbackNoParam()"


/*
   if callback is macro
*/
CheckButton	= _Controls.control #checkbutton "Run Macro"
CheckButton.Event #CHANGED "macros.run \"_Test\" \"_test_control_callback_macro\""



/*------------------------------------------------------------------------------
	DEFAULT ARGUMENTS FOR CONTROL TYPE PASSED TO CALLBACK
--------------------------------------------------------------------------------*/
/*
	if callback has not brackets "()" and is single world
*/
CheckButton	= _Controls.control #checkbutton "Default prarams"
CheckButton.Event #CHANGED "Callback1Param" -- pass Callback1Param(val)


/*------------------------------------------------------------------------------
	DEFAULT AND CUSTOM ARGUMENTS PASSED TO CALLBACK
--------------------------------------------------------------------------------*/
/*
	IF params: are defined then default and
*/
CheckButton	= _Controls.control #checkbutton "Custom prarams"
CheckButton.Event #CHANGED "Callback2Params" params:"Value in arguemnt string" -- Callback2Params(val)("Value in arguemnt string")



/*------------------------------------------------------------------------------

	DEFINE EVENTS FOR EACH COTNROL TYPE

--------------------------------------------------------------------------------*/


/*------ BUTTON ------*/
--_Button = _Controls.control #button "Button"
--_Button.Event #PRESSED	"macros.run \"_Test\" \"_test_control_callback_macro\"" tooltip:"Test Tooltip"

-- _Button.Event #PRESSED "CallbackNoParam()"
--_Button.Event #PRESSED "Callback1Param(\"Value in callback\")"
--_Button.Event #PRESSED "Callback1Param" params:"Value in pram string"
--_Button.Event #PRESSED "Callback2Params" params:#("Value A", "Value B")

/*------ CECKBUTTON ------*/

-- CheckButton	= _Controls.control #checkbutton "CheckButton"
-- CheckButton.Event #CHANGED "Callback2Params" params:"Value in pram string"



/*------ SPINNER ------*/
 --Spinner	= _Controls.control #spinner "Spinner"
 --Spinner.Event #CHANGED "Callback2Params"
 --Spinner.Event #CHANGED "Callback3Params()" params:"Value in pram string"



/*------ EDITTEXT ------*/
--_EditText = _Controls.control #editText "EditTextControl" across:1 -- #Mode:#getSavePath is default

--_EditText.Event #CHANGED ("CallbackNoParam()")
--_EditText.Event #ENTERED ("Callback1Param") -- Called when the user enters text in the edit box and then presses ENTER or TAB to move the cursor out of the field.
--
--
/*------ BROWSEATH ------*/
 --_OpenFileName = _Controls.control #browsePath "OpenFileName" params:#( #mode,#getOpenFileName, #tooltip, "Test Tooltip" )

-- _OpenFileName.Event #CHANGED ("Callback1Param")
-- _OpenFileName.Event #ENTERED ("Callback1Param") -- Called when the user enters text in the edit box and then presses ENTER or TAB to move the cursor out of the field.

/*------ RADIOBUTTONS ------*/
--_RadioButtons = _Controls.control #radioButtons "RadioButtons"	items:#("Item 1","Item 2")

--_RadioButtons.Event #CHANGED ("Callback1Param")

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
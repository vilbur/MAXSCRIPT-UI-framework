clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/Dialog/Dialog.ms" ) -- "./../../../Lib/Dialog/Dialog.ms"

/* DIALOG */
Dialog 	    = Dialog_v title:"Events Test"

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
	--format "Macro:EventFired:	% \n" EventFired
	format "Macro:EventFired:	% \n" EventFired.type
)

/** 0 PRAMAS
 */
function CallbackNoParam =
(
	format "Macro:EventFired:	% \n" EventFired.type
)

/** 1 PARAMETER
 */
function CallbackParam1 val =
(
	--format "Macro:EventFired:	% \n" EventFired
	format "Macro:EventFired:	% \n" EventFired.type
)

/** 2 PARAMETERS
 */
function CallbackParams2 arg_1 arg_2 = (
	format "CallbackParams2()\narg_1: % \narg_2: % \n" arg_1 arg_2
	format "Macro:EventFired:	% \n" EventFired
)

/** 3 PARAMETERS
 */
function CallbackParams3 arg_1 arg_2 arg_3 = (
	format "CallbackParams3()\narg_1: %\narg_2: %\narg_3: %\n" arg_1 arg_2 arg_3
	format "Macro:EventFired:	% \n" EventFired
)


/*==============================================================================

		PRAMATERER OF EVENT DEFINING RULES

================================================================================*/

/*------------------------------------------------------------------------------
	NO ARGUMENTS PASSED TO CALLBACK
--------------------------------------------------------------------------------*/
/*
	if callback has brackets "()"
*/
--CheckButton	= _Controls.control #checkbutton "No prarams"
--CheckButton.Event #CHANGED "CallbackNoParam()"


/*
   if callback is macro
*/
--CheckButton	= _Controls.control #checkbutton "Run Macro"
--CheckButton.Event #CHANGED "macros.run \"_Test\" \"_test_control_callback_macro\""



/*------------------------------------------------------------------------------
	DEFAULT ARGUMENTS FOR CONTROL TYPE PASSED TO CALLBACK
--------------------------------------------------------------------------------*/
/*
	if callback has not brackets "()" and is single world
*/
--CheckButton	= _Controls.control #checkbutton "Default prarams"
--CheckButton.Event #CHANGED "CallbackParam1" -- pass CallbackParam1(val)


/*------------------------------------------------------------------------------
	DEFAULT AND CUSTOM ARGUMENTS PASSED TO CALLBACK
--------------------------------------------------------------------------------*/
/*
	IF params: are defined then default and
*/
--CheckButton	= _Controls.control #checkbutton "Custom prarams"
--CheckButton.Event #CHANGED "CallbackParams2" params:"Value in arguemnt string" -- CallbackParams2(val)("Value in arguemnt string")



/*------------------------------------------------------------------------------

	DEFINE EVENTS FOR EACH COTNROL TYPE

--------------------------------------------------------------------------------*/


/*------ BUTTON ------*/
--_Button = _Controls.control #button "Button"
--_Button.Event #PRESSED	"macros.run \"_Test\" \"_test_control_callback_macro\"" tooltip:"Test Tooltip"

-- _Button.Event #PRESSED "CallbackNoParam()"
--_Button.Event #PRESSED "CallbackParam1(\"Value in callback\")"
--_Button.Event #PRESSED "CallbackParam1" params:"Value in pram string"
--_Button.Event #PRESSED "CallbackParams2" params:#("Value A", "Value B")

/*------ CECKBUTTON ------*/

 --CheckButton	= _Controls.control #CHECKBUTTON "CheckButton"
 --CheckButton.Event #CHANGED "CallbackParams2" params:"Value in pram string"



/*------ SPINNER ------*/
 --Spinner	= _Controls.control #SPINNER "Spinner"
 --Spinner.Event #CHANGED "CallbackParams2"
 --Spinner.Event #CHANGED "CallbackParams3()" params:"Value in pram string"



/*------ EDITTEXT ------*/
--_EditText = _Controls.control #EDITTEXT "EditTextControl" across:1 -- #Mode:#getSavePath is default

--_EditText.Event #CHANGED ("CallbackNoParam()")
--_EditText.Event #ENTERED ("CallbackParam1") -- Called when the user enters text in the edit box and then presses ENTER or TAB to move the cursor out of the field.
--
--
/*------ BROWSEATH ------*/
 --_OpenFileName = _Controls.control #BROWSEPATH "OpenFileName" params:#( #mode,#getOpenFileName, #tooltip, "Test Tooltip" )

-- _OpenFileName.Event #CHANGED ("CallbackParam1")
-- _OpenFileName.Event #ENTERED ("CallbackParam1") -- Called when the user enters text in the edit box and then presses ENTER or TAB to move the cursor out of the field.

/*------ RADIOBUTTONS ------*/
_RadioButtons = _Controls.control #RADIOBUTTONS "RadioButtons"	items:#("Item 1","Item 2") params:#( #UNSELECT, true )
format "Unselectable Radio buttons last state: %\n" DIALOG_events_test.CBXBTN_checkbutton_last_state


--_RadioButtons.Event #CHANGED ("CallbackParam1")

/*------ SLIDER ------*/
--_Slider = _Controls.control #SLIDER "Slider" ticks:10 type:#integer across:1
--_Slider.Event #CHANGED ("CallbackParam1")



/*------ CHECKBOX ------*/
/*------ DROPDOWN ------*/


/*------ COLORPICKER ------*/
/*------ BITMAP ------*/
/*------ BROWSEATH ------*/
/*------ LISTBOX ------*/
/*------ MULTILISTBOX ------*/
--_multilistbox =  _Controls.control #MULTILISTBOX "Multilistbox" items:#("Item 1","Item 2", "Item 3")
--
--_multilistbox.Event #SELECTIONEND 	("CallbackNoParam()") -- called when select action ends
--_multilistbox.Event #SELECTED 	("CallbackParam1") -- called on SELECT AND DESELECT
--_multilistbox.Event #RIGHTCLICK  	("CallbackNoParam()")
--_multilistbox.Event #DOUBLECLICKED  	("CallbackParam1")





/* DIALOG CREATE */
Dialog.create()
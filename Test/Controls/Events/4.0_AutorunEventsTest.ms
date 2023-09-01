clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/Dialog/Dialog.ms" ) -- "./../../../Lib/Dialog/Dialog.ms"


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

	DEFINE DIALOG

--------------------------------------------------------------------------------*/

/* DIALOG */
Dialog 	    = Dialog_v title:"Test"

/* CONTROLS */
Controls   = Dialog.Controls()



/*------ BUTTON ------*/
_Button = Controls.control #button "Button"
 _Button.Event #pressed ("Callback1Param") params:"AUTO EXECUTED EVENT"  autorun:true


/*------ CECKBUTTON ------*/
Checkbutton = Controls.control #checkbutton "checkbutton"
 Checkbutton.Event #changed ("Callback2Params") params:"AUTO EXECUTED EVENT"autorun:true

/*------ CHECKBOX ------*/
_Checkbox = Controls.control #checkbox "Checkbox" across:1
_Checkbox.Event #changed ("Callback2Params") params:"AUTO EXECUTED EVENT"autorun:true



/* DIALOG CREATE */
Dialog.create()
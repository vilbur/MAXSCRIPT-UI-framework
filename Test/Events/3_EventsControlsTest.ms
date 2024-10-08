clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" )	-- "./../../Lib/Dialog/Dialog.ms"

/** MACRO CALLBACK
 */
macroscript	_test_control_callback_macro
category:	"_Test"
(
	format "Macro:EventFired:	% \n" EventFired
)

/** 0 PRAMAS
 */
function CallbackNoParam = (format "EventFired %:	% \n" EventFired.type EventFired )

/** 1 PARAMETER
 */
function CallbackWithValue val = (format "val: % \n" val)

/** 2 PARAMETERS
 */
function CallbackWith2Params arg_1 arg_2 = (format "arg_1: % \narg_2: % \n" arg_1 arg_2)

/** 3 PARAMETERS
 */
function CallbackWith3Params arg_1 arg_2 arg_3 = (format "arg_1: % \narg_2: % \narg_3: % \n" arg_1 arg_2 arg_3)


/** DEFINE UI
 *
 */
Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))  ini:( getSourceFileName())


_Rollout = Dialog.Roll ("Rollout A")

_SubRollout = _Rollout.Roll ("Subrollout")

-- _Controls = Dialog.Controls group:"Test"
-- _Controls = _Rollout.Controls group:"Test"
_Controls = _SubRollout.Controls()

_Controls.Default #across 1

/*------ BUTTON ------*/
--_Button_1 = _Controls.control #button "Button 1"
--_Button_1.Event #PRESSED	"macros.run \"_Test\" \"_test_control_callback_macro\""
--_Button_1.Event #RIGHTCLICK 	"print" params:"Button Ricghtclick"


/*------ CECKBUTTON ------*/
 --_CbxButton_1 = _Controls.control #checkbutton "Checkbutton"
--_CbxButton_1.Event #CHANGED "CallbackWithValue"
--	_CbxButton_1.Event #RIGHTCLICK 	"print" params:"Checkbutton Ricghtclick"


/*------ CHECKBOX ------*/
--_checkbox = _Controls.control #checkbox "Checkbox value" value:true
--_checkbox = _Controls.control #checkbox "Checkbox param" params:#(#checked, true)
--_checkbox.Event #CHANGED	"CallbackWithValue(val)"
--_checkbox.Event #RIGHTCLICK	"CallbackNoParam()"


/*------ RADIOBUTTONS ------*/
--_Controls.control #radioButtons "RadioButtons"	items:items columns:2
--_Controls.control #radioButtons "RadioButtons"	items:items params:#(#columns, 1)


/*------ DROPDOWN ------*/


--/*------ SLIDER ------ */
_Slider = _Controls.control #SLIDER "Test" ticks:9 width:200 range:[0,10,0] ticks:10 type:#integer offset:[-16, 0]
--_Slider.Event #CHANGED	"CallbackWithValue(val)"
----_Slider.Event #RIGHTCLICK	"CallbackNoParam()"
----_Slider.Event #BUTTONDOWN	"CallbackNoParam()"
----_Slider.Event #BUTTONUP	"CallbackNoParam()"
--
--/* SLIDE FIRED UP ON THEN END OF SLIDE */
_Slider.Event #SLIDE	"format @EventFired type:%	changes:% \\n@ EventFired.type EventFired.changes"
_Slider.Event #LEFTCLICK	"format @EventFired type:%	changes:% \n@ EventFired.type EventFired.changes"
--

/*------ COLORPICKER ------*/

/*------ BITMAP ------*/

/*------ EDITTEXT ------*/
--_EditText = _Controls.control #EditText "EditText 1"
--_EditText.Event #ENTERED  "CallbackWithValue(val)"
--_EditText.Event #CHANGED "CallbackWithValue(val)"


/*------ BROWSEATH ------*/
-- _BrowsePath = _Controls.control #BrowsePath "BrowsePath 1"
-- _BrowsePath.Event #ENTERED  "CallbackWithValue(val)"
-- _BrowsePath.Event #CHANGED "CallbackWithValue(val)"


/*------ LISTBOX ------*/
--_Listbox	= _Controls.control #listbox "Listbox param" items:items value:2
--

/*------ MULTILISTBOX ------*/
--_Multilistbox = _Controls.control #Multilistbox "Multilistbox 1" across:1 items:#("A", "B" )
--_Multilistbox.Event #SELECTED "CallbackWithValue(val)" -- Called when the user selects or deselects an item in the list
--_Multilistbox.Event #SELECTIONEND "CallbackNoParam()"


/*------ SPINNER ------*/
--_Spinner = _Controls.control #spinner "Spinner params"
-- _Spinner.Events.add #CHANGED "CallbackWith2Params"
--_Spinner.Events.add #CHANGED "CallbackWith3Params" params:"CUSTOM_PARAM"
--_Spinner.Events.add #CHANGED "CallbackWith3Params" params:#CUSTOM_PARAM






/** CREATE UI
 *
 */
--_RolloutCreator.createRollout _Rollout

--CreateDialog (_RolloutCreator.getDefinition _Rollout)
Dialog.create width:256  height:undefined

--Dialog.register()
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
function CallbackNoParam = (format "Macro:EventFired:	% \n" EventFired)

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

_Controls = Dialog.Controls group:"Test"

_Controls.Default #across 1

/*------ BUTTON ------*/
 --_Button_1 = _Controls.control #button "Button 1"
--	_Button_1.Event #pressed	"macros.run \"_Test\" \"_test_control_callback_macro\""
--	_Button_1.Event #rightclick 	"print" params:"Button Ricghtclick"


/*------ CECKBUTTON ------*/
 _CbxButton_1 = _Controls.control #checkbutton "Checkbutton"
	_CbxButton_1.Event #changed "CallbackWithValue"
--	_CbxButton_1.Event #rightclick 	"print" params:"Checkbutton Ricghtclick"


/*------ CHECKBOX ------*/
--_Controls.control #checkbox "Checkbox value" value:true
--_Controls.control #checkbox "Checkbox param" params:#(#checked, true)


/*------ RADIOBUTTONS ------*/
--_Controls.control #radioButtons "RadioButtons"	items:items columns:2
--_Controls.control #radioButtons "RadioButtons"	items:items params:#(#columns, 1)

/*------ DROPDOWN ------*/

/*------ SLIDER ------*/

/*------ COLORPICKER ------*/

/*------ BITMAP ------*/

/*------ EDITTEXT ------*/
 --_EditText = _Controls.control #EditText "EditText 1"
	-- _EditText.Event #entered  "CallbackWithValue(val)"
	-- _EditText.Event #changed "CallbackWithValue(val)"


/*------ BROWSEATH ------*/
-- _BrowsePath = _Controls.control #BrowsePath "BrowsePath 1"
	-- _BrowsePath.Event #entered  "CallbackWithValue(val)"
	-- _BrowsePath.Event #changed "CallbackWithValue(val)"

/*------ LISTBOX ------*/
--_Listbox	= _Controls.control #listbox "Listbox param" items:items value:2
--

/*------ MULTILISTBOX ------*/
-- _Multilistbox = _Controls.control #Multilistbox "Multilistbox 1" across:1 items:#("A", "B" )

/*------ SPINNER ------*/

--_Spinner = _Controls.control #spinner "Spinner params"
	-- _Spinner.Events.add #changed "CallbackWith2Params"
	--_Spinner.Events.add #changed "CallbackWith3Params" params:"CUSTOM_PARAM"
	--_Spinner.Events.add #changed "CallbackWith3Params" params:#CUSTOM_PARAM
















/** CREATE UI
 *
 */
--_RolloutCreator.createRollout _Rollout

--CreateDialog (_RolloutCreator.getDefinition _Rollout)
Dialog.create width:256  height:undefined

--Dialog.register()
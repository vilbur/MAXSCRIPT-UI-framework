filein( getFilenamePath(getSourceFileName()) + "/ParamsList/ParamsList.ms" )	-- "./ParamsList/ParamsList.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../../../EventsList/EventsList.ms" )	-- "./../../../../EventsList/EventsList.ms"

/** Control
 */
struct Control_v
(
	/* required */
	type,
	caption,

	/* properties */
	id,

	/* dependency */
	Events = Dictionary(),
	Params = ParamsList_v(),


	/* ControlCreator_v */
	add_locals	= #(),	-- #(#variable_name1, init_value1, #variable_name2, init_value2)	// used in ControlCreator_v._addLocalVariablesToRollout 	"../../../RolloutCreator/ControlCreator/ControlCreator.ms"
	add_text,		-- string added to rollout	// used in ControlCreator_v._addFunctionsVariablesToRollout	"../../../RolloutCreator/ControlCreator/ControlCreator.ms"

	rollout_id,

	public

	/** Focus control
	 */
	function focus =
	(
		--format "\n"; print "Control_v.focus()"
		setFocus (execute( rollout_id as string + "." + id as string ))
	),

	/** Add param
	  *
	  * @property	#name	param	name of param
	  * @property	mixin	val	value of parameter
	 */
	function param param val =
	(
		--print "Control_v.param()"
		--format "param	= % \nval	= % \n\n" param val
		Params.setVal param val
	),

	/** Add Event to control
	  *
	  *
	 */
	function Event type callback params:#() tooltip:"" =
	(
		--print "Control_v.event()"
		_Event = Event_v type:type tooltip:tooltip

		_Event.callback[#code]	= callback
		_Event.callback[#arguments]	= params


		this.Events[type] = _Event
	),

	/** Addlocal
	 */
	function addlocal key val =
	(
		--print "Control_v.addlocal()"
		append add_locals key

		append add_locals (if classof val == string then "\"" + val + "\"" else val) -- if string, then wrap to quotes
	),

	/** Add text
	 */
	function addText text =
	(
		--print "Control_v.addText()"
		add_text += text
	),


	private


	/** _set id
	 */
	function _setId =
	(
		if( id != undefined ) then
			return false

		this._setIdByCaption()

		this._setIdPrefixByControlType()
	),

	/** Set id by control caption
	 */
	function _setIdByCaption =
	(
		--print "Control_v._setIdByCaption()"
		id  = toLower caption

		id	= trimRight ( trimLeft id )

		id = substituteString id " " "_" -- replace whitespace with underscore

		id = this._repleaceCharacters "[^A-Za-z0-9_]+"	""	-- remove characters	E.G.: "Button_&_1" >>> "Button_1"

		--id = toUpper ( type as string ) + "_" + id -- add prefix by control type E.G.: "test" >>> "BUTTON_test"

		id = this._repleaceCharacters "[_]+"	"_"	-- remove underscores	E.G.: "button___1" >>> "button_1"
	),

	/** Set id prefix by control type E.G.: "BTN_foo_button"
	  *
	  * Prevent problems when ctrol has id which is reserved variable
	  * E.G.: id = #open, then is messing with roolout property rollout.open
	  *
	 */
	function _setIdPrefixByControlType =
	(
		--format "\n"; print "Control_v._setIdPrefixByControlType()"

		prefix_by_type = case type of
		(
			/* CUSTOM CONTROL TYPES*/
			#BrowsePath:	"BP"

			/* DEFAULT CONTROL TYPES*/
			#Label:	"LABEL"
			#Button:	"BTN"
			#Checkbox:	"CBX"
			#CheckButton:	"CBXBTN"
			#Spinner:	"SPIN"
			#Edittext:	"ET"
			#Listbox:	"LB"
			#MultiListBox:	"ML"
			#Dropdownlist:	"DL"
			#GroupBox:	"GB"
			#Combobox:	"CB"
			#Angle:	"ANGLE"
			#Bitmap:	"BMP"
			#ColorPicker:	"CP"
			#hyperlink:	"HL"
			#imgTag:	"IT"
			#Mapbutton:	"MBTN"
			#Materialbutton:	"MATBTN"
			#PickButton:	"PBTN"
			#ProgressBar:	"PBAR"
			#Slider:	"SLIDER"
			#Curve:	"CURVE"
			#popupMenu:	"POPMENU"
			#RadioButtons:	"RB"
			#Timer:	"TIMER"

			DEFAULT:	toUpper( type as string )
		)

		id = prefix_by_type +"_"+ id
	),


	/** _repleace string
	 */
	function _repleaceCharacters search replace =
	(
		( dotNetObject "System.Text.RegularExpressions.Regex" search ).Replace ( id ) replace  --return
	),

	/**
	 */
	on create do
	(
		this._setId()
	)
)
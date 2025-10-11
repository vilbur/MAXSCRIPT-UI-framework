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
	Params = Dictionary(),

	params_str = "", -- sore parameters forRolloutCreator

	/* ControlCreator_v */
	--add_locals, 	= #(),	-- #(#variable_name1, init_value1, #variable_name2, init_value2)	// used in ControlCreator_v._addLocalVariablesToRollout 	"../../../RolloutCreator/ControlCreator/ControlCreator.ms"
	add_locals, -- Dictionary -- KEY:#variable_name VALUE:variable_value

	add_text,		-- string added to rollout	// used in ControlCreator_v._addFunctionsVariablesToRollout	"../../../RolloutCreator/ControlCreator/ControlCreator.ms"

	rollout_id,
	
	
	--is_in_groupbox = false, -- USED: GroupBoxes_v.addControlToGroupbox() IN FILE: "./../GroupBoxes/GroupBoxes.ms"
	
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
		Params[param] = val
	),

	/** Has param
	 */
	function hasParam param =
	(
		Params[param] != undefined --return
	),
	
	/** Add Event to control
	 */
	function Event type callback params:"" tooltip:"" autorun:false =
	(
		--print "Control_v.event()"
		--format "autorun: %\n" autorun
		--this.Events.add type callback params:params tooltip:tooltip
		
		--_Event = Event_v type:type tooltip:tooltip autorun:autorun
		_Event = Event_v type:type tooltip:tooltip callback:callback arguments:params autorun:autorun
		
		--_Event.callback	= callback
		--_Event.arguments	= params --- NOTE: "arguments" are "params" FOR FRONT END USER
		
		this.Events[type] = _Event
	),

	/** Addlocal
	 */
	function addlocal key val =
	(
		--print "Control_v.addlocal()"
		--format "key: %\n" key
		--format "val: %\n" val
		if add_locals == undefined then
			add_locals	=  Dictionary #NAME

		add_locals[key as name ] = (if classof val == string then "\"" + val + "\"" else val) -- if string, then wrap to quotes
	),

	/** Add text
	 */
	function addText text =
	(
		--print "Control_v.addText()"
		add_text += text
	),

	/** Get full id
	 */
	function getFullId =
	(
		--format "\n"; print "Control_v.getFullId()"
		rollout_id as string +"."+ id as string --return
	),



	/* MEerge dictionaries
	*/ 
	function mergeParams dict_a dict_b =
	(
		for key in dict_a.keys do
			dict_a[key] = dict_b[key]

		dict_a-- return
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
		
		id = id as name
	),

	/** Set id by control caption
	 */
	function _setIdByCaption =
	(
		--print "Control_v._setIdByCaption()"
		--format "id: %\n" id
		--format "caption: %\n" caption
		id  = toLower (caption as string )

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
			#CheckButton:	"CBTN"
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
		--print "Control_v.create()"
		this._setId()
	)
)
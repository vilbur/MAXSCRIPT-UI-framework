filein( getFilenamePath(getSourceFileName()) + "/EventFired/EventFired.ms" )

global STARTUP_EVENTS = #() -- run callbacks of controls like checkbox, checkbutton on UI start

/** ControlEvents_v 
 *
 * DEFAULT CALLBACKS:
 *		1) Fire global variable EventFired = EventFired_v
 * 		2) Save value of control to ini file if is defined
 * 		
 * 		
 * 		
 *	!!!!!!!!! NOTES FOR ADDING NEW TYPE OF CONTROL !!!
 * 		
 *		Edit arrays: control_types, event_types
 */
struct ControlEvents_v 
(
	/* properties */
	_Control,
	
	ini_path,
	dynamic_event_types = #( #changed, #selected ), -- this events fires default save to ini callback

	/* dependency */
	EventsCombiner	= EventsCombiner_v(),

	/* Keys for event_types array
	 *
	 * NOTE: COMMENTED types are not supported yet
	 *
	*/ 
	control_types = #(
		#Label,
		#Button,
		#Checkbox,
		#Checkbutton,
		#Spinner,
		#Edittext,
		#Listbox,
		#multilistbox,
		#Dropdownlist,
		--#Combobox,
		--#GroupBox,
		--#Angle,
		--#Bitmap,
		--#Colorpicker,
		--#hyperlink,
		--#imgTag,
		--#Mapbutton,
		--#Materialbutton,
		--#Pickbutton,
		--#ProgressBar,
		--#Slider,
		--#Curve,-- DOES NOT WORK YET
		--#popupMenu,-- DOES NOT WORK YET
		--#Radiobuttons,-- DOES NOT WORK YET
		#Timer
	),
	
	/* If event is array then it has "val" param
	*
	* Other items in array defines additional params for event.
	*/ 
	event_types = #(
		#( ),				-- #label	
		#( #pressed,	#rightclick ),			-- #button	
		#( #(#changed,  "val"),	#rightclick ),			-- #checkbox	https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_D23A42EA_7B69_4DEF_9D6E_C6C85F884268_htm
		#( #(#changed,  "val"),	#rightclick ),			-- #checkbutton	
		#( #(#changed,  "val inSpin"),	#(#entered, "inSpin inCancel"),	#(#buttonup, "inCancel"),	#buttondown ),	-- #spinner	
		#( #(#changed,  "val"),	#(#entered, "val") ),			-- #edittext	https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_FC73C160_735C_4F65_A71D_722D63BBB591_htm
		#( #(#selected, "val"),	#(#doubleClicked, "val"),	#(#rightClick, "val")),		-- #listbox	https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_7C37748B_C682_4834_B5A6_74185C8C661A_htm
		#( #(#selected, "val"),	#(#doubleClicked, "val"),	#rightClick,	#selectionEnd ),	-- #multilistbox	
		#( #(#selected, "val"),	#rightClick ),			-- #dropdownlist	
		
		/* Custom compounded controls */
		--#( #(#changed,  "val"),	#(#entered, "val") )	-- #browsePath
		#( #tick )
	),
	
	events_of_control,	-- get events from event_types array
	params_of_control,	-- get params from event_types array
	
	/** Add handlers
	  * http://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_5FC5036F_E2D7_46C9_9AFA_7B3550B9F254_htm
	 */
	function getEvents _Control rollout_id =
	(
		if( ini_path == undefined ) then
			return _Control.Events.list
		--print ( "ControlEvent_v.getEvents()" )
		--format "_Control	= % \n" _Control
		this._Control = _Control
		
		events_of_control = this._getEventsOfControl _Control.type
		params_of_control = this._getParamsOfControl _Control.type
			
		this._addSaveToIniEvents(rollout_id) --return
	),

	/**  get events for control type from event_types array
	 */
	function _getEventsOfControl control_type =
	(
		--print "ControlEvents_v._getEventsOfControl()"
		for event_type in event_types[findItem control_types control_type] collect
			if( classOf event_type == Array ) then event_type[1] else event_type
		
	),
	/** get params for control type from event_types array
	 */
	function _getParamsOfControl control_type =
	(
		for event_type in event_types[findItem control_types control_type] collect
			if( classOf event_type == Array ) then event_type[2] else undefined
	),
	
	
	/** _add save to ini events
	 */
	function _addSaveToIniEvents rollout_id =
	(
		Events_list	= #()
		--print "ControlEvents_v._addSaveToIniEvents()"
		
		for event_type in events_of_control where findItem dynamic_event_types event_type > 0 do
		(
			Event = this._getEvent(event_type)
			
			Event.code	= "( setINISetting \""+ini_path+"\" \""+rollout_id+"\" \""+_Control.id+"\" (val as string) );" + Event.code

			Event.params	= params_of_control[findItem events_of_control event_type]

			append Events_list Event
		)

		Events_list --return
	),
	
	/** Get event from control, if dos not exists then create new
	 */
	function _getEvent event_type =
	(
		--print "ControlEvents_v._getEvent()"
		if( (Event_existing = this._getControlEvent(event_type)) != undefined ) then Event_existing else (Event_v type:event_type)
	),
	
	/** _get control event
	 */
	function _getControlEvent event_type =
	(
		--print "ControlEvents_v._getControlEvent()"
		(for Event in _Control.Events.list where Event.type == event_type collect Event)[1] --return 
	),
	
	--/** Set save to ini callback
	--  *
	--  * If control has callback which is changing value of control
	-- */
	--function setSaveToIniCallback &Event =
	--(
	--	--format "ControlEvents.setSaveToIniCallback() % %\n" Parent_Control.id.id Parent_Control.type
	--	--if( Parent_Control.ControlBox.Parent_roll._Ini.isDefined() ) then
	--
	--	rollout_id = "ROLLOUT_test"
	--	
	--	
	--	Event
	--),
	--
	--/** Get saveini event type
	-- */
	--function _getSaveiniEventType =
	--(
	--	for event_type in event_types where findItem dynamic_event_types event_type > 0 collect event_type 
	--),
	
	--/** Add function brackets E.g.: "fooCallback" return "fooCallback()|fooCallback(val)"
	-- */
	--function _addFunctionBrackets &callback params =
	--(
	--	--print "ControlEvents_v._addFunctionBrackets()"
	--	--format "params	= % \n" params
	--	if( params == "" ) then 
	--		params = "()"
	--	
	--	if not( matchPattern callback pattern:"macros.run*" ) then 
	--		if not( matchPattern callback pattern:("*(*)") ) then
	--			callback += " " + params
	--			--callback += "("+params+")"
	--),
	--
	--/** Get parameters of callback defined in event_types
	-- */
	--function _setCallbackParamters &params type =
	--(
	--	print "ControlEvents._setCallbackParamters()"
	--	--format "params	= % \n" params
	--	
	--	if( ( event_types = this._getEventParameters type ) != undefined and params == "" ) then
	--		params = event_types
	--	
	--	params --return
	--),
	--
	--/** If event in Events.event_types is Array, then it has parameter
	-- */
	--function _getEventParameters type =
	--(
	--	--format "ControlEvents_v._getEventParameters	= % \n" type
	--
	--	param = ""
	--	
	--	for event_param in Events.event_types where event_param[1] == type do
	--		param = event_param[2]
	--		
	--	param --return
	--),

	
	/** If checkbox has value true, then fire up checkbox`s callback when UI starts
	 */
	function _addToStartupEvents type callback =
	(
		if( Parent_Control._Parameters.getVal #checked == true ) then
		(
			EventFired_true = this.Events.setEventFired type Parent_Control.id.full val:true -- simulate event fired

			appendIfUnique STARTUP_EVENTS (EventFired_true+callback)
		)
	),
	
	private

	--/** _is event exists
	-- */
	--function _isEventExists type =
	--(
	--	findItem Events.event_types type > 0 --return
	--),
	--
	/** Exception
	 */
	function _exception type =
	(
		messageBox ("WARNING\n\nUnknown Event Type: #"+ type + "\n\nControl: "+ (Parent_Control.Id.get() ))
	),

	
	on create do
	(
	)
)
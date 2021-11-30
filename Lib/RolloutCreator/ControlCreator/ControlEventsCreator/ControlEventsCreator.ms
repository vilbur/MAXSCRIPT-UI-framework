filein( getFilenamePath(getSourceFileName()) + "/EventFiredCreator/EventFiredCreator.ms" )

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
struct ControlEventsCreator_v 
(
	/* properties */
	_Control,
	
	ini_path,
	dynamic_event_types = #( #changed, #selected ), -- this events fires default save to ini callback

	/* dependency */
	--EventsCombiner	= EventsCombiner_v(),

	control_types = include "Library/MAXSCRIPT-UI-framework/Lib/Dialog/Rollout/Controls/control_types.ms",
	
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
		#( #tick )
		--#( #(#changed,  "val"),	#(#entered, "val") )	-- #browsePath
	),
	
	events_of_control,	-- get events from event_types array
	params_of_events,	-- get params from event_types array
	
	/** Add handlers
	  * http://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_5FC5036F_E2D7_46C9_9AFA_7B3550B9F254_htm
	 */
	function getEvents _Control rollout_id =
	(
		this._Control	= _Control
		events_of_control	= this._getEventsOfControl (_Control.type)
		params_of_events	= this._getParamsOfEvents  (_Control.type)

		/* PARAMETER */ 
		this._setCallbackParamters()
		
		
		/* EVENT FIRED */ 
		this._addEventFired()
		
		
		/* DEFAULT EVENTS */ 
		if( ini_path != undefined ) then
			_Control.Events.list = this._addDefaultEvents(rollout_id) 
		
		
		 _Control.Events.list --return
	),

	/**  get events for control type from event_types array
	  *
	  * @return	array of event types for control E.G.: return #( #pressed,	#rightclick) if control_type == #button 
	 */
	function _getEventsOfControl control_type =
	(
		--print "ControlEvents_v._getEventsOfControl()"
		for event_type in event_types[findItem control_types control_type] collect
			if( classOf event_type == Array ) then event_type[1] else event_type
		
	),
	/** get params for control type from event_types array
	 */
	function _getParamsOfEvents control_type =
	(
		for event_type in event_types[findItem control_types control_type] collect
			if( classOf event_type == Array ) then event_type[2] else undefined
	),
	
	
	/** _add save to ini events
	 */
	function _addDefaultEvents rollout_id =
	(
		--print "ControlEvents_v._addDefaultEvents()"
		events_list	= #()
		
		for event_type in events_of_control where findItem dynamic_event_types event_type > 0 do
		(
			Event = this._getEvent(event_type)
			
			Event.code	= "( setINISetting \""+ini_path+"\" \""+rollout_id+"\" \""+_Control.id+"\" (val as string) );" + Event.code

			Event.params	= params_of_events[findItem events_of_control event_type]

			append events_list Event
		)

		events_list --return
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

	/** Get parameters of callback defined in event_types
	 */
	function _setCallbackParamters =
	(
		--print "ControlEvents._setCallbackParamters()"
		for i = 1 to events_of_control.count where params_of_events[i] != undefined  do
		(
			Event = this._getEvent(events_of_control[i])
			
			Event.params = params_of_events[i]
			
			if not( matchPattern Event.code pattern:("* "+Event.params) ) then -- add prameters behind callback E.G.: "callbackFn" >>>  "callbackFn inSpin inCancel"
				Event.code  += " "+ Event.params
		)
	),
	
	/** _add event fired
	 */
	function _addEventFired =
	(
		--print "ControlEventsCreator_v._addEventFired()"
		EventFiredCreator = EventFiredCreator_v control_id:_Control.id
		
		for i = 1 to events_of_control.count  do
		(
			Event = this._getEvent(events_of_control[i])

			_EventFired    = EventFiredCreator.getEventFired(events_of_control[i])(Event.params)
			
			Event.code = _EventFired+ ";"+ Event.code
		)
		
	),
	
	
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
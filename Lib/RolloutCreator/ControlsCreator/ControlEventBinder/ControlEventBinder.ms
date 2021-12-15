filein( getFilenamePath(getSourceFileName()) + "/EventFiredCreator/EventFiredCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/EventClasses/DefaultControlEvents/DefaultControlEvents.ms" )
filein( getFilenamePath(getSourceFileName()) + "/EventClasses/SaveIniControlEvents/SaveIniControlEvents.ms" )
filein( getFilenamePath(getSourceFileName()) + "/EventTypes/EventTypes.ms" )


global STARTUP_EVENTS = #() -- run callbacks of controls like checkbox, checkbutton on UI start

/** ControlEventBinder_v 
 *
 * DEFAULT CALLBACKS:
 *		1) Fire global variable EventFired = EventFired_v
 * 		2) Save value of control to ini file if is defined
 * 		
 * 		
 * 		
 *							   !!!!!!!!! NOTES FOR ADDING NEW TYPE OF CONTROL !!!!!!!!!
 * 		 
 *								  Edit arrays in this file: control_types, event_types
 * 		
 * 		
 */
struct ControlEventBinder_v 
(
	/* construct */ 
	ini_path, -- set in RolloutCreator_v._setIniToCreators()

	
	/* properties */
	_Rollout,
	_Control,


	/* dependency */
	EventsCombiner	= EventsCombiner_v(),
	DefaultControlEvents	= DefaultControlEvents_v(),
	SaveIniControlEvents	= SaveIniControlEvents_v ini_path:ini_path rollout_id:_Rollout.id, 

	control_types = include "Library/MAXSCRIPT-UI-framework/Lib/Dialog/Rollout/Controls/control_types.ms", 

	event_types = (EventTypes_v()).event_types,
	
	event_types_of_control,	-- get events from event_types array
	params_of_events,	-- get params from event_types array

	/** Combine events and add handlers
	 */
	function combineEventsAndAddHandlers _Control =
	(
		format "\n"; print "ControlEventBinder_v.combineEventsAndAddHandlers()"
		format "_Control	= % \n" _Control
		this._Control = _Control

		
		
		event_types_of_control	= this._getEventTypesOfControl (_Control.type)
		params_of_events	= this._getParamsOfEvents  (_Control.type)
		format "event_types_of_control = % \n" event_types_of_control
		format "params_of_events	      = % \n" params_of_events


		this._setCustomEvents()
		this._setDefaultEvents()
		this._setSaveIniEvents()
		
		this._combineAllEventTypes()
		
		this._setCallbackParamters()
		
		/* PARAMETER */ 
		this._addHandlers()
	),

	/** _combine all event types
	 */
	function _combineAllEventTypes =
	(
		--format "\n"; print "ControlEventBinder_v._combineAllEventTypes()"
		this._Control.Events.list = for event_type in event_types_of_control where (Event = EventsCombiner.combine (event_type)) != undefined collect Event
	),

	/** _bind events
	 */
	function _addHandlers =
	(
		print "ControlEventBinder_v._addHandlers()"
		for Event in _Control.Events.list do 
			this._addHandler(Event)
	),

	/** Bind events
	 */
	function _addHandler Event =
	(
		print "ControlEventBinder_v._addHandler()"
		if( Event.code == "" ) then
			return false
		format "EVENT = % \n" Event
		_Rollout._RolloutCreator.addHandler _Control.id Event.type codeStr:(Event.code) paramStr:Event.params filter:on
	),

	/** _combine events
	 */
	function _setCustomEvents =
	(
		print "ControlEventBinder_v._setCustomEvents()"
		EventsCombiner.setEventsClass #CUSTOM _Control.Events.list
	),

	/** _combine events
	 */
	function _setDefaultEvents =
	(
		EventsCombiner.setEventsClass #DEFAULTS ( DefaultControlEvents.getEvents(_Control.type) ) 
	),

	/** _combine events
	 */
	function _setSaveIniEvents =
	(
		EventsCombiner.setEventsClass #SAVEINI ( SaveIniControlEvents.getEvents(_Control)(event_types_of_control) )
	),

	/**  get events for control type from event_types array
	  *
	  * @return	array of event types for control E.G.: return #( #pressed,	#rightclick) if control_type == #button 
	 */
	function _getEventTypesOfControl control_type =
	(
		--print "ControlEventBinder_v._getEventTypesOfControl()"
		for event_type in event_types[findItem control_types control_type] collect
			if( classOf event_type == Array ) then event_type[1] else event_type

	),
	
	/** get params for control type from event_types array
	 */
	function _getParamsOfEvents control_type =
	(
		--format "\n"; print "ControlEventBinder_v._getParamsOfEvents()"
		for event_type in event_types[findItem control_types control_type] collect
			if( classOf event_type == Array ) then event_type[2] else undefined
	),


	/** Get parameters of callback defined in event_types
	 */
	function _setCallbackParamters =
	(
		--print "ControlEvents._setCallbackParamters()"
		--format "event_types_of_control	= % \n" event_types_of_control
		for i = 1 to event_types_of_control.count where params_of_events[i] != undefined  do
		(
			Event = this._getEvent(event_types_of_control[i])

			Event.params = params_of_events[i]

			if not( matchPattern Event.code pattern:("* "+Event.params) ) then -- add prameters behind callback E.G.: "callbackFn" >>>  "callbackFn inSpin inCancel"
				Event.code  += " "+ Event.params
		)
	),


	/*------------------------------------------------------------------------------
		******************************** OLD ********************************
	--------------------------------------------------------------------------------*/

	/** Add handlers
	  * http://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_5FC5036F_E2D7_46C9_9AFA_7B3550B9F254_htm
	 */
	function getEvents _Control rollout_id =
	(
		this._Control	= _Control
		event_types_of_control	= this._getEventTypesOfControl (_Control.type)
		params_of_events	= this._getParamsOfEvents  (_Control.type)
		format "event_types_of_control	= % \n" event_types_of_control
		format "params_of_events	= % \n" params_of_events

		/* PARAMETER */ 
		this._setCallbackParamters()

		/* EVENT FIRED */ 
		this._addEventFired()


		 _Control.Events.list --return
	),

	/** Get event from control, if dos not exists then create new
	 */
	function _getEvent event_type =
	(
		--print "ControlEventBinder_v._getEvent()"
		if( (Event_existing = this._getControlEvent(event_type)) != undefined ) then Event_existing else (Event_v type:event_type)
	),

	/** _get control event
	 */
	function _getControlEvent event_type =
	(
		--print "ControlEventBinder_v._getControlEvent()"
		(for Event in _Control.Events.list where Event.type == event_type collect Event)[1] --return 
	),


	/**_type _add event fired
	 */
	function _addEventFired =
	(
		--print "ControlEventBinder_v._addEventFired()"
		EventFiredCreator = EventFiredCreator_v control_id:_Control.id

		for i = 1 to event_types_of_control.count  do
		(
			Event = this._getEvent(event_types_of_control[i])

			_EventFired    = EventFiredCreator.getEventFired(event_types_of_control[i])(Event.params)
			--format "_EventFired	= % \n" _EventFired
			Event.code = _EventFired+ ";"+ Event.code
			--Event.code =  Event.code + ";"+ _EventFired
		)

	),

	--/** Add function brackets E.g.: "fooCallback" return "fooCallback()|fooCallback(val)"
	-- */
	--function _addFunctionBrackets &callback params =
	--(
	--	--print "ControlEventBinder_v._addFunctionBrackets()"
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

	/** Exception
	 */
	function _exception type =
	(
		messageBox ("WARNING\n\nUnknown Event Type: #"+ type + "\n\nControl: "+ (Parent_Control.Id.get() ))
	),

	/*------------------------------------------------------------------------------
		TEST
	--------------------------------------------------------------------------------*/

	public

	/** Alias for private method for testing
	 */
	function getEventTypesOfControlTest control_type =
	(
		this._getEventTypesOfControl (control_type)
	),

	/*------------------------------------------------------------------------------
		ON CREATE
	--------------------------------------------------------------------------------*/

	on create do
	(
		print("ControlEventBinder_v.onCreate()")
		format "_ROLLOUT	= % \n" _Rollout	)
)
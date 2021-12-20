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

	__construct = #( #_Rollout ),

	/* construct */ 
	_Rollout,

	/* construct option */ 
	ini_path, -- set in RolloutCreator_v._setIniToCreators()

	/* properties */
	_Control,

	/* dependency */
	EventTypes	= EventTypes_v(),
	EventsCombiner	= EventsCombiner_v(),
	DefaultControlEvents	= DefaultControlEvents_v(),
	SaveIniControlEvents	= SaveIniControlEvents_v ini_path:ini_path rollout_id:_Rollout.id,

	control_types	= (ControlTypes_v()).getAllTypes(),

	event_types,	-- get events from event_types array
	events_params,	-- get params from event_types array

	/** Combine events and add handlers
	 */
	function combineEvents &_Control =
	(
		--format "\n"; print ("ControlEventBinder_v.combineEvents() "+ _Control.id)
		this._Control = _Control

		event_types	= EventTypes.getEventTypesOfControl	(this._Control.type)
		events_params	= EventTypes.getParamsOfEvents	(this._Control.type)
		
		this._validateEvents()
		
		this._setCallbackParamtersToCustomEvent()
		
		this._setDefaultEvents()
		this._setCustomEvents()
		this._setSaveIniEvents()

		this._combineEventTypes()
		
		this._setEventsParamters()
		
		this._addEventFired()

		this._Control --return 
	),

	
	
	/** Combine events and add handlers
	 */
	function addHandlers &_Control =
	(
		--format "\n"; print ("ControlEventBinder_v.addHandlers() "+ _Control.id)
		/* PARAMETER */ 
		for Event in _Control.Events.list do 
			this._addHandler(_Control)(Event)
			
		_Control --return
	),
	
	private 
	
	/** Bind events
	 */
	function _addHandler _Control Event =
	(
		--print "ControlEventBinder_v._addHandler()"
		if( Event.code == "" ) then
			return false
		format "\nEVENT = % \n" Event
		_Rollout._RolloutCreator.addHandler _Control.id Event.type codeStr:( "("+Event.code+")" ) paramStr:Event.params filter:on
	),
	
	/** _combine all event types
	 */
	function _combineEventTypes =
	(
		--format "\n"; print "ControlEventBinder_v._combineEventTypes()"
		this._Control.Events.list = for event_type in event_types where (Event = EventsCombiner.combine (event_type)) != undefined collect Event
	),

	/** _combine events
	 */
	function _setDefaultEvents =
	(
		EventsCombiner.setEventsClass #DEFAULTS ( DefaultControlEvents.getEvents(this._Control) ) 
	),

	/** _combine events
	 */
	function _setSaveIniEvents =
	(
		--format "***** TEST = % \n"( SaveIniControlEvents.getEvents(this._Control)(event_types))
		if( ini_path != undefined ) then  
			EventsCombiner.setEventsClass #SAVEINI ( SaveIniControlEvents.getEvents(this._Control)(event_types) )
	),

	/** _combine events
	 */
	function _setCustomEvents =
	(
		--print "ControlEventBinder_v._setCustomEvents()"
		
		EventsCombiner.setEventsClass #CUSTOM this._Control.Events.list
	),
	
	/** Set parameters of events
	 */
	function _setEventsParamters =
	(
		--print "ControlEvents._setEventsParamters()"
		for Event in this._Control.Events.list where (params = this._getParamsForEventType(Event.type) ) != undefined do
			Event.params = params
	),
	
	/** Get parameters of callback defined in event_types
	  
	  
		TODO: REFRACT THIS METHOD
	  
	 */
	function _setCallbackParamtersToCustomEvent =
	(
		--print "ControlEvents._setCallbackParamtersToCustomEvent()"
		for Event in this._Control.Events.list do
			if (params = this._getParamsForEventType(Event.type) ) != undefined then 
			(
				if not( space_in_string = matchPattern Event.code pattern:("* *") ) then
					for param in params_split = filterString Event.params where ( param_is_not_added = matchPattern Event.code pattern:("*"+param+"*")) == false do 
						Event.code  += " "+ param -- add parameters after callback E.G.: "callbackFn" >>>  "callbackFn inSpin inCancel

			)
			else if not( matchPattern Event.code pattern:"*()" or matchPattern Event.code pattern:"*macros.run*"  ) then -- add parameters after callback E.G.: "callbackFn" >>>  "callbackFn inSpin inCancel"
				Event.code += "()"                                  -- add brackets after callback E.G.: "callbackFn" >>>  "callbackFn()"
	),
	
	/** Get params for event type
	 */
	function _getParamsForEventType event_type =
	(
		--format "\n"; print "ControlEventBinder_v.getParamsForEventType()"
		 events_params[findItem event_types event_type]
	),
	/**_type _add event fired
	 */
	function _addEventFired =
	(
		--print "ControlEventBinder_v._addEventFired()"
		EventFiredCreator = EventFiredCreator_v _Control:_Control
		
		for Event in this._Control.Events.list do
			Event.code = (EventFiredCreator.getEventFired(Event)) + "\n"+ Event.code

	),

	/** Get event from control, if dos not exists then create new
	 */
	function _getEvent event_type =
	(
		--print ("ControlEventBinder_v._getEvent() " +event_type)
		if( (Event_existing = this._getControlEvent(event_type)) != undefined ) then Event_existing else (Event_v type:event_type)
	),

	/** _get control event
	 */
	function _getControlEvent event_type =
	(
		--print "ControlEventBinder_v._getControlEvent()"
		(for Event in this._Control.Events.list where Event.type == event_type collect Event)[1] --return 
	),

	/** _validate events
	 */
	function _validateEvents =
	(
		--print "ControlEventBinder_v._validateEvents()"
		for Event in this._Control.Events.list where findItem event_types Event.type == 0 do
			throw  ("WARNING\n\nUnknown Event Type: #"+ Event.type + "\n\nControl: "+ (this._Control.id))
		
	),
	

	
	/*------------------------------------------------------------------------------
		******************************** OLD ********************************
	--------------------------------------------------------------------------------*/

	--
	--/** If checkbox has value true, then fire up checkbox`s callback when UI starts
	-- */
	--function _addToStartupEvents type callback =
	--(
	--	if( Parent_Control._Parameters.getVal #checked == true ) then
	--	(
	--		EventFired_true = this.Events.setEventFired type Parent_Control.id.full val:true -- simulate event fired
	--
	--		appendIfUnique STARTUP_EVENTS (EventFired_true+callback)
	--	)
	--),
	--


	/*------------------------------------------------------------------------------
		TEST
	--------------------------------------------------------------------------------*/

	public

	/** Alias for private method for testing
	 */
	function getEventTypesOfControlTest control_type =
	(
		EventTypes.getEventTypesOfControl (control_type)
	),

	/*------------------------------------------------------------------------------
		ON CREATE
	--------------------------------------------------------------------------------*/

	on create do
	(
		--print("ControlEventBinder_v.onCreate()")
		--format "_ROLLOUT	= % \n" _Rollout
		ConstructPropeties test:this
	)

)
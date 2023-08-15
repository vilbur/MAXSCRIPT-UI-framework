filein( getFilenamePath(getSourceFileName()) + "/EventFiredCreator/EventFiredCreator.ms" )	-- "./EventFiredCreator/EventFiredCreator.ms"
filein( getFilenamePath(getSourceFileName()) + "/DefaultControlEvents/DefaultControlEvents.ms" )	-- "./DefaultControlEvents/DefaultControlEvents.ms"
filein( getFilenamePath(getSourceFileName()) + "/EventTypes/EventTypes.ms" )	-- "./EventTypes/EventTypes.ms"


global STARTUP_EVENTS = #() -- run callbacks of controls like checkbox, checkbutton on UI start

/** ControlEventBinder_v
 *
 * FUNCTIONS OF DEFAULT CALLBACKS:
 *		1) Each event fires global variable EventFired
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

	control_types	= (ControlTypes_v()).getAllTypes(),

	event_types,	-- E.G.: #(#changed, 	#rightClick)	keys
	events_params,	-- E.G.: #("val",	undefined)	values -- default params for defauls events E.G.: on checkbox changed val do ...

	/** Combine events and add handlers
	 */
	function combineEvents &_Control =
	(
		--format "\n"; print ("ControlEventBinder_v.combineEvents() "+ _Control.id)
		this._Control = _Control

		event_types	= EventTypes.getEventTypesOfControl	(this._Control.type)
		events_params	= EventTypes.getParamsOfEvents	(this._Control.type)

		this._normalizeNamesOfEventTypes()

		this._validateEvents()

		this._addParametersToCallback()

		this._setDefaultEvents()
		this._setCustomEvents()
		----------this._setSaveIniEvents() -- DEPRECATED and UNUSED, but not deleted yet in case for later use

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
		for Event in _Control.Events.list do
			this._addHandler(_Control)(Event)

		_Control --return
	),

	--private

	/** Bind events
	 */
	function _addHandler _Control Event =
	(
		--print "ControlEventBinder_v._addHandler()"
		if( Event.code == "" ) then
			return false
		--format "\nEVENT = % \n" Event
		--format "\nEVENT.type = % \n" Event.type
		--format "\nEVENT.code = % \n" Event.code
		_Rollout.RCI.addHandler _Control.id Event.type codeStr:( "("+Event.code+")" ) paramStr:Event.params filter:on
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
		EventsCombiner.events_classes[#DEFAULTS] = ( DefaultControlEvents.getEvents(this._Control) )
	),

	/** _combine events
	 */
	function _setCustomEvents =
	(
		--print "ControlEventBinder_v._setCustomEvents()"
		EventsCombiner.events_classes[#CUSTOM] = this._Control.Events.list
	),

	/** Set parameters of events
	  *
	  * E.G.: Event.params = "Val"
	 */
	function _setEventsParamters =
	(
		--print "ControlEvents._setEventsParamters()"
		for Event in this._Control.Events.list where (params = this._paramsOfEvent(Event.type) ) != undefined do
			Event.params = params
	),

	/** Add paramters to callback if not set all ready
	  *
	  * E.G.:	input:	Event.code = "callBackFn"
	  *	output:	Event.code = "callBackFn()" or "callBackFn val"
	 */
	function _addParametersToCallback =
	(
		--print "ControlEvents._addParametersToCallback()"
		--for Event in this._Control.Events.list where not (matchPattern Event.code pattern:"*macros.run*" or matchPattern Event.code pattern:"*()" ) do
		/** Get event params
		  *
		  */
		function getEventParams params_event =
		(
			--format "\n"; print "ControlEventBinder_v.getEventParams()"
			if params_event != "" then
			(
				if classOf params_event != Array then
					params_event = #(params_event)

				for param in params_event collect if classOf param == string then "\"" +param + "\"" else param
				--format "params_event:	% \n" params_event
				--params_event --return
			)
		)


		for Event in this._Control.Events.list where not matchPattern Event.code pattern:"* *" do
		(
			params_default = this._paramsOfEvent(Event.type)
			params_event    = getEventParams(Event.params)

			params = case of
			(
				(params_default != undefined):	filterString params_default " "
				(params_event   != undefined ):	params_event
			)

			if params != undefined then
				for param in params where ( PARAM_IS_NOT_ADDED = matchPattern Event.code pattern:("*"+param as string +"*")) == false do
					Event.code  += " ("+ param as string + ")" -- add parameters after callback E.G.: "callbackFn" >>>  "callbackFn inSpin inCancel


			else if not( matchPattern Event.code pattern:"*(*)" ) and not (  matchPattern Event.code pattern:"*\"*\"" ) then -- if not match E.G.: "print (\"XXX\")" OR "print \"XXX\""
				Event.code += "()" -- add brackets after callback E.G.: "callbackFn" >>>  "callbackFn()"
		)
	),

	/** Get params for given event type
	  *
	  * @return	string
	 */
	function _paramsOfEvent event_type =
	(
		--format "\n"; print "ControlEventBinder_v.getParamsForEventType()"
		if ( index = findItem event_types event_type ) > 0 then
			events_params[index]
	),

	/**_type _add event fired
	 */
	function _addEventFired =
	(
		--print "ControlEventBinder_v._addEventFired()"
		EventFiredCreator = EventFiredCreator_v _RolloutClass:(_Rollout.getFullId()) _RolloutControl:( (_Rollout.getFullId()) +"."+ _Control.id as string )

		for Event in this._Control.Events.list do
			Event.code = (EventFiredCreator.getEventFired(Event)) + "\n"+ Event.code
			--(EventFiredCreator.getEventFired(Event)) --DEVELOP
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


	/** _normalize names of event types
	 */
	function _normalizeNamesOfEventTypes =
	(
		--format "\n"; print "ControlEventBinder_v._normalizeNamesOfEventTypes()"
		for Event in this._Control.Events.list where classOf Event.type == String do
			Event.type = Event.type as name
	),

	/** _validate events
	 */
	function _validateEvents =
	(
		--print "ControlEventBinder_v._validateEvents()"
		for Event in this._Control.Events.list where findItem event_types Event.type == 0 do
		(
			print  ("------------------- WARNING ----------------------")
			print  ("UNKNOWN TYPE OF EVENT FOR CONTROL.")
			format "\n\n"
			format "_Rollout: % \n" _Rollout.title
			format "Control:  #% \n" 	this._Control.id
			format "Title:    \"%\" \n"	this._Control.caption
			format "Type:     %\n" 	this._Control.type
			format "Event:    % \n"	Event.type
			format "\n"
			format "AVAILABLE EVENTS FOR THIS TYPE:    % \n" this.event_types
			format "\n"
			print  ("------------------------------------------------")

		)
			--print  ("\n\n-----------------------------------------\n\n\nERROR - You try add unknown type of event for control (vilbur) \n\n\nControl.id: #"+ (this._Control.id) + "\nEvent.type: #"+ Event.type as string + "\n\n\n-----------------------------------------\n\n\n")
	),

	/*------------------------------------------------------------------------------
		ON CREATE
	--------------------------------------------------------------------------------*/

	on create do
	(
		--print("ControlEventBinder_v.onCreate()")
		--format "_ROLLOUT	= % \n" _Rollout
		--ConstructPropeties test:this
	)

)
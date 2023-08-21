filein( getFilenamePath(getSourceFileName()) + "/EventFiredCreator/EventFiredCreator.ms" )	-- "./EventFiredCreator/EventFiredCreator.ms"


global STARTUP_EVENTS = #() -- run callbacks of controls like checkbox, checkbutton on UI start

/** ControlEventBinder_v
 *
 * FUNCTIONS OF DEFAULT CALLBACKS:
 *		1) Each event fires global variable EventFired
 * 		2) Save value of control to ini file if is defined
 *
 *
 *							   !!!!!!!!! NOTES FOR ADDING NEW TYPE OF CONTROL !!!!!!!!!
 *
 *								  Edit arrays in this file: control_types, event_types
 */
struct ControlEventBinder_v
(
	__construct = #( #_Rollout ),

	/* construct */
	_Rollout,


	/** Combine events and add handlers
	 */
	function addHandlers &_Control =
	(
		--format "\n"; print ("ControlEventBinder_v.addHandlers() "+ _Control.id)

		for Event_Data in _Control.Events do
			this._addHandler(_Control)(Event_Data.value)

		_Control --return
	),

	--private

	/** Bind events
	 */
	function _addHandler _Control Event =
	(
		--format "\n\n"; print "ControlEventBinder_v._addHandler()"
		--format "Event:	% \n" Event
		--format "Event.params:	% \n" Event.params
		--format "Event.type:	% \n" Event.type
		--format "Event.callback[#code]:	% \n" Event.callback[#code]

		this._addEventFired(_Control)(Event)

		if( Event.callback[#code] != "" ) then
			_Rollout.RCI.addHandler _Control.id Event.type codeStr:( "("+Event.callback[#code]+")" ) paramStr:(Event.params) filter:on
	),

	/**_type _add event fired
	 */
	function _addEventFired _Control Event =
	(
		--print "ControlEventBinder_v._addEventFired()"
		EventFiredCreator = EventFiredCreator_v _RolloutClass:(_Rollout.getFullId()) _RolloutControl:( (_Rollout.getFullId()) +"."+ _Control.id as string )

		for Event_Data in _Control.Events do
			Event.callback[#code]  = (EventFiredCreator.getEventFired(Event)) + "\n"+ Event.callback[#code]
			--(EventFiredCreator.getEventFired(Event)) --DEVELOP
	),

	/*------------------------------------------------------------------------------
		ON CREATE
	--------------------------------------------------------------------------------*/

	on create do
	(
		--print("ControlEventBinder_v.onCreate()")
		--format "_ROLLOUT	= % \n" _Rollout.title
		--ConstructPropeties test:this
	)

)
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
 *								  Edit arrays in this file: control_types, event_types -- in which file ??? WTF :)
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
		--format "_Rollout:	% \n" _Rollout.id

		for Event_Data in _Control.Events do
			this._addHandler(_Control)(Event_Data.value)

		_Control --return
	),

	--private

	/** Bind events
	 */
	function _addHandler _Control Event =
	(
		format "\n\n"; print "ControlEventBinder_v._addHandler()"
		----format "_Control.id:	% \n" _Control.id
		----format "Event:	% \n" Event
		----format "Event.type:	% \n" Event.type
		----format "Event.params:	% \n" Event.params
		--
		--format "\nEvent.callback[#arguments]:	% \n" Event.callback[#arguments]
		format "Event.callback[#code]:	\n\n============================================================\n%\n============================================================\n" Event.callback[#code]

		if( Event.callback[#code] != "" ) then
			_Rollout.RCI.addHandler _Control.id Event.type codeStr:( "("+Event.callback[#code]+")" ) paramStr:(Event.params) filter:on
	),

	--/**_type _add event fired
	-- */
	--function _addEventFired _Control Event =
	--(
	--	--print "ControlEventBinder_v._addEventFired()"
	--
	--	EventFiredCreator = EventFiredCreator_v _RolloutClass:(_Rollout.id as string ) _RolloutControl:( _Rollout.id as string +"."+ _Control.id as string )
	--
	--	--for Event_Data in _Control.Events do
	--		Event.callback[#code]  = (EventFiredCreator.getEventFired(Event)) + "\n\n"+ Event.callback[#code] + ";EventFired = undefined"
	--),

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
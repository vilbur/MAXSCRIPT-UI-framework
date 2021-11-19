global DIALOG_PREVIOUS_STATE = undefined -- this should be in struct

global ENABLE_DOCKED_EVENT = true -- prevent crash on destroying  of dialog

/** RolloutEvent https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_DC435555_362D_4A03_BCF2_21179C5442F2_htm
  * 
  *		1) Available events for dialog|rollout are #open, #close, #resized, #moved, #docked 
  *	
  *		2) Events #open, #close and #docked fires save to ini callback before user defined callback, if ini file is defined then
  *
  *		3) Each event fires global variable EventFired
  *	
  *	
  *	------------------------------------------------------------------------------------------------------------
  *	
  *	
  *	
  */
struct RolloutEvents_v 
(
	_Rollout,
	
	/** Bind events
	 */
	function bindEvents _Rollout =
	(
		format "\n"
		print ("RolloutEvents_v.bindEvents() " + _Rollout.id)
		--format "_Rollout.Events = % \n" _Rollout.Events
		this._Rollout = _Rollout
		
		for Event in _Rollout.Events.list do 
			this._bindEvent Event
	),
	
	private
	
	/** Bind events
	 */
	function _bindEvent Event =
	(
		print ("RolloutEvents_v.bindEvent()")
		format "Event	= % \n" Event
		
		--handler = "on "+(Parent_roll.id)+" "+ event_type as string + " "+params+" do (" +callback+ ")" 
		handler = "on "+(_Rollout.id)+" "+ Event.type as string +" val do  (" +Event.code+ ")" 
		
		--if( callback.count > 0 ) then
			_Rollout._RolloutCreator.addText(handler)
		
	),
	
	
	on create do
	(
	)
)
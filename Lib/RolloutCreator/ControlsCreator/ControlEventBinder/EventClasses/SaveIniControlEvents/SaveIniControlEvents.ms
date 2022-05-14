/** Events default
  
  
  -------------------------------------------------------------------------------------------------
					
					
								  DEPRECATED and UNUSED
								  
						  But not deleted yet in case for later use  
					
  
  -------------------------------------------------------------------------------------------------
  
 */
struct SaveIniControlEvents_v
(
	/* required */
	ini_path,
	rollout_id,

	/* properties */ 
	_Control,

	ini_event_types = #( #changed, #selected ), -- this events fires default save to ini callback

	/** Add save ini event for Control
	  *
	  * @return	list	of default events
	 */
	function getEvents _Control event_types =
	(
		this._Control = _Control
		
		for event_type in event_types where this._isSaveIniEventType(event_type) collect  this._getEvent(event_type)
	),

	private

	/** _is dynamic event type
	 */
	function _isSaveIniEventType event_type =
	(
		--print "SaveIniEvents_v._isSaveIniEventType()"
		findItem ini_event_types event_type > 0
	),

	/** Add save to ini event
	  *
	  * KNOWING ISSUES:
	  * 	PROBLEM:	 #Multilistbox on single click sometimes does not save to ini
	  *	SOLUTION:	Use Ctrl key even if selecting just single item 
	  *	
	 */
	function _getEvent event_type =
	(
		--print "SaveIniEvents_v._isSaveIniEventType()"
		Event_v type:event_type	code:("if( val != undefined ) then ( setINISetting \""+ini_path+"\" \""+rollout_id+"\" \""+_Control.id+"\" (val as string) )")
	),

	/**  
	 */
	on create do
	(
		--print("SaveIniControlEvents_v.onCreate()")
	)
)
filein( getFilenamePath(getSourceFileName()) + "/findResizeEventType.ms" )	-- "./findResizeEventType.ms"


/** Events default for rollout\dialog
 */
struct DefaultEvents_v
(
	/* properties */
	Events = #(),
	ini_path,

	/** Add default event for Rollout
	  *
	  * @return	list	of default events
	 */
	function getEvents rollout_id_full =
	(
		--format "\n"; print ("DefaultEvents_v.getEvents()" + rollout_id_full as string )

		/* MOVE CONTROLS TO GROUPBOXES */
		append Events ( Event_v type:#open	code:("GROUPBOXCREATOR.sortControlsToGroupBoxes(\""+rollout_id_full+"\")") )

		/* HANDLE WITH #RESIZE|#DOCKED|#UNDOCKED events */
		append Events ( Event_v type:#resized	code:("startResizeEventTimer(#"+rollout_id_full+")( #resized )") )


		/* SAVE DIALOG STATE IF INI FILE EXISTS */
		if( ini_path != undefined ) then
		(
			ini_path	= ( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace ini_path "/"

			append Events ( Event_v type:#okToClose code:("(IniSaver_v ini_file:\""+ini_path+"\").saveRollout(\""+rollout_id_full+"\")") )
		)

		Events --return
	),

	/**
	 */
	on create do
	(
		--print("EventsDefault_v.onCreate()")
		--this._checkConstctructProperties()
	)
)
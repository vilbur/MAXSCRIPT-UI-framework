filein( getFilenamePath(getSourceFileName()) + "/Controls/Controls.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Subrollouts/Subrollouts.ms" )

/** Rollout
 */
struct Rollout_v
(
	/* required */
	title,
	id,
	
	/* dependency */
	_Controls = #(),
	Events    = EventsList_v(),
	
	_RolloutCreator, -- Maxscript native RolloutCreator  https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_5FC5036F_E2D7_46C9_9AFA_7B3550B9F254_htm

	/* properties */
	is_subrollout = false,
	
	/* inhered */ 
	Layout,

	
	/** Controls
	 */
	function Controls group:undefined =
	(
		--print "Rollout_v.controls()"
		local Controls = Controls_v group:group
		
		append _Controls Controls
		
		Controls --return
	),
	
	/** Get Subrollouts for rollout
	 */
	function Subrollouts =
	(
		--print "Rollout_v.subrollouts()"
		local Subrollouts = Subrollouts_v slot:(this._getSlot())
		
		append _Controls Subrollouts
		
		Subrollouts --return
	),
	
	/** Subrollouts
	  *
	  * wrapper for user friedly coding
	 */
	function Rollouts =
	(
		this.Subrollouts() --return
	),
	
	private
	
	/** _get slot
	 */
	function _getSlot =
	(
		--print "Rollout_v._getSlot()"
		local subrollouts = for _struct in _Controls where matchPattern (classof _struct as string ) pattern:@"*Subrollouts_v*" collect _struct 

		("slot_"+id+"_"+(subrollouts.count+1) as string ) --return
	),
	
	/** Set id by title if not defined
	 */
	function _setId =
	(
		--print "RolloutCreator_v._setId()"
		if ( id == undefined or id == unsupplied ) then
			id = "ROLLOUT_" + (( dotNetObject "System.Text.RegularExpressions.Regex" @"[^A-Za-z0-9_]+" ).Replace ( (substituteString title " " "_") ) "")
		
		id --return
	),
	
	/**  
	 */
	on create do
	(
		this._setId()
		
		_RolloutCreator = rolloutCreator id title
	)
	
)

filein( getFilenamePath(getSourceFileName()) + "/Controls/Controls.ms" )

/** Rollout
 */
struct Rollout_v
(
	/* required */
	title,
	id,
	
	_Controls = #(),
	Events	 = #(),
	
	_RolloutCreator, -- https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_5FC5036F_E2D7_46C9_9AFA_7B3550B9F254_htm

	/** Controls
	 */
	function Controls =
	(
		--print "Rollout_v.controls()"
		local Controls = Controls_v()
		
		append _Controls Controls
		
		Controls --return
	),
	
	/** Subrollouts
	 */
	function Subrollouts =
	(
		--print "Rollout_v.subrollouts()"
		local Subrollouts = Subrollouts_v slot:(this._getSlot())
		
		append _Controls Subrollouts
		
		Subrollouts --return
	),
	
	private
	
	/** _get slot
	 */
	function _getSlot =
	(
		--print "Rollout_v._getSlot()"
		local subrollouts = for _struct in _Controls where matchPattern (classof _struct as string ) pattern:@"*Subrollouts_v*" collect _struct 
		format "subrollouts.count	= % \n" subrollouts.count
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

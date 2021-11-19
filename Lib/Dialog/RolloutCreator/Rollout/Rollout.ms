filein( getFilenamePath(getSourceFileName()) + "/Controls/Controls.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/Subrollouts/Subrollouts.ms" )

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
		
		_Controls_new = Controls_v()
		
		append _Controls _Controls_new
		
		_Controls_new --return
	),
	
	/** Subrollouts
	 */
	function Subrollouts =
	(
		print "Rollout_v.subrollouts()"
		_Subrollouts = Subrollouts_v()
		
		append _Controls _Subrollouts
		
		_Subrollouts --return
	),
	
	/**  
	 */
	on create do
	(
		_RolloutCreator = rolloutCreator id title
	)
	
)

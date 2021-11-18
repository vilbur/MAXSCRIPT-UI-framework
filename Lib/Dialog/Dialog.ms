filein( getFilenamePath(getSourceFileName()) + "/Rollout/Rollout.ms" )



/** Dialog
 */
struct Dialog_v
(
	--__construct = #(  ),
	
	/* required */
	title,
	id,
	
	/* dependency */
	/* reference */
	/* properties */
	RolloutMain,
	
	/** Create
	 */
	function create =
	(
		print "Dialog_v.create()"
		RolloutMain.createRollout()
		
		CreateDialog (RolloutMain._RolloutCreator.def)
	),
	
	/** rollouts
     */
    function rollouts =
    (
        RolloutMain.subrollouts() --return
    ),
	
	private
	
	/** Set main rollout
	 */
	function _setMainRollout =
	(
		--RolloutMain	= Rollout_v title:title id:id _Ini:_Ini
		RolloutMain	= Rollout_v title:title id:id --_Ini:_Ini
		
		--Events = RolloutMain.Events
	),
	/**  
	 */
	on create do
	(
		print("Dialog_v.onCreate()")
		this._setMainRollout()
		
		
	)
	
)

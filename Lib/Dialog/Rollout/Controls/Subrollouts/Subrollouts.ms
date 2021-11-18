/** Subrollouts
 */
struct Subrollouts_v
(
	/* required */
	
	/* properties */
	slot,
	
	Rollouts	= #(),
	
	/** Create new rollout
	 */
	function new title  =
	(
		--print "Subrollouts_v.test()"
		_Rollout = Rollout_v title:title --return
		
		append Rollouts _Rollout
		
		_Rollout --return
	),
	
	/** Create rollouts
	 */
	function createRollouts =
	(
		--print "Subrollouts_v.createRollouts()"
		for _Rollout in Rollouts do 
			_Rollout.createRollout()
	),
	
	
	private
	
	/**  
	 */
	on create do
	(
		--print("Subrollouts_v.onCreate()")
	)
	
)

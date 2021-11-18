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
	
	/** Add sub rollouts
	 */
	function addSubRollouts parent_roll_id =
	(
		print "Subrollouts_v.addSubRollouts()"
		format "slot	= % \n" slot
		for _Rollout in Rollouts do
			this.addSubrollout (_Rollout)(parent_roll_id)
	),
	
	/** Add subrollout
	 */
	function addSubrollout _Rollout parent_roll_id =
	(
		--print "Subrollouts_v.addSubrollout()"
		
		execute ( "\n AddSubRollout "+parent_roll_id+".slot_" + slot as string + " "+ _Rollout.id )
	),
	
	private
	
	/**  
	 */
	on create do
	(
		--print("Subrollouts_v.onCreate()")
	)
	
)

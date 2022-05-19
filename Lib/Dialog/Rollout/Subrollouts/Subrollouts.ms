/** Subrollouts
 */
struct Subrollouts_v
(
	/* required */

	/* properties */
	parent_rollout_id,
	slot,
	height,
	--height = 128, -- DEV

	Rollouts	= #(),

	/** Get new Rollout
	 */
	function new title id: =
	(
		--print "Subrollouts_v.new()"
		--format "title	= % \n" title
		local _Rollout = Rollout_v title:title id:id parent_rollout_id:( parent_rollout_id as string +"."+slot as string) height:height

		append Rollouts _Rollout

		_Rollout --return
	),

	/** Get rollout from Rollouts
	 */
	function get rollout_id =
	(
		format "\n"; print "Subrollouts_v.get()"
		format "rollout_id	= % \n" rollout_id
		
		--for _Rollout in Rollouts where _Rollout.id == ( rollout_id as name ) do 
		for _Rollout in Rollouts  do 
		format "_Rollout.id	= % \n" _Rollout.id
		
		(for _Rollout in Rollouts where _Rollout.id == ( rollout_id as name ) collect _Rollout)[1] --return
	),
	
	
	private

	/**  
	 */
	on create do
	(
		--print("Subrollouts_v.onCreate()")
		--format "slot	= % \n" slot
	)
)

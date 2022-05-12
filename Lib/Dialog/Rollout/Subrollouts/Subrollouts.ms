/** Subrollouts
 */
struct Subrollouts_v
(
	/* required */

	/* properties */
	parent_rollout,
	slot,

	Rollouts	= #(),

	/** Create new rollout
	 */
	function new title id: =
	(
		--print "Subrollouts_v.new()"
		local _Rollout = Rollout_v title:title id:id parent_rollout:( parent_rollout as string +"."+slot as string)

		append Rollouts _Rollout

		_Rollout --return
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
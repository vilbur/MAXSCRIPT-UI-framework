/** Subrollouts
 */
struct Subrollouts_v
(
	/* required */

	/* properties */
	parent_rollout, -- store parent id
	slot,

	Rollouts	= #(),

	/** Create new rollout
	 */
	function new title id: =
	(
		--print "Subrollouts_v.roll()"
		local _Rollout = Rollout_v title:title id:id parent_rollout:parent_rollout

		append Rollouts _Rollout

		_Rollout --return
	),

	private

	/**  
	 */
	on create do
	(
		--print("Subrollouts_v.onCreate()")
	)
)
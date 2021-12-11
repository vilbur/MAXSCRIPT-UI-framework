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
	function new title id: =
	(
		--print "Subrollouts_v.roll()"
		local _Rollout = Rollout_v title:title id:id  is_subrollout:true

		append Rollouts _Rollout

		_Rollout --return
	),

	/** Create new rollout
	 */
	function roll title id: =
	(
		--print "Subrollouts_v.roll()"
		local _Rollout = Rollout_v title:title id:id  is_subrollout:true

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
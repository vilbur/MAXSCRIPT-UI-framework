/** Subrollouts
 */
struct Subrollouts_v
(
	/* required */

	/* properties */
	parent_rollout,
	slot,
	height,
	--height = 128,

	Rollouts	= #(),

	/** Get new Rollout
	 */
	function new title id: =
	(
		--print "Subrollouts_v.new()"
		--format "title	= % \n" title
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
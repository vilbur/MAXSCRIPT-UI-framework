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
		--format "\n"; print "Subrollouts_v.new()"
		--format "title	= % \n" title
		local _Rollout = Rollout_v title:title id:id parent_rollout_id:( parent_rollout_id as string +"."+slot as string) height:height

		append Rollouts _Rollout

		_Rollout --return
	),

	/** Get rollout from Rollouts
	 */
	function get id =
	(
		format "\n"; print "Subrollouts_v.get()"
		format "slot	= % \n" slot
		--format "id	= % \n" id
		local found_rollout
		local found_result

		--(for _Rollout in Rollouts where _Rollout.id == ( id as name ) collect _Rollout)[1] --return
		
		--for _Rollout in Rollouts where (found_rollout = _Rollout.get (id)) != undefined do
		--(
		--	found_result = found_rollout
		--	
		--	format "FOUND_ROLLOUT	= % \n" found_rollout
		--	--format "FOUND_RESULT	= % \n" found_result
		--)
		if id == slot then
			return found_rollout
		else
		
			for _Rollout in Rollouts do
			(
				found_rollout = _Rollout.get (id)
				
				if( found_rollout != undefined ) then
					return found_rollout
	
					--found_result = found_rollout
				
			)
		
		--format "FOUND_RESULT	= % \n" found_result

		--found_result --return 		
	),
	
	
	private
	
	/**  
	 */
	on create do
	(
		--print("Subrollouts_v.onCreate()")
	)
)
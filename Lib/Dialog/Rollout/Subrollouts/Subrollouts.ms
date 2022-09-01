/** Subrollouts
 */
struct Subrollouts_v
(
	/* required */

	/* properties */
	parent_rollout_id,
	slot,
	
	width,
	height,
	--height = 128, -- DEV

	Rollouts	= #(),
	
	/** Create new Rollout
	 */
	function Roll title id: width: height: =
	(
		--format "\n"; print "Subrollouts_v.Roll()"
		--format "title	= % \n" title
		local _Rollout = Rollout_v title:title id:id parent_rollout_id:( parent_rollout_id as string +"."+slot as string ) width:(if width != unsupplied then width else this.width)

		append Rollouts _Rollout

		_Rollout --return
	),
	
	/** Get new Rollout
	 */
	function new title id: =
	(
		format "\n"; print "!!!!!!!! DEPRECATED METHOD Subrollouts_v.Roll() please use Subrollouts_v.roll() "/

		this.Roll title id:id --return
	),

	/** Get Subrollouts_v or Rollout_v 
	  * 
	  * 
	  * @param	name	id	id of rollout or subrollout slot
	  * 
	  * @return	object Subrollouts_v|Rollout_v
	 */
	function get id =
	(
		--format "\n"; print "Subrollouts_v.get()"
		if id == slot then
			return this
			
		else
			for _Rollout in Rollouts where (found_rollout = _Rollout.get (id)) != undefined do
				return found_rollout
		
		undefined --return
	),
	
	
	private
	
	/**  
	 */
	on create do
	(
		--format "\n"; print "Subrollouts_v.onCreate()"
		--format "width	= % \n" width
		
	)
)
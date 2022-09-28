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

	Rollouts	= #(),
	
	/** Create new Rollout
	 */
	function Roll title id: width: height: =
	(
		format "\n"; print "Subrollouts_v.Roll()"
		format "this.width	= % \n" this.width
		format "this.height	= % \n" this.height
		--format "title	= % \n" title
		
		--local _Rollout = Rollout_v title:title id:id parent_rollout_id:( parent_rollout_id as string +"."+slot as string ) width:(if width != unsupplied then width else this.width)
		local _Rollout = Rollout_v title:title id:id parent_rollout_id:( parent_rollout_id as string +"."+slot as string ) width:(if width != unsupplied then width else this.width) height:height

		--local _Rollout = Rollout_v title:title id:id parent_rollout_id:( parent_rollout_id as string +"."+slot as string )

		--if height != unsupplied then
			--_Rollout.height = height

		append Rollouts _Rollout

		_Rollout --return
	),
	
	/** Get new Rollout
	 */
	function new title id: =
	(
		format "\n"; print "!!!!!!!! DEPRECATED METHOD Subrollouts_v.new() please use Subrollouts_v.Roll() "

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
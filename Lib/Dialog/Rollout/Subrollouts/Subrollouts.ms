/** Subrollouts


   RENAME THIS TO: SubrolloutsSlot

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

	/* developent */
	DEBUG = false,
	--DEBUG = true,

	/** Create new Rollout
	 */
	function Roll title id: width: height: rolledUp:undefined =
	(
		--format "\n"; print "Subrollouts_v.Roll()"
		--format "this.width: %\n" this.width
		--format "width:      %\n" width

		if width == unsupplied then
			width = this.width - 4 -- make rollout wide as is possible

		--local _Rollout = Rollout_v title:title id:id parent_rollout_id:( parent_rollout_id as string +"."+slot as string )
		local _Rollout = Rollout_v title:title id:id width:width height:height parent_rollout_id:(parent_rollout_id as string + "." + slot as string ) rolledUp:rolledUp DEBUG:DEBUG
		--format "_Rollout:	% \n" _Rollout
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


	/** Get height
	 */
	function getHeight =
	(
		--format "\n"; print "Subrollouts_v.getHeight()"
		execute( this.getSlotId() +".height" ) --return
	),


	/** Set height
	 */
	function setHeight val =
	(
		--format "\n"; print "Subrollouts_v.setHeight()"
		execute( this.getSlotId() +".height = " + val as string )
	),

	/** Get slot id
	 */
	function getSlotId =
	(
		--format "\n"; print "Subrollouts_v.getSlotId()"
		 parent_rollout_id as string +"."+ slot as string --return
	),

	private

	/**
	 */
	on create do
	(
		--format "\n"; print "Subrollouts_v.onCreate()"
		if this.slot != undefined and this.slot != unsupplied then
			this.slot = this.slot as name
	)
)
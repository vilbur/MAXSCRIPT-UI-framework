/** Dialog global
 */
struct DialogGlobalData_v
(
	/* construct */
	DialogClass, 	-- RolloutClass
	Dialog,	-- Dialog_v
	/* properties */
	size	= [0,0],
	position	= [0,0],
	dock_state,

	/* dependency */
	/* reference */
	/* inhered */

	/** Fill data
	  *
	  */
	function fill =
	(
		this.position	= GetDialogPos  this.DialogClass

		this.size	= GetDialogSize this.DialogClass

		this.dock_state = (try(cui.getDockState this.DialogClass )catch(#cui_floatable))
	),

	private

	/**
	 */
	on create do
	(
		--format "\n"; print "DialogGlobal.onCreate()"
		this.fill()
	)

)

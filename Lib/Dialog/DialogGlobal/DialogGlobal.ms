/** Dialog global
 */
struct DialogGlobalData_v
(
	/* construct */
	Dialog,
	Events,
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
		--format "\n"; print "DialogGlobalData_v.fill()"
		--this.position	= GetDialogPos  this.Dialog
		--this.size	= GetDialogSize this.Dialog
		--
		--this.dock_state = (try(cui.getDockState _Rollout )catch(#cui_floatable))
		this.fillDockState()
		this.fillPosition()
		this.fillSize()

	),



	/** Set position
	  *
	  */
	function fillPosition =
	(
		--format "\n"; print "DialogGlobalData_v.setSize()"
		this.position	= GetDialogPos  this.Dialog
	),

	/** Set size
	  *
	  */
	function fillSize =
	(
		--format "\n"; print "DialogGlobalData_v.setSize()"
		this.size	= GetDialogSize this.Dialog
	),

	/** Set size
	  *
	  */
	function fillDockState =
	(
		--format "\n"; print "DialogGlobalData_v.setSize()"
		this.dock_state = (try(cui.getDockState this.Dialog )catch(#cui_floatable))
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

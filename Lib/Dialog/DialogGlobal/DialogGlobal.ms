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
		--format "\n"; print "DialogGlobal.fill()"
		if (this.position = GetDialogPos  this.DialogClass) == [0,0] then
			this.position	= execute ("GetDialogPos " + this.DialogClass.name ) -- fallback if dialog is created with cach file

		if (this.size = GetDialogSize  this.DialogClass) == [0,0] then
			this.size	= execute ("GetDialogSize " + this.DialogClass.name )

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

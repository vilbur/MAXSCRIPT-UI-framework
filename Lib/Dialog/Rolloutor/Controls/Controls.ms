filein( getFilenamePath(getSourceFileName()) + "/ControlsBox/ControlsBox.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Subrollouts/Subrollouts.ms" )

/** Controls
 */
struct Controls_v
(
	--__construct = #(  ),
	--
	--/* required */
	--/* dependency */
	--/* reference */
	--/* properties */
	--list	= #(),
		
	_Controls = #(),

	ControlsBox,
	_Subrollouts,
	
	/** Controls
	 */
	function new caption across:4 =
	(
		print "Controls_v.new()"
		
		ControlsBox = ControlsBox_v caption:caption across:across
		
		append _Controls ControlsBox
		
		--ControlsBox --return
		this --return
	),
	
	/** Subrollouts
	 */
	function subrollouts slot: =
	(
		print "Controls_v.subrollouts()"
		
		
		_Subrollouts = Subrollouts_v slot:1
		
		append _Controls _Subrollouts
		
		--this --return
		_Subrollouts --return
	),
	
	
	/** Button
	 */
	function button caption id: params:"" =
	(
		print "ControlsBox_v.button()"
		_Control 	= Control_v caption:caption id:id params:params
		format "_Control	= % \n" _Control
		append ControlsBox.Controls _Control
		
		_Control --return
	),
	
	--
	--
	--
	--private
	--
	--
	/**  
	 */
	on create do
	(
		
		
	)
	
)

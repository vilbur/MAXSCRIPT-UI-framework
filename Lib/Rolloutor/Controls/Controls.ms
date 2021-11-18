filein( getFilenamePath(getSourceFileName()) + "/ControlsBox/ControlsBox.ms" )

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
	--
	
	_Controls = #(),

	ControlsBox,
	
	/** Controls
	 */
	function new caption =
	(
		print "Controls_v.new()"
		
		ControlsBox = ControlsBox_v caption:caption
		
		append _Controls ControlsBox
		
		--ControlsBox --return
		this --return
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

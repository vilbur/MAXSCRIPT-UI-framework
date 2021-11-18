filein( getFilenamePath(getSourceFileName()) + "/Rollout/Rollout.ms" )



/** Dialog
 */
struct Dialog_v
(
	--__construct = #(  ),

	/* required */
	title,
	id,
	
	/* dependency */
	RolloutMain,
	Controls,

	/* properties */
	style = #(#style_titlebar, #style_border, #style_sysmenu, #style_resizing),
	
	/** Create
	  *
	  * TODO add params for max 2022
	 */
	function create pos: width: height: bgcolor: fgcolor: bitmap: style: modal: escapeEnable: lockHeight:false lockWidth:true parent: =
	(
		--print "Dialog_v.create()"
		RolloutMain.createRollout()
		
		CreateDialog (RolloutMain._RolloutCreator.def) width:width height:height style:style
		

		RolloutMain.addSubRollouts()

		--try
		--(
		--	AddSubRollout ROLLOUT_Test.slot_1 ROLLOUT_Subrollout_A
		--
		--)
		--catch()
		
	),
	
	/** rollouts
     */
    function rollouts =
    (
        RolloutMain.Controls.subrollouts() --return
    ),
	
	private
	
	/** Set main rollout
	 */
	function _setMainRollout =
	(
		--RolloutMain	= Rollout_v title:title id:id _Ini:_Ini
		RolloutMain	= Rollout_v title:title id:id --_Ini:_Ini
		
		Controls = RolloutMain.Controls

		--format "RolloutMain	= % \n" RolloutMain
		--Events = RolloutMain.Events
	),
	/**  
	 */
	on create do
	(
		--print("Dialog_v.onCreate()")
		this._setMainRollout()
	)
	
)

filein( getFilenamePath(getSourceFileName()) + "/Rollout/Rollout.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../Ini/Ini.ms" )


/** Dialog
 */
struct Dialog_v
(
	--__construct = #(  ),

	/* required */
	title,
	
	/* optionable */
	id,
	ini,
	
	/* dependency */
	--Menu	= DialogMenu_v Dialog:this,
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

	),
	
	/** rollouts
     */
    function rollouts =
    (
        --RolloutMain.Controls.subrollouts() --return
        RolloutMain.rollouts() --return
    ),
	
	--/** Ini set\get ini path
	--  *
	--  * @property	string|#get	_path	set or get path t ini file
	--  * @property	boolean	load	load values from ini on init
	--  *
	--  * @return	string path	to ini file
	-- */
	--function ini _path load:true =
	--(
	--	--print "Dialog_v.ini()"
	--	RolloutMain.ini _path load:load --return
	--),
	
	private
	
	/** Set main rollout
	 */
	function _setMainRollout =
	(
		--print "Dialog_v._setMainRollout()"
		format "ini	= % \n" ini
		
		--RolloutMain	= Rollout_v title:title id:id 
		--RolloutMain	= Rollout_v title:title id:id _Ini:_Ini
		RolloutMain	= Rollout_v title:title id:id
		
		if( ini != undefined ) then
			RolloutMain.Ini.setIni (ini)
		
		Controls = RolloutMain.Controls

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
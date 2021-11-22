filein( getFilenamePath(getSourceFileName()) + "/RolloutCreator/RolloutCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Layout/Layout.ms" )


/** Dialog
 */
struct Dialog_v
(
	/* required */
	title,
	
	/* construct */
	ini, -- path to ini file

	/* optionable */
	id,
	
	/* dependency */
	_RolloutCreator = RolloutCreator_v(),
	Layout 	= Layout_v(),
	--Menu	= DialogMenu_v Dialog:this,
	
	/* properties */
	style = #(#style_titlebar, #style_border, #style_sysmenu, #style_resizing),
	RolloutMain, --RENAME TO dialogRollout,
	
	/* inherit */
	Controls,
	Events,
	
	/** Create
	  *
	  * TODO add params for max 2022
	 */
	function create pos: width:256 height:256 bgcolor: fgcolor: bitmap: style: modal: escapeEnable: lockHeight:false lockWidth:true parent: =
	(
		print ("Dialog_v.create() " + RolloutMain.id)
		
		_RolloutCreator.createRollout (RolloutMain) dialog_rollout:true
		
		CreateDialog (_RolloutCreator.getDefinition(RolloutMain)) width:width height:height style:style
		
		_RolloutCreator.addSubRollouts RolloutMain
	),
	
	/** rollouts
     */
    function rollouts =
    (
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
		
		--RolloutMain	= Rollout_v title:title id:id _Ini:_Ini
		RolloutMain	= Rollout_v title:title id:id Layout:Layout

		Controls = RolloutMain.Controls

		Events = RolloutMain.Events
	),
	/**  
	 */
	on create do
	(
		--print("Dialog_v.onCreate()")
		this._setMainRollout()
		
		if( ini != undefined ) then
			_RolloutCreator.Ini.setIni (ini)
	)
)
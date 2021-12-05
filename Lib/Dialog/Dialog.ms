filein( getFilenamePath(getSourceFileName()) + "/../RolloutCreator/RolloutCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Layout/Layout.ms" )

global DIALOG_PREVIOUS_STATE = undefined -- this should be in struct

global ENABLE_DOCKED_EVENT = true -- prevent crash on destroying  of dialog // RENAME THIS TO DIALOG_ENABLE_DOCKED_EVENT

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
	style = #(#cui_floatable, #style_titlebar, #style_border, #style_sysmenu, #style_resizing),
	
	RolloutMain, --RENAME TO dialogRollout,
	
	/* inherit */
	Events,
	
	/** Create
	  *
	  * TODO add params for max 2022
	 */
	function create pos: width:512 height:1024 bgcolor: fgcolor: bitmap: style: modal: escapeEnable: lockHeight:false lockWidth:true parent: =
	(
		print ("Dialog_v.create() " + RolloutMain.id)
		
		if( style == unsupplied ) then style = this.style
		
		height = this._getDialogHeight(height)
		
		--format "style	= % \n" style
		--_RolloutCreator.createRollout (RolloutMain) dialog_rollout:true
		_RolloutCreator.createRollout (RolloutMain) height:height
		--format "RolloutMain._RolloutCreator	= % \n" RolloutMain._RolloutCreator
		
		CreateDialog (_RolloutCreator.getDefinition(RolloutMain)) pos:(this._getPositionRelativeToWindow(pos)) width:width height:height bgcolor:bgcolor fgcolor:fgcolor bitmap:bitmap style:style modal:modal escapeEnable:escapeEnable lockHeight:lockHeight lockWidth:lockWidth parent:parent
		
		_RolloutCreator.addSubRollouts RolloutMain
	),
    
	/** Register dialog bar
	 */
	function register =
	(
		ENABLE_DOCKED_EVENT = false
		
		execute ("cui.RegisterDialogBar "+ RolloutMain.id +" style:"+style as string )
		
		ENABLE_DOCKED_EVENT = true
	),
	
	/** Unregister dialog bar
	 */
	function unregister =
	(
		execute ("try(cui.UnRegisterDialogBar "+ RolloutMain.id +")catch()")
	),
	
	/** Dock\Undock dialog
	  * 
	  * Subrollouts and dialog are resized BEFORE docking
	  *
	  * @param	name	state #left|#top|#right|#bottom|#float
	 */
	function dock state =
	(
		this.register()
		--format "state	= % \n" state
		if ( state != #float ) then
			execute ("cui.DockDialogBar "+ RolloutMain.id +" #cui_dock_"+ state as string )
		else
			execute ("cui.floatDialogBar "+ RolloutMain.id )
	),
	
	/** Destroy dialog
	 */
	function destroy =
	(
		print "DialogRemote.destroy()"
		--format "RolloutMain.id	= % \n" RolloutMain.id
		ENABLE_DOCKED_EVENT = false
		
		this.unregister()
		
		execute ( "try( destroyDialog "+ RolloutMain.id +" )catch()" )
		
		ENABLE_DOCKED_EVENT = true
	),
	
	/*------------------------------------------------------------------------------
		INHERED
	--------------------------------------------------------------------------------*/
	
	/** rollouts
     */
    function rollouts =
    (
        RolloutMain.rollouts() --return
    ),

	/** Controls
	 */
	function Controls group:undefined =
	(
		--print "Dialog_v.Controls()"
		RolloutMain.Controls group:group
	),
	

	private
	
		
	/** _get dialog height
	 */
	function _getDialogHeight height =
	(
		--print "Dialog_v._getDialogHeight()"
		--format "height	= % \n" height
		if( height != unsupplied ) then
			return height
		
		this._getViewportHeight() --return
	),
	
	/** Get height of maximized viewport to find out height of docked dialog
	 */
	function _getViewportHeight =
	(
		--print "Dialog_v._getViewportHeight()"
		is_maximized	= viewport.numViews == 1
		
		height_of_ui	= 0 -- Add heigh
		dialog_title_height	= 30
		
		--if( trackbar.visible ) then 
		--	height_of_ui	+= 27
		--
		--if( timeSlider.isVisible() ) then 
		--	height_of_ui	+= 18
		
		if not( is_maximized ) then 
			actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle
		
		viewport_area_size = getViewSize()
		
		if not( is_maximized ) then 
			actionMan.executeAction 0 "50026"  -- Tools: Maximize Viewport Toggle
		
		(viewport_area_size[2] as integer) + height_of_ui - dialog_title_height --return
	),
	
	/** Get position relative to Max window
	 */
	function _getPositionRelativeToWindow pos =
	(
		--print "Dialog_v.getPosition()"
		
		toolbar_height = 92
		
		if( pos == unsupplied ) then 
			return pos
		
		win_pos = windows.getWindowPos (windows.getMAXHWND())

		[ win_pos.x+pos.x, win_pos.y+pos.y + toolbar_height]  --return
	),
	
	/** Set main rollout
	 */
	function _setMainRollout =
	(
		--print "Dialog_v._setMainRollout()"
		RolloutMain	= Rollout_v title:title id:id Layout:Layout

		Events = RolloutMain.Events
	),
	

	/**  
	 */
	on create do
	(
		--print("Dialog_v.onCreate()")
		this._setMainRollout()
		
		this.destroy()
		
		if( ini != undefined ) then
			_RolloutCreator.Ini.setIni (ini)
	)
)
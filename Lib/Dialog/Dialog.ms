filein( getFilenamePath(getSourceFileName()) + "/../ConstructPropeties/ConstructPropeties.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../RolloutCreator/RolloutCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Layout/Layout.ms" )
filein( getFilenamePath(getSourceFileName()) + "/AutoRunEvents/AutoRunEvents.ms" )


global DIALOG_PREVIOUS_STATE = undefined -- this should be in struct

global EVENT_DOCKED_ENABLED = true -- prevent crash on destroying  of dialog // RENAME THIS TO DIALOG_ENABLE_DOCKED_EVENT

/** https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-816D257C-CD2D-4753-A792-6E7AEFAFA6A7
 */
struct Dialog_v
(
	__construct = #( #title ),

	/* required */
	title,
	
	/* construct */
	ini, -- path to ini file

	/* optionable */
	id,
	
	/* dependency */
	_RolloutCreator = RolloutCreator_v ini:ini,
	AutoRunMacros 	= AutoRunMacros_v(),
	Layout 	= Layout_v(),
	--Menu	= DialogMenu_v Dialog:this,
	
	RolloutMain, --RENAME TO dialogRollout,
	
	/* inherit */
	Events,
	
	/* properties */
	style = #(
		#style_border, 	-- Creates a window with a double border, but no title.
		#style_titlebar, 	-- Creates a dialog with a title bar.
		#style_sysmenu, 	-- Creates a window that has a window menu in its title bar.
		#style_resizing 	-- Creates a window with a thick frame that can be used to size the window.
		
		/* ALLOWED but not DEFAULT styles */ 
		--#style_toolwindow, 	-- Creates a tool window, which has a title bar and is intended to be used as a floating toolbar. A tool window has a title bar that is shorter than a normal title bar, and the window title is drawn using a smaller font.
		--#style_minimizebox, 	-- Creates a window that has a minimize button.
		--#style_maximizebox, 	-- Creates a window that has a maximize button.
		--#style_sunkenedge, 	-- Specifies that a window has a 3D look in the form of a border with a sunken edge.
	),

	style_dialog = #(
		#cui_floatable,	-- Dialogbar can float
		#cui_dock_all,	-- Dialog bar can dock on all 4 edges of the frame.
		#cui_handles	-- Show gripper handles when docked

		/* ALLOWED but not DEFAULT styles */ 
		--#cui_dock_horz,	-- Can dock horizontally (top and bottom)
		--#cui_dock_vert,	-- Can dock vertically (left and right)
		--#cui_dock_left ,	-- Can dock to the left
		--#cui_dock_top,	-- Can dock to the top
		--#cui_dock_right,	-- Can dock to the right
		--#cui_dock_bottom,	-- Can dock to the bottom
		--#cui_max_sized,	-- When this flag is specified, docking the dialogbar on the top causes the dialogbar to expand to the full window width, docked to bottom it expands to full window width minus command panel width.
	),
	
	/** Create
	  *
	  * TODO add params for max 2022
	 */
	function create pos: width:512 height:512 bgcolor: fgcolor: bitmap: style: modal: escapeEnable: lockHeight:false lockWidth:true parent: =
	(
		--print ("Dialog_v.create() " + RolloutMain.id)
		
		height = this._getDialogHeight(height)
		
		_RolloutCreator.createRollout (RolloutMain) width:width height:height
		
		CreateDialog (_RolloutCreator.getDefinition(RolloutMain)) pos:(this._getPositionRelativeToWindow(pos)) autoLayoutOnResize:true  width:width height:height bgcolor:bgcolor fgcolor:fgcolor bitmap:bitmap style:(if( style == unsupplied ) then this.style else style) modal:modal escapeEnable:escapeEnable lockHeight:lockHeight lockWidth:lockWidth parent:parent
		
		_RolloutCreator.addSubRollouts RolloutMain
		
		AutoRunMacros.executeMacros()
	),
    
	/** Register dialog bar
	 */
	function register =
	(
		execute ("cui.RegisterDialogBar "+ RolloutMain.id +" style:"+style_dialog as string )
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

		if ( state != #float ) then
			execute ("cui.DockDialogBar "+ RolloutMain.id +" #cui_dock_"+ state as string )
		else
			execute ("cui.floatDialogBar "+ RolloutMain.id )
		
		EVENT_DOCKED_ENABLED = true
	),
	
	/** Destroy dialog
	 */
	function destroy =
	(
		--print "Dialog_v.destroy()"
		--format "RolloutMain.id	= % \n" RolloutMain.id
		EVENT_DOCKED_ENABLED = false
		
		this.unregister()
		--sleep 1
		execute ( "try( destroyDialog "+ RolloutMain.id +" )catch()" )
		
		EVENT_DOCKED_ENABLED = true
	),
	
	/*------------------------------------------------------------------------------
		Extend RolloutMain
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
		--format "viewport_area_size	= % \n" viewport_area_size
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
	

	/** Check if required properties are defined when an instance of the struct is created.
	 * @example __construct = #( #property_name ) 
	 */
	function _checkConstctructProperties =
	(
		for prop in __construct where getProperty this prop == undefined do
			messageBox ("SaveIniControlEvents\nUndefined construct property !\n\n"+ ((filterString( classof this as string )"(:")[2]) +"."+ prop )
	),

	/**  
	 */
	on create do
	(
		--print("Dialog_v.onCreate()")
		ConstructPropeties test:this

		this._setMainRollout()
		
		this.destroy()
	)
)
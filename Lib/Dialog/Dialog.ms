global DIALOG_PREVIOUS_STATE = undefined -- this should be in struct

global EVENT_DOCKED_ENABLED = true -- prevent crash on destroying  of dialog // RENAME THIS TO DIALOG_ENABLE_DOCKED_EVENT

global AUTORUN_EVENTS = #()


filein( getFilenamePath(getSourceFileName()) + "/../ConstructPropeties/ConstructPropeties.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../RolloutCreator/RolloutCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Layout/Layout.ms" )
filein( getFilenamePath(getSourceFileName()) + "/AutoRunEvents/AutoRunEvents.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../Ini/Ini.ms" )


/** https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-816D257C-CD2D-4753-A792-6E7AEFAFA6A7
 */
struct Dialog_v
(
	/* required */
	title,
	
	/* construct */
	Ini,
	
	width	= 512,
	--width,
	height	= 512,
	--height,
	
	/* options */
	id,
	
	/* dependency */
	AutoRunEvents 	= AutoRunEvents_v(),
	Layout 	= Layout_v(),
	--Menu	= DialogMenu_v Dialog:this,
	
	RolloutMain, --RENAME TO DialogRollout ???,
	
	/* inherit */
	Events, -- RolloutMain.Events
	
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
	
	/** Create dialog
	  * NOTE: width and height of dialog must be defined on init
	  * 
	  * 
	  * TODO IMPORTANT: remove width & height params
	  * 
	  * TODO add params for max 2022
	 */
	function create pos: bgcolor: fgcolor: bitmap: style: modal: escapeEnable: lockHeight:false lockWidth:true parent: =
	(
		format "\n"; print "Dialog_v.create()"
		dialog_width  = this._getDialogSize( #width )
		dialog_height = this._getDialogSize( #height)
		format "dialog_width	= % \n" dialog_width
		format "dialog_height	= % \n" dialog_height
		_RolloutCreator = RolloutCreator_v Ini:Ini

		_RolloutCreator.createRollout (RolloutMain) width:dialog_width height:dialog_height

		--CreateDialog (_RolloutCreator.getDefinition(RolloutMain)) 
		--CreateDialog (_RolloutCreator.getDefinition(RolloutMain))  width:RolloutMain.width height:RolloutMain.height 
		CreateDialog (_RolloutCreator.getDefinition(RolloutMain)) pos:(this._getPositionRelativeToWindow(pos)) autoLayoutOnResize:true  width:dialog_width height:dialog_height bgcolor:bgcolor fgcolor:fgcolor bitmap:bitmap style:(if( style == unsupplied ) then this.style else style) modal:modal escapeEnable:escapeEnable lockHeight:lockHeight lockWidth:lockWidth parent:parent
		--
		_RolloutCreator.SubolloutsCreator.addSubRollouts (RolloutMain)
		--
		--this._setPositionOrDockByIni()
		--
		--AutoRunEvents.executeMacros()
		format "\n\nDIALOG CREATED\n\n" 
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
		--print "Dialog_v.unregister()"
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
	/** Create new rollout in first slot
	 */
	function Roll title id: =
	(
		--format "\n"; print "Rollout_v.rollout()"
		Subrollouts = if (Subrollout_slots = RolloutMain.getSubrollouts()).count > 0 then Subrollout_slots[1] else this.Rollouts()
		
		Subrollouts.Roll title id:id --return
	),
	
	/** Get new subrollouts slot
	  * 
	  * @param	name	slot	id of subrollouts slot
	  * @param	integer	height	of slot
	  * 
	  * @return	struct Subrollouts_v 	
     */
    function Rollouts slot: height: =
    (
        RolloutMain.rollouts slot:slot height:height --return
    ),

	/** Controls
	 */
	function Controls group:undefined =
	(
		--print "Dialog_v.Controls()"
		RolloutMain.Controls group:group
	),
	


	/** Get Subrollouts_v or Rollout_v 
	  * 
	  * @param	name	id	id of rollout or subrollout slot
	  * 
	  * @return	object Subrollouts_v|Rollout_v
	 */
	function get id =
	(
		RolloutMain.get (id)--return
	),

	private
	
	/** Set dialog id as global variable
	  *
	  * It is for unnecessary for make EventFired working
	  *
	 */
	function _setDialogGlobal =
	(
		--format "\n"; print "global._setDialogGlobal()"
		execute("global "+RolloutMain.id)
	),
	

	
	/** Get size of dialog 
	  *
	  * 1. get from ini
	  * 2. use defined height
	  * 3. get default height from RolloutMain.height
	  *
	  * @param	name	dimension	#width|#height
	 */
	function _getDialogSize dimension =
	(
		--print "Dialog_v._getDialogSize()"

		if( Ini.isDefined() and (dialog_size = Ini.load( RolloutMain.id as string )("size")) != undefined) then
		(
			if dimension == #width then dialog_size.x  as integer else dialog_size.y  as integer --return ini value
		)
		else if( size = getProperty this dimension ) != undefined then
			size --return defined height
			
		else
			getProperty RolloutMain dimension --return default height
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
		print "Dialog_v._setMainRollout()"
		RolloutMain	= Rollout_v title:title id:id Layout:Layout 

		Events = RolloutMain.Events
	),
	
	/** Set main rollout
	 */
	function _setMainRolloutWidthAndHeight =
	(
		print "Dialog_v._setMainRolloutWidthAndHeight()"
		format "width	= % \n" width
		format "height	= % \n" height
		if width != undefined then 
			RolloutMain.width = width
			
		if height != undefined then 
			RolloutMain.height = height
	),
	
	/** _load ini position
	 */
	function _setPositionOrDockByIni =
	(
		--format "\n"; print "global._setPositionOrDockByIni()"
		if Ini.isDefined() then
		(
			dock_state	= Ini.load( RolloutMain.id as string )("dock_state")
			position	= Ini.load( RolloutMain.id as string )("position")
			
			if( dock_state != undefined and dock_state != "cui_floatable" ) then
			(
				--print "Set Dialog Dock"
				this.register()
				execute("cui.DockDialogBar "+ RolloutMain.id +" #"+ dock_state )
			)
			else if( position != undefined ) then
			(
				--print "Set Dialog Float"
				execute("SetDialogPos "+ RolloutMain.id +" "+ position as string )
				this.register()
			)
		)
	),
	
	/** Check if required properties are defined when an instance of the struct is created.
	 * @example __construct = #( #property_name ) 
	 */
	function _checkConstctructProperties __construct =
	(
		for prop in __construct where getProperty this prop == undefined do
			messageBox ("SaveIniControlEvents\nUndefined construct property !\n\n"+ ((filterString( classof this as string )"(:")[2]) +"."+ prop )
	),

	/**  
	 */
	on create do
	(
		--print("Dialog_v.onCreate()")
		this._checkConstctructProperties #(#title)
		
		Ini	= Ini_v _path:Ini
		
		this._setMainRollout()
		
		this._setMainRolloutWidthAndHeight()
		
		this._setDialogGlobal()
		
		this.destroy()
	)
)
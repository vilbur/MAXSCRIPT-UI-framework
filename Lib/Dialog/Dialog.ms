
filein( getFilenamePath(getSourceFileName()) + "/../ConstructPropeties/ConstructPropeties.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../EventsList/EventsList.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../RolloutCreator/RolloutCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Layout/Layout.ms" )
filein( getFilenamePath(getSourceFileName()) + "/AutoRunEvents/AutoRunEvents.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../Ini/Ini.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Hotkeys/Hotkeys.ms" )

global DIALOG_PREVIOUS_STATE = undefined -- this should be in struct

if EVENT_DOCKED_ENABLED == undefined then
	global EVENT_DOCKED_ENABLED = true -- prevent crash on destroying  of dialog // RENAME THIS TO DIALOG_ENABLE_DOCKED_EVENT

global AUTORUN_EVENTS = #()

if HOTKEYS_GLOBAL == undefined then
	global HOTKEYS_GLOBAL = HotKeys_v()

/** Create dialog [Maxscript help](https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-816D257C-CD2D-4753-A792-6E7AEFAFA6A7)
  *
  * INHERETING OF WIDTH PROPERTY
  *  Dialog.width >>> Subrollouts.width >>> Rollout.width >>> Subrollouts.width >>> Rollout.width ....
  *
 */
struct Dialog_v
(

	/*------ EXTEND ROLLOUT ------*/

	include "MAXSCRIPT-UI-framework/Lib/Dialog/Rollout/RolloutBody.ms" --"./Rollout/RolloutBody.ms"

	public

	/* construct */
	Ini,

	/* options */

	/* dependency */
	AutoRunEvents 	= AutoRunEvents_v(),
	DialogHotkeys,
	--Menu	= DialogMenu_v Dialog:this,

	/* inherit */
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

	style_registred_dialog = #(
		#cui_floatable,	-- Dialogbar can float
		#cui_handles,	-- Show gripper handles when docked
		#cui_dock_vert	-- Can dock vertically (left and right)

		/* ALLOWED but not DEFAULT styles */
		--#cui_dock_all,	-- Dialog bar can dock on all 4 edges of the frame.
		--#cui_dock_horz,	-- Can dock horizontally (top and bottom)
		--#cui_dock_left ,	-- Can dock to the left
		--#cui_dock_top,	-- Can dock to the top
		--#cui_dock_right,	-- Can dock to the right
		--#cui_dock_bottom,	-- Can dock to the bottom
		--#cui_max_sized,	-- When this flag is specified, docking the dialogbar on the top causes the dialogbar to expand to the full window width, docked to bottom it expands to full window width minus command panel width.
	),

	min_size,

	/** Create dialog
	  *
	  * @param	integer	width	of dialog, minimal size of dialog also
	  * @param	integer	height	of dialog, minimal size of dialog also
	  * @param	[x,y]|#moue	name	description
	  * @param	name	origin	#WINDOW|#SCREEN origin of dialog position: Relative to 3Ds Max window|Absolute to screen
	  *
	  * TODO add params for max 2022
	 */
	function create width: height: pos: origin:#SCREEN bgcolor: fgcolor: bitmap: bmpstyle:#bmp_tile  style: modal: escapeEnable:false escapekey:true lockHeight:false lockWidth:true parent: =
	(
		--print "Dialog_v.create()"
		_RolloutCreator = RolloutCreator_v Ini:Ini

		this._setDialogMinimalSize(width)(height)

		this._setDialogSize(width)(height)

		_RolloutCreator.createRollout (this) width:width

		--CreateDialog (this.RCI.def)
		CreateDialog (this.RCI.def) pos:(this._getPosition(pos)(origin)) autoLayoutOnResize:true width:this.width height:this.height bgcolor:bgcolor fgcolor:fgcolor bitmap:bitmap bmpstyle:bmpstyle style:(if( style == unsupplied ) then this.style else style) modal:modal escapeEnable:escapeEnable lockHeight:lockHeight lockWidth:lockWidth parent:parent

		--this._setDialogGlobal()
		_RolloutCreator.SubolloutsCreator.addSubRollouts (this)

		this._setDockState()


		--AutoRunEvents.executeMacros()
		format ("\n\nDIALOG "+title+" CREATED\n\n" )
		CONTROL_BITMAPS_STORE = #() -- reset buffer array


	),

	/** Key press
	 */
	function hotKey hot_keys callback =
	(
		--format "\n"; print "Dialog_v.hotKey()"
		DialogHotkeys.add hot_keys callback
	),

	/** Register dialog bar
	 */
	function register =
	(
		--print "Dialog_v.register()"
		min_size_string = if min_size != undefined then " minSize:"+min_size as string +" " else ""

		execute ("cui.RegisterDialogBar "+ this.id +" "+min_size_string+" style:"+style_registred_dialog as string )
	),

	/** Unregister dialog bar
	 */
	function unregister =
	(
		--format "\n"; print "Dialog_v.unregister()"
		execute ("try(cui.UnRegisterDialogBar "+ id +")catch()")
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
			execute ("cui.DockDialogBar "+ id +" #cui_dock_"+ state as string )
		else
			execute ("cui.floatDialogBar "+ id )

		EVENT_DOCKED_ENABLED = true
	),

	/** Destroy dialog
	 */
	function destroy =
	(
		--print "Dialog_v.destroy()"
		--format "id	= % \n" id

		if  Ini.isDefined() then
			(IniSaver_v(Ini.getPath())).saveDialogDockState(id)

		this.unregister()

		EVENT_DOCKED_ENABLED = false

		execute ( "try( destroyDialog "+ id +" )catch()" )

		EVENT_DOCKED_ENABLED = true
	),



	/** Focus control
	 */
	function focus control_id =
	(
		--format "\n"; print "Dialog_v.focus()"
		setFocus (execute( id as string + "." + control_id as string ))
	),
	/** Send keys to rollout
	  * List of keys: https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.sendkeys?view=windowsdesktop-6.0#remarks
	  *
	  * @param	string	keys	to send E.G.: "^A" for Ctrl+A
	 */
	function sendKey keys =
	(
		--format "\n"; print "Dialog_v.sendKey()"
		( dotNetClass "System.Windows.Forms.SendKeys").sendWait keys
	),

	/** Get Hwnd of rollout
	 */
	function hwnd =
	(
		--format "\n"; print "Dialog_v.hwnd()"
		--for win in ( windows.getChildrenHWND 0 parent:#max) where win[5] == title do
			--return win[1]
		execute(dialog_id as string + ".hwnd" )
	),


	private


	--/** Set dialog id as global variable
	--  *
	--  * It is for unnecessary for make EverntFired working
	--  *
	-- */
	--function _setDialogGlobal =
	--(
	--	format "\n"; print "Dialog_v._setDialogGlobal()"
	--	format "id	= % \n" id
	--	--format "id	= % \n" (toUpper (id as string ))
	--	--execute("global "+ (toUpper (id as string )) )
	--	--execute("global GLOBAL_"+( id as string ) )
	--	execute("global "+( id as string ) )
	--	--execute("global GLOBAL_"+( id as string ) + this.RCI.def  )
	--	--format "GLOBAL_group_options	= % \n" GLOBAL_group_options
	--),

	/** Set minimal size of registered dialog
	  * 1) Use rollout size if defined
	  * 2) Use this.create() parameter
	  * 3) Use -1 if size is not defined
	 */
	function _setDialogMinimalSize width height =
	(
		--format "\n"; print "Dialog_v._setDialogSize()"
		if min_size == undefined then
		(
			min_width	= if this.width  != unsupplied then this.width  else (if width  != unsupplied then width else -1)
			min_height	= if this.height != unsupplied then this.height else (if height != unsupplied then height else -1)

			min_size = [ min_width, min_height ]
		)
	),

	/** Set main rollout size
	 */
	function _setDialogSize width height =
	(
		--format "\n"; print "Dialog_v._setDialogSize()"
		this.width  = this._getDialogSize( #width ) width
		this.height = this._getDialogSize( #height) height
	),
	/** Get size of dialog
	  *
	  * 1. get from ini
	  * 2. use defined width|height from this.create()
	  * 3. get default width|height from RolloutMain
	  *
	  * @param	name	dimension	#width|#height
	  * @param	integer	val	size in pixels
	 */
	function _getDialogSize dimension val  =
	(
		--print "Dialog_v._getDialogSize()"
		--format "this.width	= % \n" this.width
		--format "this.height	= % \n" this.height

		if( Ini.isDefined() and (dialog_size = Ini.load( id as string )("size")) != undefined) then
		(
			size = case dimension of
			(
				(#width):  dialog_size.x  as integer
				(#height): dialog_size.y  as integer
			)

			if val != unsupplied and size < val then val else size -- use paramater size, if ini saved size is less then, so dialog will not be smaller then width: parameter in this.create()
		)
		else if val != unsupplied then
			val --return defined val on creation

		else
			getProperty this dimension
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


	/** Get position
	  *
	  * 	1) Use Defined pos
	  * 	2) Use Ini position if exists and position is NOT DEFINED
	 */
	function _getPosition pos origin =
	(
		--format "\n"; print "Dialog_v._getPosition()"
		--format "pos	= % \n" pos
		if pos != unsupplied then
		(
			if pos == #mouse then
				pos = mouse.screenpos - [-1,0] -- offset postion of -1px, otherwise resize cursor is dispalyed on creation

			else if origin == #window then
				pos = this._getPositionRelativeToWindow(pos)

		)  else if Ini.isDefined() and (position_ini = Ini.load( id as string )("position")) != undefined  then
			pos = position_ini
			--pos = position_ini - [6,29] -- FIX y position of dialog, for some reason is saved position about few pixels more then postion of created dialog

		pos --return
	),

	/** Get position relative to Max window
	 */
	function _getPositionRelativeToWindow pos =
	(
		--print "Dialog_v._getPositionRelativeToWindow()"
		toolbar_height = 92

		if( pos == unsupplied ) then
			return pos

		win_pos = windows.getWindowPos (windows.getMAXHWND())

		[ win_pos.x+pos.x, win_pos.y+pos.y + toolbar_height]  --return
	),


	/** Load dock state from ini
	  * Ini postion is not used, if position of dialog is defined in this.create()
	 */
	function _setDockState =
	(
		--format "\n"; print "global._setDockState()"
		if Ini.isDefined() then
		(
			if( (dock_state = Ini.load( id as string )("dock_state")) == undefined or dock_state == "cui_floatable" ) then
				return false

			this.register()

			execute("cui.DockDialogBar "+ this.id +" #"+ dock_state )
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
		--format "\n"; print "Dialog_v.onCreate()"
		this._checkConstctructProperties #(#title)

		Ini	= Ini_v _path:Ini

		this._setId()

		this.destroy()

		--/*------ DEV restart timer ------*/
		if HOTKEYS_GLOBAL != undefined then
			global HOTKEYS_GLOBAL = HotKeys_v()

		/*------ ADD THIS TO SOMEWHERE ------*/
		DialogHotkeys = HOTKEYS_GLOBAL.addDialog(title)

	)
)
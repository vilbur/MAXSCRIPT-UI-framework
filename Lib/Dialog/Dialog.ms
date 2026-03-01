global createDialogFromCacheFile = undefined

if DIALOG_GLOBAL_DATA == undefined then
	global DIALOG_GLOBAL_DATA = Dictionary()

filein( getFilenamePath(getSourceFileName()) + "/../Menus/RcMenu/RcMenu.ms" )	--"./../Menus/RcMenu/RcMenu.ms"

filein( getFilenamePath(getSourceFileName()) + "/../ConstructPropeties/ConstructPropeties.ms" )	-- "./../ConstructPropeties/ConstructPropeties.ms"
filein( getFilenamePath(getSourceFileName()) + "/../Event/Event.ms" )	--"./../Event/Event.ms"
filein( getFilenamePath(getSourceFileName()) + "/../RolloutCreator/RolloutCreator.ms" )	-- "./../RolloutCreator/RolloutCreator.ms"
filein( getFilenamePath(getSourceFileName()) + "/../Ini/Ini.ms" )	-- "./../Ini/Ini.ms"

filein( getFilenamePath(getSourceFileName()) + "/Layout/Layout.ms" )	-- "./Layout/Layout.ms"
filein( getFilenamePath(getSourceFileName()) + "/Hotkeys/Hotkeys.ms" )	-- "./Hotkeys/Hotkeys.ms"


/*------------------------------------------------------------------------------
	DEFINE GLOBALS
--------------------------------------------------------------------------------*/
global DIALOG_PREVIOUS_STATE = undefined -- this should be in struct

if EVENT_DOCKED_ENABLED == undefined then
	global EVENT_DOCKED_ENABLED = true -- prevent crash on destroying  of dialog // RENAME THIS TO DIALOG_ENABLE_DOCKED_EVENT

global AUTORUN_EVENTS = Dictionary()

if HOTKEYS_GLOBAL == undefined then
	global HOTKEYS_GLOBAL = HotKeys_v()



/** Create dialog [Maxscript help](https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-816D257C-CD2D-4753-A792-6E7AEFAFA6A7)
  *
  *
  *
  * INHERETING OF WIDTH PROPERTY:
  *
  * 		Dialog.width >>> Subrollouts.width >>> Rollout.width >>> Subrollouts.width >>> Rollout.width ....
  *
  *
 */
struct Dialog_v
(
	/*------------------------------------------------------------------------------
		EXTEND ROLLOUT
	--------------------------------------------------------------------------------*/
	include "MAXSCRIPT-UI-framework/Lib/Dialog/Rollout/RolloutBody.ms" --"./Rollout/RolloutBody.ms"

	public

	/* construct */
	Ini,

	/* dependency */
	_RolloutCreator,
	DialogHotkeys,
	--Menu	= DialogMenu_v Dialog:this,

	/* inherit */
	/* properties */
	min_size,
	max_size,

	
	/* STYLE OF UNREGISTRED DIALOG */ 
	style = #(
		#style_border, 	-- Creates a window with a double border, but no title.
		#style_titlebar, 	-- Creates a dialog with a title bar.
		#style_sysmenu, 	-- Creates a window that has a window menu in its title bar.
		#style_resizing 	-- Creates a window with a thick frame that can be used to size the window.

		/* OTHER not DEFAULT styles */
		--#style_toolwindow, 	-- Creates a tool window, which has a title bar and is intended to be used as a floating toolbar. A tool window has a title bar that is shorter than a normal title bar, and the window title is drawn using a smaller font.
		--#style_sunkenedge, 	-- Specifies that a window has a 3D look in the form of a border with a sunken edge.
		--#style_minimizebox, 	-- Creates a window that has a minimize button.
		--#style_maximizebox, 	-- Creates a window that has a maximize button.
	),

	/* STYLE OF REGISTRED DIALOG https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-8A9EEAEF-DDD7-40E2-875A-D344BF1DB991 */ 
	style_registred_dialog = #(
		#cui_handles,	-- Show gripper handles when docked
		#cui_floatable	-- Dialogbar can float

		/* OTHER styles */
		--#cui_dock_all,	-- Dialog bar can dock on all 4 edges of the frame.
		--#cui_dock_vert,	-- Can dock vertically (left and right)
		--#cui_dock_horz,	-- Can dock horizontally (top and bottom)
		--#cui_dock_left ,	-- Can dock to the left
		--#cui_dock_top,	-- Can dock to the top
		--#cui_dock_right,	-- Can dock to the right
		--#cui_dock_bottom,	-- Can dock to the bottom
		--#cui_max_sized,	-- When this flag is specified, docking the dialogbar on the top causes the dialogbar to expand to the full window width, docked to bottom it expands to full window width minus command panel width.
	),

	/** CREATE DIALOG
	  *
	  * IMPORTANT:
	  *		param #width WORKS AS WIDTH OF DOCKED DIALOG
	  *
	  * TODO add params for max 2022
	  *
	  *
	  * @RETURN RolloutClass
	 */
	function create           \
		--create_dialog:true	\ -- boolean	create_dialog if false, then oly rollout without dialog is created
		width:	\ -- integer	width of dialog INTEGER: definded width | UNSUPPLIED: width auto or by ini | UNDEFINED: width auto even if ini is defined
		height:	\ -- integer|#AUTO	height
		pos:	\ -- [x,y]|#MOUSE	position of dialog when created
		origin: #WINDOW	\ -- #WINDOW|#SCREEN	origin of dialog position: Relative to 3Ds Max window | Absolute pos to screen
		bgcolor:	\
		fgcolor:	\
		bitmap:	\
		bmpstyle: #bmp_tile	\
		style:	\
		modal:	\
		escapeEnable: false	\
		escapekey:  true	\
		lockHeight: false	\
		lockWidth:  true	\
		dock: #(#LEFT, #RIGHT)	\ -- #( #LEFT, #RIGHT, #TOP, #BOTTOM )
		cache: false	\ -- load generated dialog for fast startup -- true: PRODUCTION | false: DEVELOPMENT
		parent: =
	(
		--format "\n"; print "Dialog_v.create()"
		timer_createRollout = timeStamp()

		this.destroy()
		
		cache_file_path = this._getPathToCacheFile()

		
		/* WIDTH & HEIGHT MUST BE INTEGER - otherwise height of  dialog doesn't work */ 
		if superClassOf width  == Number then width  = width as integer
		if superClassOf height == Number then height = height as integer
		
		/* DIALOG SIZE */ 
		this._setDialogMinimalSize()
		this._setDialogSizeByIni()
		this._setWithByMinimalSize()

		/* HEIGHT */ 
		height = this._getHeightOnCreate(height)
		/* WIDTH */ 
		if classOf width != integer then
			width = this.width
			
		/*------------------------------------------------------------------------------
			GENERATE DIALOG
		--------------------------------------------------------------------------------*/
		if not cache or not doesFileExist (cache_file_path) then
		(
			format "\n**** NO CACHE\n"
			_RolloutCreator = RolloutCreator_v Ini:Ini DEBUG:DEBUG
	
			--DEBUG = true
			if this.DEBUG then timer_all = timestamp()
			

			/*------------------------------------------------------------------------------
				CREATE MAIN ROLLOUT AND NESTED ROLLOUTS
			--------------------------------------------------------------------------------*/
			
			_RolloutCreator.createRollout (this) width:width  -- create nested rollouts
			--if this.DEBUG then format "createRollout % ms\n" ((timestamp()) - timer_all)
	
			/*------------------------------------------------------------------------------
				CREATE DIALOG
			--------------------------------------------------------------------------------*/
			
			CreateDialog (this.RCI.def) \
				width:	width                          	\
				height:	height                          	\
				pos:	(this._getPosition(pos)(origin))	\
				bgcolor:	bgcolor	\
				fgcolor:	fgcolor	\
				bitmap:	bitmap	\
				bmpstyle:	bmpstyle	\
				style:	(if( style == unsupplied ) then this.style else style)	\
				modal:	modal	\
				autoLayoutOnResize:	true	\
				escapeEnable:	escapeEnable	\
				lockHeight:	lockHeight	\
				lockWidth:	lockWidth	\
				parent:	parent
			--if this.DEBUG then format "CreateDialog % ms\n" ((timestamp()) - timer_all)

			/*------------------------------------------------------------------------------
				ADD SUBROLLOUTS TO ROLLOUT
			--------------------------------------------------------------------------------*/
			
			_RolloutCreator.SubolloutsCreator.addSubRollouts (this)
			--if this.DEBUG then format "addSubRollouts % ms\n" ((timestamp()) - timer_all)
			
			/* CACHE FILE */ 
			this.writeToCacheFile cache_file_path width height 

			/*------------------------------------------------------------------------------
				POST CREATE
			--------------------------------------------------------------------------------*/
			
			/* SET DOCK STATES */ 		
			this._setDockStyle (style) (dock)
		
			/* DOCK DIALOG */ 
			this._setDockState()

			this.RolloutResizer.fitSlotsToDialog(this.RCI.def)
			
			/* SET DIALOG TO GLOBAL CONTAINER OF DIALOGS OF FRAMEWORK */ 
			DIALOG_GLOBAL_DATA[this.id] = DialogGlobalData_v(this.RCI.def)(this)

			/* EXECUTE AUTORUN EVENTS OF CONTROLS */ 
			this._executeAutorunEvents()

			/* RESET BITMAPS */ 
			CONTROL_BITMAPS_STORE = #() -- reset buffer array

			FORMAT ("\n\nDIALOG \""+ id as string +"\" HAS BEEN CREATED\n\n" )
	
			format "\n\n====== Dialog Created in %ms\n\n" ((timestamp()) - timer_createRollout)
			
			RCI.def --return
		)
		/*------------------------------------------------------------------------------
			USE CACHE
		--------------------------------------------------------------------------------*/
		else
		(
			format "\n**** USE CACHE\n"
			format "cache_file_path: %\n" cache_file_path
			filein cache_file_path
			
			dialog_rollout = createDialogFromCacheFile width height
			
			/* SET DOCK STATES */ 		
			this._setDockStyle (style) (dock)
			
			/* DOCK DIALOG */ 
			this._setDockState()
			
			/* CAST ROLLOUT TO VARIABLE */ 
			--dialog_rollout = execute ( this.id as string )
			
			this.RolloutResizer.fitSlotsToDialog( dialog_rollout )
			
			format "\n\n====== Dialog Created in %ms FROM CACHE FILE: %\n\n" ((timestamp()) - timer_createRollout) cache_file_path
			
			dialog_rollout --return
		)
		
	),

	/** Create rollout
	 */
	function createRollout _Rollout =
	(
		--format "\n"; print "Dialog_v.createRollout()"
		_RolloutCreator.createRollout (_Rollout) width:width -- create nested rollouts
	),

	/** Update rollout
	 */
	function updateRollout _Rollout =
	(
		--format "\n"; print "Dialog_v.updateRollout()"
		/** Join array to string
		 */
		function arrayToString arr delimeter = ( _string = ""; for item in arr do _string += item as string  + delimeter; substring _string 1 (_string.count-delimeter.count))

		local rollout_index

		temporary_removed_rollouts = #()

		id_split	= filterString ( _Rollout.getFullId() ) "."

		deleteItem id_split id_split.count

		slot_id = arrayToString id_split "."

		_subrollouts = execute ( slot_id + ".Rollouts" )

		for i = 1 to _subrollouts.count while rollout_index == undefined where _subrollouts[i].name == _Rollout.id as string do rollout_index = i

		--format "slot_id: %\n" slot_id
		--format "_Rollout.id: %\n" _Rollout.id
		--format "rollout_index: %\n" rollout_index

		--this.createRollout(_Rollout)

		/* REFRESH ROLLOUT - remove and add rollouts aftter given rollout */
		if rollout_index != undefined then
		(
			/* GET SUBROLLOUTS AFTER GIVEN ROLLOUT */
			for i = rollout_index to _subrollouts.count do
				append temporary_removed_rollouts _subrollouts[i].name

			/* REMOVE ROLLOUTS */
			for rollout_id in temporary_removed_rollouts do
				execute ("RemoveSubRollout "+ slot_id + " " + rollout_id )

			/* CREATE ROLLOUT */
			this.createRollout(_Rollout)

			/* ADD ROLLOUTS */
			for rollout_id in temporary_removed_rollouts do
				execute ("AddSubRollout "+ slot_id + " " + rollout_id )
		)
		else
		(
			this.createRollout(_Rollout)

			execute ("AddSubRollout "+ slot_id + " " + _Rollout.id as string )
		)
		--	--print ("AddSubRollout "+ slot_id + " " + _Rollout.id as string )

	),

	/** Key press
	 */
	function hotKey hot_keys callback =
	(
		--format "\n"; print "Dialog_v.hotKey()"
		DialogHotkeys.add hot_keys callback
	),

	/** Register dialog bar
	  
	  @param array	style
	 */
	function register style: =
	(
		print "Dialog_v.register()"

		min_size = if min_size != undefined then min_size as string else "[-1,-1]"
		max_size = if max_size != undefined then max_size as string else "[-1,-1]"
		--format "width: %\n" width
		--format "MIN_SIZE: %\n" min_size
		--format "MAX_SIZE: %\n" max_size
		format "STYLE: %\n" style_registred_dialog

		--execute ("cui.RegisterDialogBar "+ this.id +" minSize:"+min_size+" maxSize:"+max_size+" style:"+style_registred_dialog as string )
		--execute ("cui.RegisterDialogBar "+ this.id +" minSize:"+min_size+" style:"+style as string )
		execute ("cui.RegisterDialogBar "+ this.id +" minSize:"+min_size+" style:"+( this.style_registred_dialog as string  ) )

	),

	/** Unregister dialog bar
	 */
	function unregister =
	(
		--format "\n"; print "Dialog_v.unregister()"
		execute ("try( cui.UnRegisterDialogBar "+ id +" )catch()")
	),
	
	/** Is registered
	 */
	function isRegistered =
	(
		--format "\n"; print "if.isRegistered()"
		try(
			execute ("cui.getDockState "+ this.id )
			
			true --return
		)
		catch
		(
			false --return
		)
	),

	/** Is docked
	 */
	function isDocked =
	(
		--format "\n"; print "if.isDocked()"
		try(
			execute ("cui.getDockState "+ this.id ) != #cui_floatable 
		)
		catch
		(
			false --return
		)
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

		execute ( "try( destroyDialog "+ id as string +" )catch()" )

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
		execute( id as string + ".hwnd" )
	),


	/** Test if dialog is created
	 */
	function exists =
	(
		--format "\n"; print "Dialog_v.exists()"
		execute( "GetDialogPos " + id as string ) != [0,0]
	),


	/** Get height of maximized viewport
	  * Good to find out height of docked dialog
	 */
	function getViewportHeight =
	(
		--print "Dialog_v.getViewportHeight()"
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


	/*
	Function to align 2 registered dialogs next to each other by their bottom borders
	*/
	function alignToDialog align_to_dialog side:#LEFT height:#TOP =
	(
		--format "\n"; print "Dialog_v.alignToDialog()"
		--format "align_to_dialog: %\n" align_to_dialog
		
		/** Is registered
		 */
		function _isRegistered dialog_id =(try(execute ("cui.getDockState "+ dialog_id as string ); true)catch(false))
		
		
		if align_to_dialog != undefined and GetDialogPos align_to_dialog != [0,0] then
		(
			if (aligned_is_registered = this.isRegistered()) then
				this.unregister()
		
			align_to_is_registered = _isRegistered align_to_dialog.name
			
			aligned_pos	= [ 0, 0 ]

			align_to_pos  = GetDialogPos align_to_dialog
			align_to_size = GetDialogSize align_to_dialog
			
			aligned_size = execute ( "GetDialogSize "+ id as string )
	
			/*------------------------------------------------------------------------------
				GET POSITION
			--------------------------------------------------------------------------------*/
			aligned_pos.x = case side of
			(
				#LEFT:  align_to_pos.x - aligned_size.x
				#RIGHT: align_to_pos.x + align_to_size.x
			)
			
			aligned_pos.y = case height of
			(
				#TOP:    align_to_pos.y
				#BOTTOM: align_to_pos.y + align_to_size.y - aligned_size.y
			)
			
			/*------------------------------------------------------------------------------
				IF ALIGN TO IS REGISTRED
			--------------------------------------------------------------------------------*/
			if align_to_is_registered and not aligned_is_registered then
			(
				aligned_pos.x -= case side of
				(
					#LEFT:  14
					#RIGHT: 2
				)
				
				aligned_pos.y -= case height of
				(
					#TOP:  29
					#BOTTOM: 26
				)	
				
			)
			/*------------------------------------------------------------------------------
				IF ALIGNED IS REGISTRED
			--------------------------------------------------------------------------------*/
			if aligned_is_registered and not align_to_is_registered then
			(
				aligned_pos.x += case side of
				(
					#LEFT: -4
					#RIGHT: 8
				)
				
				aligned_pos.y += case height of
				(
					#TOP:  0
					#BOTTOM: -3
				)	
			)

			/*------------------------------------------------------------------------------
				IF BOTH ARE REGISTRED
			--------------------------------------------------------------------------------*/
			if aligned_is_registered and align_to_is_registered then
			(
				aligned_pos.x += case side of
				(
					#LEFT: -17
					#RIGHT: 6
				)
				
				aligned_pos.y += case height of
				(
					#TOP:   -29
					#BOTTOM: -29
				)	
			)
			
			/* UPDATE ALIGNED POSTION */ 
			execute ( "SetDialogPos "+ id as string + " " + aligned_pos as string )
			
			/* REGISTER */ 
			if aligned_is_registered then
				this.register()
		)
	),


	private

	/** Set dialog default size
	  *
	  */
	function _setDialogDefaultWidth =
	(
		--format "\n"; print "if._setDialogDefaultWidth()"
		if superClassOf this.width != Number then
			this.width  = 256
	),

	/** Set minimal size of registered dialog
	 */
	function _setDialogMinimalSize =
	(
		--format "\n"; print "Dialog_v._setDialogMinimalSize()"
		--format "MIN_SIZE:	% \n" min_size
		--format "this.height: %\n" this.height
		
		if not this.isDefined (this.min_size) then
		(
			min_width	= if this.isDefined (this.width)  then this.width  else -1
			min_height	= if this.isDefined (this.height) then this.height else -1

			min_size = [ min_width, min_height ]
		)
		--format "MIN_SIZE:	% \n" min_size
	),

	/** Set size of dialog
	 */
	function _setDialogSizeByIni =
	(
		--format "\n\n"; print "Dialog_v._setDialogSizeByIni()"

		if ( ini_size = this._getSizeFromIni() ) != undefined and not this._isIniDocked() then
		(
			--format "INI_SIZE:	% \n" INI_SIZE
			this.width  = ini_size.x
			this.height = ini_size.y
		)
	),

	/** Set with by minimal size
	 */
	function _setWithByMinimalSize =
	(
		--format "\n"; print "if._setRolloutWithByMinimalSize()"
		if not this.isDefined (this.width) then
			width = min_size.x
		--format "width: %\n" width
	),

	/** Get ini dock state
	 */
	function _isIniDocked =
	(
		--format "\n"; print "if.getIniDockState()"
		Ini.isDefined() and (dock_state = Ini.load( id as string )("dock_state")) != undefined and dock_state != "cui_floatable"
	),

	/** Get size on create
	  */
	function _getHeightOnCreate val =
	(
		--format "\n"; print "if._getHeightOnCreate()"
		--format "size_type:	% \n" size_type
		--format "val: %\n" val
		--format "classOf val:	% \n" (classOf val)

		if val == unsupplied then
			this.height	-- size set by this.width|this.height or ini value

		else if classOf val != integer then
			case val of
			(
				#AUTO:	unsupplied	-- size set auto even if ini is exists
				undefined:	unsupplied	-- size set auto even if ini is exists
				--unsupplied:	getProperty this size_type	-- size set by this.width|this.height or ini value
				#VIEWPORT:	this.getViewportHeight()
				default:	unsupplied
			)
		else
			val --return value if size is defined

	),

	/** Get size from ini
	  */
	function _getSizeFromIni =
	(
		--format "\n"; print "if._getSizeFromIni()"
		if( Ini.isDefined() and (ini_size = Ini.load( id as string )("size")) != undefined) then
			ini_size --return
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
			if pos == #MOUSE then
				pos = mouse.screenpos - [-1,0] -- offset postion of -1px, otherwise resize cursor is dispalyed on creation

			else if origin == #WINDOW then
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

	/** Execute autorun events
	  *
	  */
	function _executeAutorunEvents =
	(
		--format "\n"; print "Dialog_v._executeAutorunEvents()"
		--format "\n-----------\nDICTIONARY:AUTORUN_EVENTS:%\n" AUTORUN_EVENTS; for data_pair in AUTORUN_EVENTS do format "%:	%\n" data_pair.key data_pair.value

		 for data_pair in AUTORUN_EVENTS do
			try(
				
				--format "\nEXECUTE AUTORUN EVENT: %\n" (data_pair.value)
				
				execute data_pair.value
	
			 )catch(
				--format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
				--format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
				--format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
				--format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())
			 )
	),

	/** Is defined
	  */
	function isDefined val =
	(
		val != undefined and val != unsupplied
	),

	/** Check if required properties are defined when an instance of the struct is created.
	 * @example __construct = #( #property_name )
	 */
	function _checkConstctructProperties __construct =
	(
		for prop in __construct where getProperty this prop == undefined do
			messageBox ("SaveIniControlEvents\nUndefined construct property !\n\n"+ ((filterString( classof this as string )"(:")[2]) +"."+ prop )
	),

	/** Set default style
	 */
	function _setDefaultStyle =
	(
		--format "\n"; print "if._setDefaultStyle()"
		--format "this.title: %\n" this.title

		if this.title == "" then
		(
			deleteItem this.style ( findItem this.style #style_titlebar )
			deleteItem this.style ( findItem this.style #style_sysmenu )
			deleteItem this.style ( findItem this.style #style_border )
        )
    ),

     /** Get style
	  
		#cui_dock_vert,	-- Can dock vertically (left and right)
		#cui_dock_horz,	-- Can dock horizontally (top and bottom)
		#cui_dock_left ,	-- Can dock to the left
		#cui_dock_top,	-- Can dock to the top
		#cui_dock_right,	-- Can dock to the right
		#cui_dock_bottom,	-- Can dock to the bottom
	
		convert #( #LEFT ) >>> #( #CUI_DOCK_LEFT )
		
	 */
	function _setDockStyle style dock_states =
	(
		format "\n"; print "Dialog_v._setDockStyle()"
		format "dock_states: %\n"dock_states
		format "style: %\n" style
		--format "this.style: %\n" this.style
		format "this.style_registred_dialog: %\n" this.style_registred_dialog
		--
		if style == unsupplied then 
		(
			if classOf dock_states != Array then
				dock_states = #(dock_states)
			
			/* SET ALLOWED DOCK STATE E.G.: #LEFT >>> #CUI_DOCK_LEFT */ 
			for state in dock_states do
				appendIfUnique this.style_registred_dialog ( ( "cui_dock_" + state as string ) as name )
			format "this.style_registred_dialog: %\n" this.style_registred_dialog
			this.style_registred_dialog as string --return
		)
		else
			style as string --return
	),
		
	function _getPathToCacheFile =
	(
		--format "\n"; print "Dialog_v._getPathToCacheFile()"
		if Ini.isDefined() then
		(
			ini_path = Ini.getPath()
			
			(getFilenamePath ini_path) + (getFilenameFile ini_path) + "-cache" + ".ms"
		)
		else
			getDir #TEMP + "\\UI-Framework\\Dialog-Cache\\"  + this.id + "-cache" + ".ms"
	),
	
	/** Write to deff file
	 */
	function writeToCacheFile cache_file_path width height =
    (
        format "\n"; print "Dialog_v.writeToCacheFile()"
		--format "\n"; print "if.writeToCacheFile()"
		
		subrollouts_def	= ""
        addSubRollouts_def = ""
		
        addSubRollouts_array = _RolloutCreator.SubolloutsCreator.addSubRollouts_definition
		
		--for nested_level in _RolloutCreator.SubolloutsCreator.addSubRollouts_definition do
        for nested_level = 1 to addSubRollouts_array.count do
             addSubRollouts_def += addSubRollouts_array[nested_level]
		
		fn_definition   	= "function createDialogFromCacheFile width height =\n(\n"
		create_dialog_str	= "CreateDialog " + this.id as string + " width:width height:height \n"
		destroy_dialog_str	= "try( destroyDialog "+ this.id as string +" )catch()\n\n"
		
		add_rollouts_str	= "try(\n"+ addSubRollouts_def +")catch()\n\n"
		
		return_rollout		= this.id as string + "-- return" 
		
		deleteFile cache_file_path

        try(
			
			for rollout_id in _RolloutCreator.RolloutsDefinition.keys do
				subrollouts_def += _RolloutCreator.RolloutsDefinition[rollout_id]
			
            makeDir ( getFilenamePath( cache_file_path )  ) all:true

            cache_file = createFile cache_file_path

            if cache_file != undefined do
            (
                format "WRITE CACHE FILE: %\n" cache_file_path
				--format "subrollouts_def: %\n" subrollouts_def

                FORMAT "%\n" fn_definition 			to:cache_file
                FORMAT "%\n" destroy_dialog_str 	to:cache_file
                FORMAT "%\n" subrollouts_def 	to:cache_file
                FORMAT "%\n" create_dialog_str  	to:cache_file
                FORMAT "%\n" add_rollouts_str    	to:cache_file
                FORMAT "%\n" return_rollout 		to:cache_file
				
                FORMAT ")" 	to:cache_file
				
				close cache_file
			)
			
		)catch(
			
			if cache_file != undefined do
				close cache_file
			
			format "ERROR TO WRITE CACHE FILE: %\n" cache_file_path
		)
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "Dialog_v.onCreate()"
		--format "title: %\n" title
		--format "this.width: %\n" this.width
		this._checkConstctructProperties #(#title)

		Ini	= Ini_v _path:Ini

		this._setId()
		this._setDefaultStyle()

		(IniSaver_v(this.Ini.getPath())).saveRollout(this.id)

		this._setDialogDefaultWidth()

		--/*------ DEV restart timer ------*/
		if HOTKEYS_GLOBAL != undefined then
			global HOTKEYS_GLOBAL = HotKeys_v()

		/*------ ADD THIS TO SOMEWHERE ------*/
		DialogHotkeys = HOTKEYS_GLOBAL.addDialog(title)
	)
)
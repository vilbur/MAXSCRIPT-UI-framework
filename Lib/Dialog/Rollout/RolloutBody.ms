
	/* construct */
	title,
	width  = unsupplied, -- unsupplied for compatibility with CreateDialog()
	height = unsupplied,
	--height = 999,


	/* properties */
	id,
	parent_rollout_id,

	/* dependency */
	_Controls	= #(),
	Events	= EventsList_v(),	-- "./../../EventsList/EventsList.ms"
	RolloutResizer	= RolloutResizer_v(),	-- "./RolloutResizer/RolloutResizer.ms"

	/* extended control params */
	add_locals	= #(), -- TODO: REPLACE ARRAY WITH DICTIONARY  #(#variable_name1, init_value1, #variable_name2, init_value2)	// used in ControlCreator_v._addLocalVariablesToRollout 	"../../../RolloutCreator/ControlCreator/ControlCreator.ms"
	add_text	= "",  -- string added to rollout	// used in ControlCreator_v._addFunctionsVariablesToRollout	"../../../RolloutCreator/ControlCreator/ControlCreator.ms"

	RCI, -- Maxscript native RolloutCreator  https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_5FC5036F_E2D7_46C9_9AFA_7B3550B9F254_htm

	/* sotore */
	--temporary_created = false,

	/* inhered */
	--Layout,

	/* developent */
	DEBUG = false,
	--DEBUG = true,

	/** Wrapper to create new rollout in first slot
	 */
	function Roll title id: height: =
	(
		--format "\n"; print "RolloutBody.Roll()"
		Subrollouts = if (Subrollout_slots = this.getSubrollouts()).count > 0 then Subrollout_slots[1] else this.Rollouts()
		--format "Subrollouts:	% \n" Subrollouts
		Subrollouts.Roll title id:id height:height  --return
	),

	/** Controls
	 */
	function Controls group:undefined =
	(
		--print "RolloutBody.controls()"
		local Controls = Controls_v group:group rollout_id:id

		append _Controls Controls

		Controls --return
	),

	/** Get new slot of subrollouts
	 */
	function Subrollouts slot: width: height: =
	(
		--format "\n"; print "RolloutBody.Subrollouts()"
		--format "this.width: %\n" this.width
		--format "width:      %\n" width
		--format "height	= % \n" height

		--local Subrollouts = Subrollouts_v slot:(slot as name ) parent_rollout_id:(this.getFullId()) width:(if width != unsupplied then width else this.width) height:height
		local Subrollouts = Subrollouts_v slot:slot parent_rollout_id:(this.id) width:(if width != unsupplied then width else this.width) height:height DEBUG:DEBUG

		append _Controls Subrollouts

		Subrollouts --return
	),

	/** FRONT END ALIAS for user this.Subrollouts()
	 */
	function Rollouts slot: height: =
	(
		--print "RolloutBody.Rollouts()"
		--format "width	= % \n" width
		--format "height	= % \n" height
		this.Subrollouts slot:slot height:height --return
	),

	/** Get Subrollouts_v or RolloutBody
	  * works for nested subrollouts as well
	  *
	  * @param	name	id	id of rollout or subrollout slot
	  *
	  * @return	object Subrollouts_v|RolloutBody
	 */
	function get id =
	(
		--format "\n"; print "RolloutBody.get()"
		--format "this.id	= % \n" this.id
		--format "id	= % \n" id
		--format "this.getSubrollouts()	= % \n" (this.getSubrollouts())
		if id == this.id then
			return this --return

		else
			for _Subrollouts in this.getSubrollouts() where (found_rollout = _Subrollouts.get (id)) != undefined do
				return found_rollout

		undefined --return
	),

	/** Addlocal
	 */
	function addlocal key val =
	(
		--print "RolloutBody.addlocal()"
		append add_locals (key as name )

		append add_locals val
	),

	/** Add text
	 */
	function addText _text =
	(
		--print "RolloutBody.addText()"
		add_text += _text
	),

	/** Get full path id to rollout
	  *
	  * @return	string E.G.: dialog_rolllout.Subrollouts.rollout_a.Subrollouts.subrollout_a
	 */
	function getFullId =
	(
		--format "\n"; print "RolloutBody.getFullId()"
		--format "id:	% \n" id
		--format "parent_rollout_id:	% \n" parent_rollout_id

		if ( parent_rollout_id != undefined ) then
			parent_rollout_id as string +"."+ id as string --return

		else
			id as string --return
	),

	/** Is dialog
	 */
	function isDialog =
	(
		--format "\n"; print ".isDialog()"
		parent_rollout_id == undefined
	),

	/*------------------------------------------------------------------------------
		RENAME METHODS BELOW TO PRIVATE
	--------------------------------------------------------------------------------*/

	/** Get Subrollouts_v from this._Controls
	 */
	function getSubrollouts =
	(
		--format "\n"; print "RolloutBody._getSubrolouts()"
		--format "_Controls	= % \n" _Controls
		for _Control in _Controls where hasProperty _Control "slot" collect _Control --return

	),

	/** Test if Rollout has any subrollouts
	 */
	function hasSubrollouts =
	(
		--format "\n"; print "RolloutBody.hasSubrollouts()"
		--subrollouts_count = (this.getSubrollouts()).count

		(this.getSubrollouts()).count > 0
	),

	/** Get nested level of rollout
	  *
	  * 1) Split full id by "."
	  * 2) Divide by 2 to remove subrollouts slots
	  * 3) Minus 1 to remove DialogRollout level
	 */
	function getNestedLevel = -- split parent_rollout_id and slot id E.G.: ROLLOUT_Parent.children
	(
		--format "\n"; print "RolloutBody.getNestedLevel()"
		--format "this.GETFULLID()	= % \n" (this.getFullId())
		--format "parent_rollout_id	= % \n" parent_rollout_id
		--if( parent_rollout_id == undefined ) then 0 else ((filterString (this.getFullId()) ".").count - 1 ) / 2 --return
		if( parent_rollout_id == undefined ) then 0 else floor ((filterString (this.getFullId()) ".").count  / 2) - 1 --return
	),



	
	/** Save Rollout Definition to file
	  * 
	 */
	function saveRolloutDefinitionToCache def =
	(
		--format "\n"; print "RolloutBody.saveDefition()"

		def_file = this._getDefinitionFilePath()
		
		if doesDirectoryExist (dir = getFilenamePath(def_file)) then
			deleteFile def_file
		else
			makeDir dir all:true

		def_filestream = createFile def_file

		--format "def_file: %\n" def_file
		
		--def	= ( dotNetObject "System.Text.RegularExpressions.Regex" "\"" ).Replace def "\\\""
		
		
		format "%" def to:def_filestream
		
		close def_filestream
	),
	
	/** Load definition
	 */
	function loadRolloutDefinitionFromCache =
	(
		--format "\n"; print "RolloutBody.loadDefinition()"
		def_file = this._getDefinitionFilePath()

		if (file_exists = doesFileExist def_file) then
		(
			def_filestream = openFile def_file mode:"rS"
			--format "def_filestream: %\n" def_filestream
			
			rci_loaded = ""

			try(
				rci_loaded = execute def_filestream
				
				close def_filestream
			)
			catch
				close def_filestream
			
			rci_loaded --return	
		)
	),
	
	/** Set Rollout Createor
	 */
	function setRCI =
	(
		--format "\n"; format "RolloutBody.setRCI() % " this.id
		this.RCI	= RolloutCreator (this.id) ( this._getTitleString() )
	),
	

	private
	
	/** Get definition file path
	  * 
	  * FILE PATH E.G.:
	  *		"C:\Users\%username%\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\temp\UI-Framework\RolloutCreator-Cache\{ROLLOUT_ID}.ms"
	  * 
	 */
	function _getDefinitionFilePath =
	(
		--format "\n"; print "RolloutBody._getDefinitionFilePath()"
		--format "id: %\n" id
		--dialog_dir = if this.isDialog() then id else parent_rollout_id
		
		dir = getDir #temp + "\\UI-Framework\\RolloutCreator-Cache\\"
		
		dir + "\\" + id + ".ms" --return
	),


	/** Set id by title if not defined
	 */
	function _setId =
	(
		--print "RolloutBody._setId()"
		--format "id	= % \n" id

		/** Generate id from title
		 */
		if ( id == undefined or id == unsupplied ) then
		(
			id = toLower title

			if not matchPattern id pattern:@"rollout*" then
				id  = if parent_rollout_id == undefined then "DIALOG_" + id else "ROLLOUT_" + id -- add prefix

			--id = substituteString title "Rollout" "" -- add "Rollout" prefix if does exists aleready

			id = substituteString ( trimRight ( trimLeft id )) " " "_" -- replace whitespace with underscore

			id = this._repleaceCharacters "^([^A-Za-z]*)" "" -- remove any character except letters from start of string, variable MUST NOT starts with number E.G.: "1_FooDialog|_FooDialog" >>> "FooDialog"

			id = this._repleaceCharacters "[^A-Za-z0-9_]" "_" -- remove invalid characters from whole string E.G.: "Butt@n_&_1" >>> "Button_1"

			id = this._repleaceCharacters "[_]+" "_" -- remove multiple underscores E.G.: "button___1" >>> "button_1"

			this.validateid()
		)
		--format "id:	% \n" id
		id = id as name
	),


	/** Validate title
	 */
	function validateid =
	(
		--format "\n"; print "Subrollouts_v.validateTitle()"
		if matchPattern id pattern:@"rollout" or classof ( executed_id = execute (id) ) != UndefinedClass and classof ( executed_id ) != RolloutClass and classof ( executed_id ) != RolloutClass then
		(
			id_prefixed = "ROLLOUT_" + id

			--format "classof executed_id	= % \n" (classof executed_id)
			--print ("WARNING: Rollout id \"" + id + "\" is MaxScript variable, Rollout id has been changed to \"" + id_prefixed + "\"\n\n\n")
			format "\n"
			print ("WARNING: Rollout id \"" + id + "\" is classof "+(classof executed_id) as string+", Rollout id has been changed to \"" + id_prefixed + "\"")
			format "\n"
			id  = id_prefixed
		)
	),


	/** Get title of rollout
	  *
	  * @return string title with whitespace between each character E.G.: "ROLLOUT TITLE" >>> "R O L L O U T   T I T L E"
	 */
	function _getTitleString =
	(
		--format "\n"; print "RolloutCreator_v._getTitleString()"

		/* modify only title of rollout, NOT title of dialog */
		if this.parent_rollout_id != undefined then
			( dotNetObject "System.Text.RegularExpressions.Regex" "(.)" ).Replace this.title "$1 "

		else
			this.title --return Dialog title as it is
	),

	/** _repleace string
	 */
	function _repleaceCharacters search replace =
	(
		( dotNetObject "System.Text.RegularExpressions.Regex" search ).Replace ( id ) replace  --return
	),

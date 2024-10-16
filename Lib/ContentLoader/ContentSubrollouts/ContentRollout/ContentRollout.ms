filein( getFilenamePath(getSourceFileName()) + "/PathsLoader/PathsLoader.ms" )	-- "./PathsLoader/PathsLoader.ms"
filein( getFilenamePath(getSourceFileName()) + "/ScriptFile/ScriptFile.ms" )	-- "./ScriptFile/ScriptFile.ms"
filein( getFilenamePath(getSourceFileName()) + "/../ContentSubrollouts.ms" )	-- "./../ContentSubrollouts.ms"

/** Create rollout from dir containing ".ms" & ".mcr" files
 *
 * @property	string	dir	Path to dir
 * @property	string	title	Name of rollout
 *
 */
struct ContentRollout_v
(
	__construct = #( #path ),

	/* construct */
	path,

	/*  properties */
	title,

	Subrollouts_and_Controls = #(), -- store groupboxes and rollouts

	ini_file, -- path to ini file in Rollout folder

	PathsLoader,

	/** Create and add Rollouts and Controls to UI
	 */
	function addToUi Subrollouts =
	(
		--print ( "ContentRollout_v.addToUi (Subrollouts:" + Subrollouts.slot as string +")"  )
		--format "ini_file	= % \n" ini_file
		Rollout_new	= Subrollouts.Roll title -- get new rollout

		this._setRolloutPropertiesFromIniFile(Rollout_new)

		for Subrollouts_or_Controls in Subrollouts_and_Controls do
			Subrollouts_or_Controls.addToUi Rollout_new
	),

	/** Get new instance of This
	 */
	function createNewRollout path ini_file =
	(
		ContentRollout_v path:path ini_file:ini_file --return
	),

	private


	/** _get controls and rollouts
	 */
	function _initLoadContentFromDir =
	(
		--print ("ContentRollout_v._initLoadContentFromDir() " + title)
		for path in (PathsLoader.getSubrolloutsAndControlsPaths()) do
			append Subrollouts_and_Controls	(this._addSubrolloutOrControlBox path)
	),

	/** _add subrollout or control box
	 */
	function _addSubrolloutOrControlBox path =
	(
		if (this._isDir path) then
			this._createSubrolloutsSlots path
		else
			this._getFileContent path
	),

	/** _if path is dir
	 */
	function _createSubrolloutsSlots path =
	(
		--format "\n"; print "ContentRollout_v._createSubrolloutsSlots()"
		--format "ini_file	= % \n" ini_file
		ContentSubrollouts_v path:path RolloutParrent:this ini_file:ini_file    -- return
	),

	/** If path is file
	 */
	function _getFileContent path =
	(
		--filein path

		ScriptFile_Content_v path:path	-- return
	),


	/** Set props for Rollout from ini file
	 */
	function _setRolloutPropertiesFromIniFile &_Rollout =
	(
		--format "\n"; print "ContentRollout_v._setRolloutPropertiesFromIniFile()"
		--format "_Rollout.id	= % \n" _Rollout.id

		if ini_file != undefined and (hasINISetting ini_file ( _SECTION = _Rollout.id as string )) then
		(
			for key in (getINISetting ini_file _SECTION ) do
			(
				prop_name = key as name

				val_ini = getINISetting ini_file _SECTION key

				val = if val_ini as number != undefined then val_ini as number else val_ini

				if hasProperty _Rollout prop_name  then
					setProperty _Rollout prop_name val
				else
					format "-----------------\n\nERROR: Set property with ini file %\n\nRollout has not property: %\n\n-----------------" ini_file prop_name
			)
		)

		_Rollout --return
	),

	/** _is dir
	 */
	function _isDir path =
	(
		getFilenameType path == "" --return
	),

	/**
	/** Set rollout title by folder name E.g.: "1-Rollout_A" >> "Rollout A"
	  *
	  * Replace underscore "_" with whitespace " " E.G.: This_is_test" >>> "This is test"
	  *
	  *
	  * Remove invalid characters, valid characters: "A-Za-z0-9-_" WAS DISABLED FOR USE ABILITY TO USEE ASCII CHARACTERS
	 */
	function _setRolloutTitle =
	(
		--print ("ContentRollout_v._sanitizeTitle() " )
		title = filenameFromPath path

		title = trimRight title "\\" --remove backslash from directory name

		title = ( dotNetObject "System.Text.RegularExpressions.Regex" "^rollout-" ).Replace title "" -- remove prefix "rolout-" from directory name

		title = ( dotNetObject "System.Text.RegularExpressions.Regex" @"^[\.\s_-]+|^[\d]+[_-]" ).Replace ( trimLeft title "_ " ) "" -- remove prefix

		title = substituteString title "_" " " -- replace whitespace
	),

	on create do
	(
		--format "\n"; print "ContentRollout_v.onCreate()"
		--format "this.path	= % \n" this.path
		--format "ini_file	= % \n" ini_file
		ConstructPropeties test:this

		this._setRolloutTitle()

		PathsLoader = PathsLoader_v path:path

		PathsLoader.fileInMaxscriptFiles()

		if ini_file == undefined then
			ini_file = PathsLoader.ini_files[1]

		this._initLoadContentFromDir()
	)
)
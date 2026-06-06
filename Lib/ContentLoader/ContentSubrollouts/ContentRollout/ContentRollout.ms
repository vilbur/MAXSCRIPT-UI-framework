filein( getFilenamePath(getSourceFileName()) + "/PathsLoader/PathsLoader.ms" )	-- "./PathsLoader/PathsLoader.ms"
filein( getFilenamePath(getSourceFileName()) + "/ScriptFile/ScriptFile.ms" )	-- "./ScriptFile/ScriptFile.ms"
filein( getFilenamePath(getSourceFileName()) + "/../ContentSubrollouts.ms" )	-- "./../ContentSubrollouts.ms"

/** Create ROLLOUT from dir containing ".ms" & ".mcr" files
 *
 * @property	string	dir	Path to dir
 * @property	string	title	Name of rollout
 *
 */
struct ContentRollout_v
(
	__construct = #( #_path ),

	/* construct */
	_path,

	/*  properties */
	title,

	Subrollouts_and_Controls = #(), -- store groupboxes and rollouts

	ini_file, -- _path to ini file in Rollout folder

	PathsLoader,

	/** Create and add Rollouts and Controls to UI
	 */
	function addToUi Subrollouts =
	(
		--print ( "ContentRollout_v.addToUi (Subrollouts:" + Subrollouts.slot as string +")"  )
		--format "TITLE: %\n" TITLE
		--format "ini_file	= % \n" ini_file
		Rollout_new	= Subrollouts.Roll title -- get new rollout

		--format "PATH: %\n" PATH
		--format "Rollout_new: %\n" Rollout_new
		Rollout_new.addlocal ( #CONTENT_PATH ) (PATH)


		this._setRolloutPropertiesFromIniFile(Rollout_new)
	
	
		for Subrollouts_or_Controls in Subrollouts_and_Controls do
			Subrollouts_or_Controls.addToUi Rollout_new
	
	),

	/** Get new instance of This
	 */
	function createNewRollout _path ini_file =
	(
		ContentRollout_v _path:_path ini_file:ini_file --return
	),

	private

	/*------------------------------------------------------------------------------
		LOAD ROLLOUTS AND CONTROLS FROM FILES
	--------------------------------------------------------------------------------*/
	/** 
	 */
	function _initLoadContentFromDir =
	(
		--format "\n"; print "ContentRollout_v._initLoadContentFromDir()"
		for _path in (PathsLoader.getSubrolloutsAndControlsPaths()) do
			append Subrollouts_and_Controls	(this._addSubrolloutOrControlBox _path)
	),

	/** _add subrollout or control box
	 */
	function _addSubrolloutOrControlBox _path =
	(
		if (this._isDir _path) then
			this._createSubrolloutsSlots _path
		else
			this._getFileContent _path
	),

	/** _if _path is dir
	 */
	function _createSubrolloutsSlots _path =
	(
		--format "\n"; print "ContentRollout_v._createSubrolloutsSlots()"
		--format "ini_file	= % \n" ini_file
		ContentSubrollouts_v _path:_path RolloutParrent:this ini_file:ini_file    -- return
	),

	/** If _path is file
	 */
	function _getFileContent _path =
	(
		--filein _path

		ScriptFile_Content_v _path:_path	-- return
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
					FORMAT "-----------------\n\nERROR: Set property with ini file %\n\nRollout has not property: %\n\n-----------------" ini_file prop_name
			)
		)

		_Rollout --return
	),

	/** _is dir
	 */
	function _isDir _path =
	(
		getFilenameType _path == "" --return
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
		--format "\n"; print "ContentRollout_v._setRolloutTitle()"
		if title == undefined then
		(
			title = filenameFromPath _path
	
			title = trimRight title "\\" --remove backslash from directory name
	
			title = ( dotNetObject "System.Text.RegularExpressions.Regex" "^rollout-" ).Replace title "" -- remove prefix "rolout-" from directory name
	
			title = ( dotNetObject "System.Text.RegularExpressions.Regex" @"^[\.\s_-]+|^[\d]+[_-]" ).Replace ( trimLeft title "_ " ) "" -- remove prefix
	
			title = substituteString title "_" " " -- replace whitespace
		)
	),

	on create do
	(
		--format "\n"; print "ContentRollout_v.onCreate()"
		--format "this._path	= % \n" this._path
		--format "ini_file	= % \n" ini_file
		ConstructPropeties test:this

		this._setRolloutTitle()

		
		PathsLoader = PathsLoader_v _path:_path

		PathsLoader.fileInMaxscriptFiles()

		
		if ini_file == undefined then
			ini_file = PathsLoader.ini_files[1]

			
		this._initLoadContentFromDir()
	)
)















clearListener(); print("Cleared in:\n"+getSourceFileName())

/** RolloutCreator_v

  -- RolloutCreator: https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_5FC5036F_E2D7_46C9_9AFA_7B3550B9F254_htm

 */
filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"


/** Dialog creator
 */
struct DialogCreatorStruct_v
(
	/* construct */
	
	/* required */
	
	/* properties */
	
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	/** Dialog create
	 */
	function dialogCreate =
	(
		--format "\n"; print "DialogCreatorStruct_v.dialogCreate()"
		Dialog 	= Dialog_v title:"Test"
		
		Dialog.addLocal #DialogCreatorStruct this

		_Controls   = Dialog.Controls()
		
		_Button = _Controls.control #BUTTON "Test"
		
		_Button.Event #Pressed ( "DIALOG_test.DialogCreatorStruct.testMethod()")

		Dialog.create()
	),
	
	/** Test method
	 */
	function testMethod =
	(
		format "\n"; print "DialogCreatorStruct_v.testMethod()"
		format "getFilenameFile(getSourceFileName()): %\n" (getFilenameFile(getSourceFileName()))
	),
	
	private
	

	/**
	 */
	on create do
	(
		--format "\n"; print "DialogCreatorStruct.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)


DialogCreatorStruct = DialogCreatorStruct_v()

DialogCreatorStruct.dialogCreate()


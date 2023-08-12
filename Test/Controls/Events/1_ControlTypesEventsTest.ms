clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/Dialog/Dialog.ms" ) -- "./../../../Lib/Dialog/Dialog.ms"

/* DIALOG */
Dialog 	    = Dialog_v title:"Test"

_Controls   = Dialog.Controls group:"Main Controls"

/**
  *
  */
function testCallback val =
(
	format "\n"; print "testCallback()"

	format "EventFired:	% \n" EventFired

	format "val:	% \n" val
)


/* BUTTON  */
 _Button	= _Controls.control #button "Button"

 _Button.Events.add #pressed    ("testCallback") params:"Test Param"
 _Button.Events.add #rightclick ("testCallback") params: #(999)


/* EDITTEXT  */
_EditText = _Controls.control #editText "EditTextControl" across:1 -- #Mode:#getSavePath is default

_EditText.Events.add #changed ("testCallback")
_EditText.Events.add #entered ("testCallback") -- Called when the user enters text in the edit box and then presses ENTER or TAB to move the cursor out of the field.


/* BROWSE PATH  */
_OpenFileName = _Controls.control #browsePath "OpenFileName" params:#( #mode,#getOpenFileName, #tooltip, "Test Tooltip" )

 _OpenFileName.Events.add #changed ("testCallback")
 _OpenFileName.Events.add #entered ("testCallback") -- Called when the user enters text in the edit box and then presses ENTER or TAB to move the cursor out of the field.


/* DIALOG CREATE */
Dialog.create()
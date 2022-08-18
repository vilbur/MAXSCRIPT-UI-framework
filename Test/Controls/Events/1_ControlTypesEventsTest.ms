clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )

/* DIALOG */ 
Dialog 	    = Dialog_v title:"Test" 

_Controls   = Dialog.Controls group:"Main Controls"

fn testCallback val = (print val)


/* BUTTON  */
 --_Button	= _Controls.control #button "Button" params:#(#border, false )
 
-- _Button.Events.add #pressed    ("print (\"Button Pressed\")")
-- _Button.Events.add #rightclick ("print \"Button Rightclick\"")


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
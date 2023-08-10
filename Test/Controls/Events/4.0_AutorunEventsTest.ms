clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/Dialog/Dialog.ms" ) -- "./../../../Lib/Dialog/Dialog.ms"


/* DIALOG */
Dialog 	    = Dialog_v title:"Test" ini:(getSourceFileName())
--Dialog 	    = Dialog_v title:"Test"


/* CONTROLS */
--Controls   = Dialog.Controls group:"Main Controls"
Controls   = Dialog.Controls()

/*------ GROUPBOX ------*/
--Controls.control #Groupbox "Groupbox Test" height:64
--Controls.control #button "Button in Groupbox" params:#(#groupbox, "Groupbox Test")
--
--
--Controls.control #Groupbox "[Groupbox Hidden Label]" height:64
--Controls.control #button "Group Box without Label" params:#(#groupbox, "[Groupbox Hidden Label]") width:128 offset:[-32,0]


/*------ BUTTON ------*/
_Button = Controls.control #button "Button" id:#button_1
 _Button.Events.add #pressed ("format \"EventFired:	% \n\" EventFired") across:1 align:#right

/*------ CECKBUTTON ------*/
Checkbutton = Controls.control #checkbutton "checkbutton" across:1
 Checkbutton.Events.add #changed    ("print \"Checkbutton Event\"")

/*------ CHECKBOX ------*/
_Checkbox = Controls.control #checkbox "Checkbox"
_Checkbox.Events.add #changed    ("print \"Checkbox Event\"")


/*------ RADIOBUTTONS ------*/

/**
	RADIOBUTTONS ARE NOT Currently not supported

  */

--Controls.control #radioButtons "RadioButtons"	items:#("Item 1","Item 2")
--_Checkbox.Events.add #changed    ("print \"RadioButtons Event\"")





/* DIALOG CREATE */
--Dialog.create()
Dialog.create   width:320
--Dialog.create   width:1024

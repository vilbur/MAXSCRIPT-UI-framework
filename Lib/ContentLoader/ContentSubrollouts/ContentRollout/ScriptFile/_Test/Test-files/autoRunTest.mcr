


/*------------------------------------------------------------------------------
  Autorun macro when UI is loaded
------------------------------------------------------------------------------*/	



	
/*  
*/ 
macroscript macroFileTest_checkbox_autorun
	category:	"MacroFileTest"
	buttontext:	"Auto run on startup"
	toolTip:	"Changed event tooltip"
	--icon:	"type:checkbox"
	icon:	"type:checkbox|checked:true"
	--icon:	"type:checkbox|event:#rightClick"
(
	--print "AutoRun"
	messageBox "Auto run on startup"  beep:false
)
	
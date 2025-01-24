


/*------------------------------------------------------------------------------
  Autorun macro when UI is loaded
------------------------------------------------------------------------------*/	



	
/*  
*/ 
macroscript macroFileTest_checkbox_autorun
	category:	"MacroFileTest"
	buttontext:	"Auto run on startup"
	toolTip:	"Changed event tooltip"
	--icon:	"control:checkbox"
	icon:	"control:checkbox|checked:true"
	--icon:	"control:checkbox|event:#rightClick"
(
	--print "AutoRun"
	messageBox "Auto run on startup"  beep:false
)
	
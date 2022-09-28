clearListener()


filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )


Dialog 	= Dialog_v "Escape key disabled"
Dialog_escape 	= Dialog_v "Escape key to quit"


Dialog_escape.create()

Dialog.create escapekey:false
clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )


/* DIALOG */ 
Dialog     = Dialog_v title:"Test default"
Dialog.create()


Dialog_screen     = Dialog_v title:"Position in screen origin"
Dialog_screen.create pos:[256,256]


Dialog_window     = Dialog_v title:"Position window is origin"
Dialog_window.create pos:[256,256] origin:#window

Dialog_mouse     = Dialog_v title:"Position position mouse"
Dialog_mouse.create pos:#mouse

Dialog_ini = Dialog_v title:"Ini saved position, TRY DOCK STATE"  ini:(getSourceFileName()) 
Dialog_ini.create()
Dialog_ini.register()
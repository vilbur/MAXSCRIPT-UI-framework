clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )


/* DEFAULT POSITION */ 
Dialog     = Dialog_v title:"Test default"
Dialog.create()


/* ABSOLUTE POSITION */ 
Dialog_screen     = Dialog_v title:"Position in screen origin"
Dialog_screen.create pos:[256,256]


/* RELATIVE POSITION TO 3Ds MAX WINDOW */ 
Dialog_window     = Dialog_v title:"Position window is origin"
Dialog_window.create pos:[256,256] origin:#window

/* MOUSE CURSOR POSITION */ 
Dialog_mouse     = Dialog_v title:"Position position mouse"
Dialog_mouse.create pos:#mouse

/* INI SAVED POSITION */ 
Dialog_ini = Dialog_v title:"Ini saved position, TRY DOCK STATE"  ini:(getSourceFileName()) 
Dialog_ini.create()
Dialog_ini.register()
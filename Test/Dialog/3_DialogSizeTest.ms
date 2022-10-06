clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )


/* DEFAULT SIZE */ 
Dialog     = Dialog_v title:"Test default"
Dialog.create()
Dialog.register()


/* DEFINED SIZE */ 
--Dialog_size     = Dialog_v title:"Defined size"
--Dialog_size.create width:256 height:256 lockWidth:false -- given size is minimal size of dialog also
--Dialog_size.register()


/* INI SAVED SIZE */ 
--Dialog_ini = Dialog_v title:"Ini saved size"  ini:(getSourceFileName()) 
--Dialog_ini.create lockWidth:false




-- Dialog.create width:512 height:256

-- Dialog.register()

--/* ABSOLUTE SIZE */ 
--Dialog_screen     = Dialog_v title:"Position in screen origin"
--Dialog_screen.create pos:[256,256]
--
--
--/* RELATIVE SIZE TO 3Ds MAX WINDOW */ 
--Dialog_window     = Dialog_v title:"Position window is origin"
--Dialog_window.create pos:[256,256] origin:#window
--
--/* MOUSE CURSOR SIZE */ 
--Dialog_mouse     = Dialog_v title:"Position position mouse"
--Dialog_mouse.create pos:#mouse
--

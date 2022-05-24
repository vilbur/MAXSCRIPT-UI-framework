clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )


/* DIALOG */ 
Dialog     = Dialog_v title:"Test without ini"
Dialog.create()


Dialog_ini = Dialog_v title:"Test with ini"  ini:(getSourceFileName())
Dialog_ini.create()
clearListener()

filein( "c:\GoogleDrive\Programs\CG\3DsMax\scripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )

-- Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))  ini:( getSourceFileName())
-- Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))
Dialog 	= Dialog_v title:"Group"

--Dialog.ini.delete()

_Controls = Dialog.Controls group:"Test Dialog"

for i = 1 to 10 do 
	_Controls.control #button ("Button "+ i as string ) across:1


/* CREATE DIALOG */ 
Dialog.create()
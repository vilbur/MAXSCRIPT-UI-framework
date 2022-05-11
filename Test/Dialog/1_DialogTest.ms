clearListener()


--filein( getFilenamePath(getSourceFileName()) + "/../../../UI/Lib/Dialog/Dialog.ms" )
filein( "c:\GoogleDrive\Programs\CG\3DsMax\scripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )
--filein( getFilenamePath(getSourceFileName()) + "\..\..\..\UI\Lib\Dialog\Dialog.ms" )

--format "_path	= % \n" _path

--try( destroyDialog ROLLOUT_test )catch()
--
_Dialog 	= Dialog_v title:"Test"

_Dialog.create()
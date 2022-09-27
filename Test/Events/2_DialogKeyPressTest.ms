clearListener()


filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )

try( destroyDialog ROLLOUT_test )catch()


Dialog 	= Dialog_v "Test"


Dialog.create()
--Dialog.create bgcolor:(color 32 255 32 ) escapeEnable:false

----Dialog.register()